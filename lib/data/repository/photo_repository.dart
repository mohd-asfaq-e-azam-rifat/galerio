import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:galerio/data/model/local/album/album.dart';
import 'package:galerio/data/service/local/photo_local_service.dart';
import 'package:galerio/data/service/remote/photo_remote_service.dart';
import 'package:injectable/injectable.dart';

@injectable
@singleton
class PhotoRepository {
  final PhotoLocalService _localService;
  final PhotoRemoteService _remoteService;

  RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;

  PhotoRepository(
    this._localService,
    this._remoteService,
  );

  Future<List<Album>> getAlbums() async {
    return Isolate.run<List<Album>>(
      () {
        BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
        return _localService.getAlbums();
      },
    );
  }

  Future<Uint8List?> getAlbumThumbnail(String albumId) async {
    return Isolate.run<Uint8List?>(
      () {
        BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
        return _localService.getAlbumThumbnail(albumId);
      },
    );
  }
}
