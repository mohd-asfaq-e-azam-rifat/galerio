import 'dart:io';
import 'dart:isolate';

import 'package:flutter/services.dart';
import 'package:galerio/data/model/local/album/album.dart';
import 'package:galerio/data/model/local/media_page/media_page.dart';
import 'package:galerio/data/model/local/medium/medium.dart';
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

  Future<MediaPage?> getMedias({
    required Album album,
    int? skip,
    int? take,
    bool? lightWeight,
  }) async {
    return Isolate.run<MediaPage?>(
      () {
        BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
        return _localService.getMedias(
          album: album,
          skip: skip,
          take: take,
          lightWeight: lightWeight,
        );
      },
    );
  }

  Future<MediaPage?> getNextMedias({
    required Album album,
    int? endingIndex,
    int? take,
    bool? lightWeight,
  }) {
    return Isolate.run<MediaPage?>(
      () {
        BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
        return _localService.getMedias(
          album: album,
          skip: endingIndex,
          take: take,
          lightWeight: lightWeight,
        );
      },
    );
  }

  Future<Uint8List?> getAlbumThumbnail({
    required String albumId,
    bool newest = true,
    int? width,
    int? height,
    bool? highQuality = true,
  }) async {
    return Isolate.run<Uint8List?>(
      () {
        BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
        return _localService.getAlbumThumbnail(
          albumId: albumId,
          newest: newest,
          width: width,
          height: height,
          highQuality: highQuality,
        );
      },
    );
  }

  Future<Uint8List?> getThumbnail({
    required String mediumId,
    int? width,
    int? height,
    bool? highQuality = true,
  }) async {
    return Isolate.run<Uint8List?>(
      () {
        BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
        return _localService.getThumbnail(
          mediumId: mediumId,
          width: width,
          height: height,
          highQuality: highQuality,
        );
      },
    );
  }

  Future<Medium?> getMedium({
    required String mediumId,
  }) async {
    return Isolate.run<Medium?>(
      () {
        BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
        return _localService.getMedium(mediumId: mediumId);
      },
    );
  }

  Future<File?> getFile({
    required String mediumId,
    String? mimeType,
  }) async {
    return Isolate.run<File?>(
      () {
        BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
        return _localService.getFile(
          mediumId: mediumId,
          mimeType: mimeType,
        );
      },
    );
  }

  Future<void> cleanCache() async {
    return Isolate.run<void>(
      () {
        BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
        return _localService.cleanCache();
      },
    );
  }
}
