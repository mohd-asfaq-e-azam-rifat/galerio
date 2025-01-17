import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galerio/base/navigation/navigation.dart';
import 'package:galerio/base/state/basic/basic_state.dart';
import 'package:galerio/base/widget/loader/base_data_loader.dart';
import 'package:galerio/constants.dart';
import 'package:galerio/data/model/local/medium/medium.dart';
import 'package:galerio/injection.dart';
import 'package:galerio/ui/photo_gallery/photo_bloc.dart';
import 'package:galerio/ui/photo_gallery/photo_event.dart';
import 'package:galerio/ui/photo_gallery/photo_state.dart';

class PhotoPreviewerPage extends StatelessWidget {
  final Medium item;

  const PhotoPreviewerPage({super.key, required this.item});

  PhotoBloc _getBloc(BuildContext context) {
    final bloc = getIt<PhotoBloc>();
    bloc.add(MediaDetailsRequested(item.id));

    return bloc;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    final appBarTheme = Theme.of(context).appBarTheme;

    return BlocProvider(
      create: (context) => _getBloc(context),
      child: Scaffold(
        backgroundColor: colorPrimary,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 20.0,
              color: Colors.white,
            ),
            onPressed: () {
              context.back();
            },
          ),
          backgroundColor: Colors.transparent,
          systemOverlayStyle: appBarTheme.systemOverlayStyle?.copyWith(
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.light,
            systemNavigationBarDividerColor: Colors.transparent,
            systemNavigationBarContrastEnforced: false,
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
        ),
        body: BlocBuilder<PhotoBloc, PhotoState>(
          builder: (context, state) {
            File? file;

            if (state.uiState.isLoading == true) {
              return Center(
                child: BaseDataLoader(
                  customColor: Colors.white,
                ),
              );
            } else if (state.uiState.isSuccessful == true &&
                (state as MediaDetailsState).file != null) {
              file = state.file;

              return InteractiveViewer(
                panEnabled: true,
                maxScale: 4.0,
                child: Center(
                  child: Image.file(
                    file!,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
