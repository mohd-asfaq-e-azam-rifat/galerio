abstract class PhotoEvent {}

class AlbumListRequested extends PhotoEvent {}

class AlbumThumbnailRequested extends PhotoEvent {
  final String albumId;

  AlbumThumbnailRequested(this.albumId);
}
