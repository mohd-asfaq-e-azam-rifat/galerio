import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galerio/base/navigation/navigation.dart';
import 'package:galerio/base/state/basic/basic_state.dart';
import 'package:galerio/base/widget/loader/base_data_loader.dart';
import 'package:galerio/base/widget/toast/toast.dart';
import 'package:galerio/constants.dart';
import 'package:galerio/data/model/local/album/album.dart';
import 'package:galerio/injection.dart';
import 'package:galerio/routes/routes.dart';
import 'package:galerio/ui/photo_gallery/photo_bloc.dart';
import 'package:galerio/ui/photo_gallery/photo_event.dart';
import 'package:galerio/ui/photo_gallery/photo_state.dart';

class AlbumPage extends StatelessWidget {
  const AlbumPage({super.key});

  PhotoBloc _getBloc(BuildContext context) {
    final bloc = getIt<PhotoBloc>();
    bloc.add(AlbumListRequested());

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
            title: Text("Albums"),
            titleTextStyle: textStyleAppBarTitle1,
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
                  (state as AlbumListState).albums?.isNotEmpty == true) {
                final albums = state.albums!;

                return GridView.builder(
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 items per row
                    crossAxisSpacing: 4.0, // space between items horizontally
                    mainAxisSpacing: 6.0, // space between items vertically
                    childAspectRatio: 1, // width and height are the same
                  ),
                  itemCount: albums.length,
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  itemBuilder: (context, index) {
                    final item = albums[index];
                    return AlbumWidget(item: item);
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

class AlbumWidget extends StatelessWidget {
  const AlbumWidget({
    super.key,
    required this.item,
  });

  final Album item;

  PhotoBloc _getBloc(BuildContext context) {
    final bloc = getIt<PhotoBloc>();
    bloc.add(AlbumThumbnailRequested(item.id!));

    return bloc;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getBloc(context),
      child: GestureDetector(
        onTap: () async {
          context.to(
            Routes.albumDetails,
            arguments: [
              item,
            ],
          );
        },
        child: BlocBuilder<PhotoBloc, PhotoState>(
          builder: (context, state) {
            Uint8List? thumbnail;

            if (state.uiState.isSuccessful) {
              thumbnail = (state as AlbumThumbnailState).thumbnail;
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
                        colorFilter: ColorFilter.mode(
                          Colors.black.withValues(alpha: 0.5),
                          BlendMode.darken,
                        ),
                      )
                    : null,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 14.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.0,
                children: [
                  Text(
                    item.name ?? "",
                    style: textStyleAlbumTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "${item.count ?? 0} Photos",
                    style: textStyleAlbumSubtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
