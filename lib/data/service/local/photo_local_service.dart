import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:galerio/constants.dart';
import 'package:galerio/data/model/local/album/album.dart';
import 'package:galerio/data/model/local/album/uint8_list_converter.dart';
import 'package:galerio/data/model/local/media_page/media_page.dart';
import 'package:galerio/data/model/local/medium/medium.dart';
import 'package:injectable/injectable.dart';

@injectable
@lazySingleton
class PhotoLocalService {
  static const _channel = MethodChannel(MethodChannelX.channelName);

  PhotoLocalService();

  Future<List<Album>> getAlbums({
    bool newest = true,
  }) async {
    final data = await _channel.invokeMethod(MethodChannelX.methodGetAlbums);
    final json = jsonDecode(data);

    return json.map<Album>(
      (e) {
        Album item = Album.fromJson(e as Map<String, dynamic>);
        item.isNewestOrder = newest;
        return item;
      },
    ).toList();
  }

  Future<Uint8List?> getAlbumThumbnail({
    required String albumId,
    bool newest = true,
    int? width,
    int? height,
    bool? highQuality = false,
  }) async {
    final data = await _channel.invokeMethod(
      MethodChannelX.methodGetAlbumThumbnail,
      {
        'albumId': albumId,
        'newest': newest,
        'width': width,
        'height': height,
        'highQuality': highQuality,
      },
    );

    return byteArrayFromJson(data);
  }

  Future<Uint8List?> getThumbnail({
    required String mediumId,
    int? width,
    int? height,
    bool? highQuality = false,
  }) async {
    final data = await _channel.invokeMethod(
      MethodChannelX.methodGetThumbnail,
      {
        'mediumId': mediumId,
        'width': width,
        'height': height,
        'highQuality': highQuality,
      },
    );

    return byteArrayFromJson(data);
  }

  Future<MediaPage?> getMedias({
    required Album album,
    int? skip,
    int? take,
    bool? lightWeight,
  }) async {
    final json = await _channel.invokeMethod(
      MethodChannelX.methodGetMedias,
      {
        'albumId': album.id,
        'newest': album.isNewestOrder ?? true,
        'skip': skip,
        'take': take,
        'lightWeight': lightWeight,
      },
    );

    return MediaPage.fromJson(album, json);
  }

  Future<Medium?> getMedium({
    required String mediumId,
  }) async {
    final data = await _channel.invokeMethod(
      MethodChannelX.methodGetMedium,
      {
        'mediumId': mediumId,
      },
    );

    final json = jsonDecode(data);

    return json != null ? Medium.fromJson(json) : null;
  }

  Future<File?> getFile({
    required String mediumId,
    String? mimeType,
  }) async {
    final path = await _channel.invokeMethod(
      MethodChannelX.methodGetFile,
      {
        'mediumId': mediumId,
        'mimeType': mimeType,
      },
    ) as String?;

    return path != null ? File(path) : null;
  }

  Future<void> cleanCache() async {
    return _channel.invokeMethod(MethodChannelX.methodCleanCache);
  }
}
