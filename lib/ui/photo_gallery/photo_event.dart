import 'package:galerio/data/model/local/album/album.dart';

abstract class PhotoEvent {}

class AlbumListRequested extends PhotoEvent {}

class AlbumThumbnailRequested extends PhotoEvent {
  final String albumId;

  AlbumThumbnailRequested(this.albumId);
}

class AlbumMediasRequested extends PhotoEvent {
  final Album album;
  final int? skip;
  final int? take;

  AlbumMediasRequested(this.album, this.skip, this.take);
}

class MediaThumbnailRequested extends PhotoEvent {
  final String mediaId;

  MediaThumbnailRequested(this.mediaId);
}

class MediaDetailsRequested extends PhotoEvent {
  final String mediaId;

  MediaDetailsRequested(this.mediaId);
}