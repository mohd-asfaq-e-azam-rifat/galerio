import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:galerio/constants.dart';
import 'package:galerio/data/model/local/album/album.dart';
import 'package:galerio/data/model/local/album/uint8_list_converter.dart';
import 'package:injectable/injectable.dart';

@injectable
@lazySingleton
class PhotoLocalService {
  static const _channel = MethodChannel(MethodChannelX.channelName);

  PhotoLocalService();

  Future<List<Album>> getAlbums() async {
    final data = await _channel.invokeMethod(MethodChannelX.methodGetAlbums);
    final json = jsonDecode(data);

    return json
        .map<Album>(
          (e) => Album.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  Future<Uint8List?> getAlbumThumbnail(String albumId) async {
    final data = await _channel.invokeMethod(
      MethodChannelX.methodGetAlbumThumbnail,
      {
        'albumId': albumId,
      },
    );

    return byteArrayFromJson(data);
  }
}
