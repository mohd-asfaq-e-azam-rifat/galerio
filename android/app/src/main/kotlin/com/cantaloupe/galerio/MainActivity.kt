package com.cantaloupe.galerio

import android.content.ContentResolver
import android.content.ContentUris
import android.database.Cursor
import android.graphics.Bitmap
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
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

class MainActivity : FlutterActivity(), MethodCallHandler {
    companion object {
        const val CHANNEL = "photos"

        const val allAlbumId = "__ALL__"
        const val allAlbumName = "All"

        // Methods
        const val methodGetAlbums = "getAlbums"
        const val methodGetAlbumThumbnail = "getAlbumThumbnail"
    }

    private val executor: ExecutorService = Executors.newSingleThreadExecutor()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            methodGetAlbums -> {
                executor.submit {
                    result.success(
                        listAlbums().toString()
                    )
                }
            }

            methodGetAlbumThumbnail -> {
                val albumId = call.argument<String>("albumId")
                executor.submit {
                    result.success(
                        getImageAlbumThumbnail(albumId!!)?.toList() ?: emptyList<Byte>()
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
                    "id" to allAlbumId,
                    "name" to allAlbumName,
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

    private fun getImageCursor(
        albumId: String,
        newest: Boolean = true,
        projection: Array<String>,
        skip: Int? = null,
        take: Int? = null,
    ): Cursor? {
        this.context.run {
            val isSelection = albumId != allAlbumId
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
}
