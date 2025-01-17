import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galerio/base/state/basic/basic_state.dart';
import 'package:galerio/data/extensions.dart';
import 'package:galerio/data/repository/photo_repository.dart';
import 'package:galerio/ui/photo_gallery/photo_event.dart';
import 'package:galerio/ui/photo_gallery/photo_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final PhotoRepository _photoRepository;

  PhotoBloc(this._photoRepository) : super(PhotoState()) {
    on<AlbumListRequested>(_onAlbumListRequested);
    on<AlbumThumbnailRequested>(_onAlbumThumbnailRequested);
  }

  Future<void> _onAlbumListRequested(
    AlbumListRequested event,
    Emitter<PhotoState> emit,
  ) async {
    try {
      emit(
        AlbumListState(uiState: UiState.loading),
      );

      final albums = await _photoRepository.getAlbums();

      if (albums.isNotEmpty == true) {
        emit(
          (state as AlbumListState).copyWith(
            uiState: UiState.successful,
            thumbnail: albums,
          ),
        );
      } else {
        emit(
          state.copyWith(
            uiState: UiState.error,
            message: "No album found",
          ),
        );
      }
    } on Exception catch (e) {
      emit(
        state.copyWith(
          uiState: UiState.error,
          message: e.getErrorMessage(),
        ),
      );
    }
  }

  Future<void> _onAlbumThumbnailRequested(
    AlbumThumbnailRequested event,
    Emitter<PhotoState> emit,
  ) async {
    try {
      emit(
        AlbumThumbnailState(uiState: UiState.loading),
      );

      final thumbnail = await _photoRepository.getAlbumThumbnail(event.albumId);

      if (thumbnail != null) {
        emit(
          (state as AlbumThumbnailState).copyWith(
            uiState: UiState.successful,
            thumbnail: thumbnail,
          ),
        );
      } else {
        emit(
          state.copyWith(
            uiState: UiState.error,
            message: "No thumbnail found",
          ),
        );
      }
    } on Exception catch (e) {
      emit(
        state.copyWith(
          uiState: UiState.error,
          message: e.getErrorMessage(),
        ),
      );
    }
  }
}
