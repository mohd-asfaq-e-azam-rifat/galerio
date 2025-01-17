package com.cantaloupe.galerio

import android.content.ContentResolver
import android.content.ContentUris
import android.database.Cursor
import android.database.Cursor.FIELD_TYPE_INTEGER
import android.graphics.Bitmap
import android.graphics.ImageDecoder
import android.os.Build
import android.provider.MediaStore
import android.util.Size
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import org.json.JSONArray
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileOutputStream
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

class MainActivity : FlutterActivity(), MethodCallHandler {
    companion object {
        const val CHANNEL = "photos"

        // Type
        const val IMAGE_TYPE = "image"

        // Album
        const val ALL_ALBUM_ID = "__ALL__"
        const val ALL_ALBUM_NAME = "All"

        // Projection
        val imageMetadataProjection = arrayOf(
            MediaStore.Images.Media._ID,
            MediaStore.Images.Media.DISPLAY_NAME,
            MediaStore.Images.Media.TITLE,
            MediaStore.Images.Media.WIDTH,
            MediaStore.Images.Media.HEIGHT,
            MediaStore.Images.Media.SIZE,
            MediaStore.Images.Media.ORIENTATION,
            MediaStore.Images.Media.MIME_TYPE,
            MediaStore.Images.Media.DATE_ADDED,
            MediaStore.Images.Media.DATE_MODIFIED
        )

        val imageBriefMetadataProjection = arrayOf(
            MediaStore.Images.Media._ID,
            MediaStore.Images.Media.WIDTH,
            MediaStore.Images.Media.HEIGHT,
            MediaStore.Images.Media.ORIENTATION,
            MediaStore.Images.Media.DATE_ADDED,
            MediaStore.Images.Media.DATE_MODIFIED
        )

        // Method
        const val METHOD_GET_ALBUMS = "getAlbums"
        const val METHOD_GET_MEDIAS = "getMedias"
        const val METHOD_GET_ALBUM_THUMBNAIL = "getAlbumThumbnail"
        const val METHOD_GET_THUMBNAIL = "getThumbnail"
        const val METHOD_GET_MEDIUM = "getMedium"
        const val METHOD_GET_FILE = "getFile"
        const val METHOD_CLEAN_CACHE = "cleanCache"
    }

    private val executor: ExecutorService = Executors.newSingleThreadExecutor()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            METHOD_GET_ALBUMS -> {
                executor.submit {
                    result.success(
                        listAlbums().toString()
                    )
                }
            }

            METHOD_GET_THUMBNAIL -> {
                val mediumId = call.argument<String>("mediumId")
                val width = call.argument<Int>("width")
                val height = call.argument<Int>("height")
                val highQuality = call.argument<Boolean>("highQuality")
                executor.submit {
                    result.success(
                        getImageThumbnail(mediumId!!, width, height, highQuality!!)?.toList()
                            ?: emptyList<Byte>()
                    )
                }
            }

            METHOD_GET_ALBUM_THUMBNAIL -> {
                val albumId = call.argument<String>("albumId")
                val newest = call.argument<Boolean>("newest")
                val width = call.argument<Int>("width")
                val height = call.argument<Int>("height")
                val highQuality = call.argument<Boolean>("highQuality")
                executor.submit {
                    result.success(
                        getImageAlbumThumbnail(
                            albumId!!,
                            newest!!,
                            width,
                            height,
                            highQuality!!
                        )?.toList() ?: emptyList<Byte>()
                    )
                }
            }

            METHOD_GET_MEDIAS -> {
                val albumId = call.argument<String>("albumId")
                val newest = call.argument<Boolean>("newest")
                val skip = call.argument<Int>("skip")
                val take = call.argument<Int>("take")
                val lightWeight = call.argument<Boolean>("lightWeight")
                executor.submit {
                    result.success(
                        getMedias(albumId!!, newest!!, skip, take, lightWeight)
                    )
                }
            }

            METHOD_GET_MEDIUM -> {
                val mediumId = call.argument<String>("mediumId")
                executor.submit {
                    result.success(
                        getMedium(mediumId!!)
                    )
                }
            }

            METHOD_GET_FILE -> {
                val mediumId = call.argument<String>("mediumId")
                val mimeType = call.argument<String>("mimeType")
                executor.submit {
                    result.success(
                        getFile(mediumId!!, mimeType)
                    )
                }
            }

