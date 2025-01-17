import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galerio/base/navigation/navigation.dart';
import 'package:galerio/base/state/basic/basic_state.dart';
import 'package:galerio/base/widget/loader/base_data_loader.dart';
import 'package:galerio/base/widget/toast/toast.dart';
import 'package:galerio/constants.dart';
import 'package:galerio/data/model/local/album/album.dart';
import 'package:galerio/data/model/local/medium/medium.dart';
import 'package:galerio/injection.dart';
import 'package:galerio/routes/routes.dart';
import 'package:galerio/ui/photo_gallery/photo_bloc.dart';
import 'package:galerio/ui/photo_gallery/photo_event.dart';
import 'package:galerio/ui/photo_gallery/photo_state.dart';

class AlbumDetailsPage extends StatelessWidget {
  final Album album;

  const AlbumDetailsPage({
    super.key,
    required this.album,
  });

  PhotoBloc _getBloc(BuildContext context) {
    final bloc = getIt<PhotoBloc>();
    bloc.add(
      AlbumMediasRequested(album, null, null),
    );

    return bloc;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    final appBarTheme = Theme.of(context).appBarTheme;

    return BlocProvider(
      create: (context) => _getBloc(context),
      child: BlocListener<PhotoBloc, PhotoState>(
        listener: (context, state) {
          if (state.uiState.isError == true) {
            if (state.message?.trim().isNotEmpty == true) {
              showToast(message: state.message!.trim());
            }
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 20.0,
                color: colorText1,
              ),
              onPressed: () {
                context.back();
              },
            ),
            title: Text(album.name ?? ""),
            titleTextStyle: textStyleAppBarTitle2,
            systemOverlayStyle: appBarTheme.systemOverlayStyle?.copyWith(
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarIconBrightness: Brightness.light,
              systemNavigationBarDividerColor: Colors.transparent,
              systemNavigationBarContrastEnforced: false,
            ),
          ),
          body: BlocBuilder<PhotoBloc, PhotoState>(
            builder: (context, state) {
              if (state.uiState.isLoading == true) {
                return Center(
                  child: BaseDataLoader(),
                );
              } else if (state.uiState.isSuccessful == true &&
                  (state as AlbumMediaListState).page?.items.isNotEmpty ==
                      true) {
                final list = state.page?.items ?? [];

                return GridView.builder(
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // 4 items per row
                    crossAxisSpacing: 4.0, // space between items horizontally
                    mainAxisSpacing: 4.0, // space between items vertically
                    childAspectRatio: 1, // width and height are the same
                  ),
                  itemCount: list.length,
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  itemBuilder: (context, index) {
                    return AlbumMediaWidget(item: list[index]);
                  },
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}

class AlbumMediaWidget extends StatelessWidget {
  final Medium item;

  const AlbumMediaWidget({
    super.key,
    required this.item,
  });

  PhotoBloc _getBloc(BuildContext context) {
    final bloc = getIt<PhotoBloc>();
    bloc.add(MediaThumbnailRequested(item.id));

    return bloc;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getBloc(context),
      child: GestureDetector(
        onTap: () {
          context.to(
            Routes.photoPreviewer,
            arguments: [
              item,
            ],
          );
        },
        child: BlocBuilder<PhotoBloc, PhotoState>(
          builder: (context, state) {
            Uint8List? thumbnail;

            if (state.uiState.isSuccessful) {
              thumbnail = (state as MediaThumbnailState).thumbnail;
            }

            return Container(
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.8),
                image: thumbnail != null
                    ? DecorationImage(
                        fit: BoxFit.cover,
                        image: MemoryImage(
                          thumbnail,
                        ),
                      )
                    : null,
                borderRadius: BorderRadius.circular(5.0),
              ),
            );
          },
        ),
      ),
    );
  }
}
