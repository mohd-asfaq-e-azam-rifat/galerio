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
    on<AlbumMediasRequested>(_onAlbumMediaListRequested);
    on<AlbumThumbnailRequested>(_onAlbumThumbnailRequested);
    on<MediaThumbnailRequested>(_onMediaThumbnailRequested);
    on<MediaDetailsRequested>(_onMediaDetailsRequested);
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
            albums: albums,
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

      final thumbnail = await _photoRepository.getAlbumThumbnail(
        albumId: event.albumId,
      );

      if (thumbnail != null) {
        emit(
          (state as AlbumThumbnailState).copyWith(
            uiState: UiState.successful,
            file: thumbnail,
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

  Future<void> _onAlbumMediaListRequested(
    AlbumMediasRequested event,
    Emitter<PhotoState> emit,
  ) async {
    try {
      emit(
        AlbumMediaListState(uiState: UiState.loading),
      );

      final mediaPage = await _photoRepository.getMedias(
        album: event.album,
        skip: event.skip,
        take: event.take,
      );

      if (mediaPage != null) {
        emit(
          (state as AlbumMediaListState).copyWith(
            uiState: UiState.successful,
            page: mediaPage,
          ),
        );
      } else {
        emit(
          state.copyWith(
            uiState: UiState.error,
            message: "No media found",
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

  Future<void> _onMediaThumbnailRequested(
    MediaThumbnailRequested event,
    Emitter<PhotoState> emit,
  ) async {
    try {
      emit(
        MediaThumbnailState(uiState: UiState.loading),
      );

      final thumbnail = await _photoRepository.getThumbnail(
        mediumId: event.mediaId,
        highQuality: false,
      );

      if (thumbnail != null) {
        emit(
          (state as MediaThumbnailState).copyWith(
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

  Future<void> _onMediaDetailsRequested(
    MediaDetailsRequested event,
    Emitter<PhotoState> emit,
  ) async {
    try {
      emit(
        MediaDetailsState(uiState: UiState.loading),
      );

      final file = await _photoRepository.getFile(
        mediumId: event.mediaId,
      );

      if (file != null) {
        emit(
          (state as MediaDetailsState).copyWith(
            uiState: UiState.successful,
            file: file,
          ),
        );
      } else {
        emit(
          state.copyWith(
            uiState: UiState.error,
            message: "No file found",
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
