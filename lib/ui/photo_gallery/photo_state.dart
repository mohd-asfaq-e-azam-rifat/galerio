import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:galerio/base/state/basic/basic_state.dart';
import 'package:galerio/data/model/local/album/album.dart';
import 'package:galerio/data/model/local/media_page/media_page.dart';

class PhotoState extends Equatable {
  final UiState uiState;
  final String? message;

  const PhotoState({
    this.uiState = UiState.initial,
    this.message,
  });

  PhotoState copyWith({
    UiState? uiState,
    String? message,
  }) {
    return PhotoState(
      uiState: uiState ?? this.uiState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        uiState,
        message,
      ];
}

class AlbumListState extends PhotoState {
  final List<Album>? albums;

  const AlbumListState({
    super.uiState,
    super.message,
    this.albums,
  });

  @override
  AlbumListState copyWith({
    List<Album>? albums,
    UiState? uiState,
    String? message,
  }) {
    return AlbumListState(
      albums: albums ?? this.albums,
      uiState: uiState ?? this.uiState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        uiState,
        message,
        albums,
      ];
}

class AlbumThumbnailState extends PhotoState {
  final Uint8List? thumbnail;

  const AlbumThumbnailState({
    super.uiState,
    super.message,
    this.thumbnail,
  });

  @override
  AlbumThumbnailState copyWith({
    Uint8List? file,
    UiState? uiState,
    String? message,
  }) {
    return AlbumThumbnailState(
      thumbnail: file ?? this.thumbnail,
      uiState: uiState ?? this.uiState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        uiState,
        message,
        thumbnail,
      ];
}

class AlbumMediaListState extends PhotoState {
  final MediaPage? page;

  const AlbumMediaListState({
    super.uiState,
    super.message,
    this.page,
  });

  @override
  AlbumMediaListState copyWith({
    MediaPage? page,
    UiState? uiState,
    String? message,
  }) {
    return AlbumMediaListState(
      page: page ?? this.page,
      uiState: uiState ?? this.uiState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        uiState,
        message,
        page,
      ];
}

class MediaThumbnailState extends PhotoState {
  final Uint8List? thumbnail;

  const MediaThumbnailState({
    super.uiState,
    super.message,
    this.thumbnail,
  });

  @override
  MediaThumbnailState copyWith({
    Uint8List? thumbnail,
    UiState? uiState,
    String? message,
  }) {
    return MediaThumbnailState(
      thumbnail: thumbnail ?? this.thumbnail,
      uiState: uiState ?? this.uiState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        uiState,
        message,
        thumbnail,
      ];
}

class MediaDetailsState extends PhotoState {
  final File? file;

  const MediaDetailsState({
    super.uiState,
    super.message,
    this.file,
  });

  @override
  MediaDetailsState copyWith({
    File? file,
    UiState? uiState,
    String? message,
  }) {
    return MediaDetailsState(
      file: file ?? this.file,
      uiState: uiState ?? this.uiState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        uiState,
        message,
        file,
      ];
}