            METHOD_CLEAN_CACHE -> {
                executor.submit {
                    result.success(
                        cleanCache()
                    )
                }
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private fun listAlbums(): JSONArray {
        this.context.run {
            var total = 0
            val albumHashMap = hashMapOf<String, HashMap<String, Any>>()

            val imageProjection = arrayOf(
                MediaStore.Images.Media.BUCKET_DISPLAY_NAME,
                MediaStore.Images.Media.BUCKET_ID
            )

            val imageCursor = this.contentResolver.query(
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                imageProjection,
                null,
                null,
                null
            )

            imageCursor?.use { cursor ->
                val bucketColumn =
                    cursor.getColumnIndex(MediaStore.Images.Media.BUCKET_DISPLAY_NAME)
                val bucketColumnId = cursor.getColumnIndex(MediaStore.Images.Media.BUCKET_ID)

                while (cursor.moveToNext()) {
                    val bucketId = cursor.getString(bucketColumnId)
                    val album = albumHashMap[bucketId]
                    if (album == null) {
                        val folderName = cursor.getString(bucketColumn)

                        albumHashMap[bucketId] = hashMapOf(
                            "id" to bucketId,
                            "name" to folderName,
                            "count" to 1,
                        )
                    } else {
                        val count = album["count"] as Int
                        album["count"] = count + 1
                    }
                    total++
                }
            }

            val albums = ArrayList<Map<String, *>>()
            albums.add(
                hashMapOf(
                    "id" to ALL_ALBUM_ID,
                    "name" to ALL_ALBUM_NAME,
                    "count" to total,
                )
            )

            // Add all albums from the albumHashMap to the list
            albumHashMap.values.forEach { album ->
                albums.add(album)
            }

            return JSONArray(albums)
        }
    }

    private fun getMedias(
        albumId: String,
        newest: Boolean,
        skip: Int?,
        take: Int?,
        lightWeight: Boolean? = false
    ): Map<String, Any?> {
        return getImages(albumId, newest, skip, take, lightWeight)
    }

    private fun getImages(
        albumId: String,
        newest: Boolean,
        skip: Int?,
        take: Int?,
        lightWeight: Boolean? = false
    ): Map<String, Any?> {
        val media = mutableListOf<Map<String, Any?>>()

        this.context.run {
            val projection = if (lightWeight == true) {
                imageBriefMetadataProjection
            } else {
                imageMetadataProjection
            }

            val imageCursor = getImageCursor(albumId, newest, projection, skip, take)

            imageCursor?.use { cursor ->
                while (cursor.moveToNext()) {
                    val metadata = if (lightWeight == true) {
                        getImageBriefMetadata(cursor)
                    } else {
                        getImageMetadata(cursor)
                    }

                    media.add(metadata)
                }
            }
        }

        return mapOf(
            "start" to (skip ?: 0),
            "items" to media
        )
    }

    private fun getMedium(mediumId: String): Map<String, Any?>? {
        return getImageMedia(mediumId)
    }

    private fun getImageMedia(mediumId: String): Map<String, Any?>? {
        return this.context.run {
            val imageCursor = this.contentResolver.query(
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                imageMetadataProjection,
                "${MediaStore.Images.Media._ID} = ?",
                arrayOf(mediumId),
                null
            )

            imageCursor?.use { cursor ->
                if (cursor.moveToFirst()) {
                    return@run getImageMetadata(cursor)
                }
            }

            return@run null
        }
    }

    private fun getImageMetadata(cursor: Cursor): Map<String, Any?> {
        val idColumn = cursor.getColumnIndex(MediaStore.Images.Media._ID)
        val filenameColumn = cursor.getColumnIndex(MediaStore.Images.Media.DISPLAY_NAME)
        val titleColumn = cursor.getColumnIndex(MediaStore.Images.Media.TITLE)
        val widthColumn = cursor.getColumnIndex(MediaStore.Images.Media.WIDTH)
        val heightColumn = cursor.getColumnIndex(MediaStore.Images.Media.HEIGHT)
        val sizeColumn = cursor.getColumnIndex(MediaStore.Images.Media.SIZE)
        val orientationColumn = cursor.getColumnIndex(MediaStore.Images.Media.ORIENTATION)
        val mimeColumn = cursor.getColumnIndex(MediaStore.Images.Media.MIME_TYPE)
        val dateAddedColumn = cursor.getColumnIndex(MediaStore.Images.Media.DATE_ADDED)
        val dateModifiedColumn = cursor.getColumnIndex(MediaStore.Images.Media.DATE_MODIFIED)

        val id = cursor.getLong(idColumn)
        val filename = cursor.getString(filenameColumn)
        val title = cursor.getString(titleColumn)
        val width = cursor.getLong(widthColumn)
        val height = cursor.getLong(heightColumn)
        val size = cursor.getLong(sizeColumn)
        val orientation = cursor.getLong(orientationColumn)
        val mimeType = cursor.getString(mimeColumn)
        var dateAdded: Long? = null
        if (cursor.getType(dateAddedColumn) == FIELD_TYPE_INTEGER) {
            dateAdded = cursor.getLong(dateAddedColumn) * 1000
        }
        var dateModified: Long? = null
        if (cursor.getType(dateModifiedColumn) == FIELD_TYPE_INTEGER) {
            dateModified = cursor.getLong(dateModifiedColumn) * 1000
        }

        return mapOf(
            "id" to id.toString(),
            "file_name" to filename,
            "title" to title,
            "mediumType" to IMAGE_TYPE,
            "width" to width,
            "height" to height,
            "size" to size,
            "orientation" to orientationDegree2Value(orientation),
            "mimeType" to mimeType,
            "creationDate" to dateAdded,
            "modifiedDate" to dateModified
        )
    }

    private fun getImageBriefMetadata(cursor: Cursor): Map<String, Any?> {
        val idColumn = cursor.getColumnIndex(MediaStore.Images.Media._ID)
        val widthColumn = cursor.getColumnIndex(MediaStore.Images.Media.WIDTH)
        val heightColumn = cursor.getColumnIndex(MediaStore.Images.Media.HEIGHT)
        val orientationColumn = cursor.getColumnIndex(MediaStore.Images.Media.ORIENTATION)
        val dateAddedColumn = cursor.getColumnIndex(MediaStore.Images.Media.DATE_ADDED)
        val dateModifiedColumn = cursor.getColumnIndex(MediaStore.Images.Media.DATE_MODIFIED)

        val id = cursor.getLong(idColumn)
        val width = cursor.getLong(widthColumn)
        val height = cursor.getLong(heightColumn)
        val orientation = cursor.getLong(orientationColumn)
        var dateAdded: Long? = null
        if (cursor.getType(dateAddedColumn) == FIELD_TYPE_INTEGER) {
            dateAdded = cursor.getLong(dateAddedColumn) * 1000
        }
        var dateModified: Long? = null
        if (cursor.getType(dateModifiedColumn) == FIELD_TYPE_INTEGER) {
            dateModified = cursor.getLong(dateModifiedColumn) * 1000
        }

        return mapOf(
            "id" to id.toString(),
            "mediumType" to IMAGE_TYPE,
            "width" to width,
            "height" to height,
            "orientation" to orientationDegree2Value(orientation),
            "creationDate" to dateAdded,
            "modifiedDate" to dateModified
        )
    }

    private fun getImageCursor(
        albumId: String,
        newest: Boolean = true,
        projection: Array<String>,
        skip: Int? = null,
        take: Int? = null,
    ): Cursor? {
        this.context.run {
            val isSelection = albumId != ALL_ALBUM_ID
            val selection = if (isSelection) "${MediaStore.Images.Media.BUCKET_ID} = ?" else null
            val selectionArgs = if (isSelection) arrayOf(albumId) else null
            val orderBy = if (newest) {
                "${MediaStore.Images.Media.DATE_ADDED} DESC, ${MediaStore.Images.Media.DATE_MODIFIED} DESC"
            } else {
                "${MediaStore.Images.Media.DATE_ADDED} ASC, ${MediaStore.Images.Media.DATE_MODIFIED} ASC"
            }

            val imageCursor: Cursor?

            if (Build.VERSION.SDK_INT > Build.VERSION_CODES.Q) {
                imageCursor = this.contentResolver.query(
                    MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                    projection,
                    android.os.Bundle().apply {
                        // Selection
                        putString(ContentResolver.QUERY_ARG_SQL_SELECTION, selection)
                        putStringArray(ContentResolver.QUERY_ARG_SQL_SELECTION_ARGS, selectionArgs)
                        // Sort
                        putString(ContentResolver.QUERY_ARG_SQL_SORT_ORDER, orderBy)
                        // Offset & Limit
                        if (skip != null) putInt(ContentResolver.QUERY_ARG_OFFSET, skip)
                        if (take != null) putInt(ContentResolver.QUERY_ARG_LIMIT, take)
                    },
                    null
                )
            } else {
                val offset = if (skip != null) "OFFSET $skip" else ""
                val limit = if (take != null) "LIMIT $take" else ""

                imageCursor = this.contentResolver.query(
                    MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                    projection,
                    selection,
                    selectionArgs,
                    "$orderBy $offset $limit"
                )
            }

            return imageCursor
        }
    }

    private fun getImageThumbnail(
        mediumId: String,
        width: Int? = null,
        height: Int? = null,
        highQuality: Boolean = true,
    ): ByteArray? {
        var byteArray: ByteArray? = null

        val bitmap: Bitmap? = this.context.run {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                try {
                    val widthSize = width ?: if (highQuality == true) 512 else 96
                    val heightSize = height ?: if (highQuality == true) 384 else 96
                    this.contentResolver.loadThumbnail(
                        ContentUris.withAppendedId(
                            MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                            mediumId.toLong()
                        ),
                        Size(widthSize, heightSize),
                        null
                    )
                } catch (e: Exception) {
                    null
                }
            } else {
                val kind =
                    if (highQuality == true) MediaStore.Images.Thumbnails.MINI_KIND
                    else MediaStore.Images.Thumbnails.MICRO_KIND
                MediaStore.Images.Thumbnails.getThumbnail(
                    this.contentResolver, mediumId.toLong(),
                    kind, null
                )
            }
        }
        bitmap?.run {
            ByteArrayOutputStream().use { stream ->
                this.compress(Bitmap.CompressFormat.JPEG, 100, stream)
                byteArray = stream.toByteArray()
            }
        }

        return byteArray
    }

