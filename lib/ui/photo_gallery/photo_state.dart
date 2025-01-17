import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:galerio/base/state/basic/basic_state.dart';
import 'package:galerio/data/model/local/album/album.dart';

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
    List<Album>? thumbnail,
    UiState? uiState,
    String? message,
  }) {
    return AlbumListState(
      albums: thumbnail ?? this.albums,
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
    Uint8List? thumbnail,
    UiState? uiState,
    String? message,
  }) {
    return AlbumThumbnailState(
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