    private fun getImageAlbumThumbnail(
        albumId: String,
        newest: Boolean = true,
        width: Int? = null,
        height: Int? = null,
        highQuality: Boolean = true,
    ): ByteArray? {
        return this.context.run {
            val projection = arrayOf(MediaStore.Images.Media._ID)

            val imageCursor = getImageCursor(albumId, newest, projection, null, 1)

            imageCursor?.use { cursor ->
                if (cursor.moveToFirst()) {
                    val idColumn = cursor.getColumnIndex(MediaStore.Images.Media._ID)
                    val id = cursor.getLong(idColumn)
                    return@run getImageThumbnail(id.toString(), width, height, highQuality)
                }
            }

            return@run null
        }
    }

    private fun orientationDegree2Value(degree: Long): Int {
        return when (degree) {
            0L -> 1
            90L -> 8
            180L -> 3
            270L -> 6
            else -> 0
        }
    }

    private fun getCachePath(): File {
        return this.context.run {
            val cachePath = File(this.cacheDir, "photo_gallery")
            if (!cachePath.exists()) {
                cachePath.mkdirs()
            }
            return@run cachePath
        }
    }

    private fun getFile(mediumId: String, mimeType: String?): String? {
        return getImageFile(mediumId, mimeType = mimeType)
    }

    private fun getImageFile(mediumId: String, mimeType: String? = null): String? {
        return this.context.run {
            mimeType?.let {
                val type = this.contentResolver.getType(
                    ContentUris.withAppendedId(
                        MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                        mediumId.toLong()
                    )
                )

                if (it != type) {
                    return@run cacheImage(mediumId, it)
                }
            }

            val imageCursor = this.contentResolver.query(
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                arrayOf(MediaStore.Images.Media.DATA),
                "${MediaStore.Images.Media._ID} = ?",
                arrayOf(mediumId),
                null
            )

            imageCursor?.use { cursor ->
                if (cursor.moveToNext()) {
                    val dataColumn = cursor.getColumnIndex(MediaStore.Images.Media.DATA)
                    return@run cursor.getString(dataColumn)
                }
            }

            return@run null
        }
    }

    private fun cacheImage(mediumId: String, mimeType: String): String? {
        val bitmap: Bitmap? = this.context.run {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                try {
                    ImageDecoder.decodeBitmap(
                        ImageDecoder.createSource(
                            this.contentResolver,
                            ContentUris.withAppendedId(
                                MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                                mediumId.toLong()
                            )
                        )
                    )
                } catch (e: Exception) {
                    null
                }
            } else {
                MediaStore.Images.Media.getBitmap(
                    this.contentResolver,
                    ContentUris.withAppendedId(
                        MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                        mediumId.toLong()
                    )
                )
            }
        }

        return bitmap?.let {
            val compressFormat: Bitmap.CompressFormat
            when (mimeType) {
                "image/jpeg" -> {
                    val path = File(getCachePath(), "$mediumId.jpeg")
                    val out = FileOutputStream(path)
                    compressFormat = Bitmap.CompressFormat.JPEG
                    it.compress(compressFormat, 100, out)
                    path.absolutePath
                }

                "image/png" -> {
                    val path = File(getCachePath(), "$mediumId.png")
                    val out = FileOutputStream(path)
                    compressFormat = Bitmap.CompressFormat.PNG
                    it.compress(compressFormat, 100, out)
                    path.absolutePath
                }

                "image/webp" -> {
                    val path = File(getCachePath(), "$mediumId.webp")
                    val out = FileOutputStream(path)
                    compressFormat = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                        Bitmap.CompressFormat.WEBP_LOSSLESS
                    } else {
                        Bitmap.CompressFormat.WEBP
                    }
                    it.compress(compressFormat, 100, out)
                    path.absolutePath
                }

                else -> {
                    null
                }
            }
        }
    }

    private fun cleanCache() {
        val cachePath = getCachePath()
        cachePath.deleteRecursively()
    }
}
