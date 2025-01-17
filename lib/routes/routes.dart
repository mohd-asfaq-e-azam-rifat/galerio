import 'dart:core';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galerio/data/model/local/album/album.dart';
import 'package:galerio/data/model/local/medium/medium.dart';
import 'package:galerio/injection.dart';
import 'package:galerio/ui/photo_gallery/album/album_page.dart';
import 'package:galerio/ui/photo_gallery/album_details/album_details_page.dart';
import 'package:galerio/ui/photo_gallery/photo_previewer/photo_previewer_page.dart';
import 'package:galerio/ui/request_permission/request_permission_page.dart';
import 'package:galerio/ui/splash_screen/splash_screen.dart';

class Routes {
  static String initialRoute = Routes.root;

  static const root = "galerio://";
  static const requestPermission = "galerio://request-permission";
  static const album = "galerio://album";
  static const albumDetails = "galerio://album/details";
  static const photoPreviewer = "galerio://album/details/photo-previewer";
}

List<String> get routes {
  return [
    Routes.root,
    Routes.requestPermission,
    Routes.album,
    Routes.albumDetails,
    Routes.photoPreviewer,
  ];
}

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  PageRoute<T> buildRoute<T>({
    required WidgetBuilder builder,
    bool isFullScreenDialog = false,
    bool isCancelable = false,
    bool isCupertino = false,
  }) {
    if (isCupertino == true) {
      return CupertinoPageRoute<T>(
        builder: builder,
        fullscreenDialog: isFullScreenDialog,
        barrierDismissible: isCancelable,
      );
    } else {
      return MaterialPageRoute<T>(
        builder: builder,
        fullscreenDialog: isFullScreenDialog,
        barrierDismissible: isCancelable,
      );
    }
  }

  if (settings.name == null) {
    return null;
  }

  switch (settings.name!) {
    case Routes.root:
      return buildRoute(
        builder: (_) => const SplashScreen(),
      );

    case Routes.requestPermission:
      return buildRoute(
        builder: (_) => RequestPermissionPage(
          getIt<AndroidDeviceInfo>(),
        ),
      );

    case Routes.album:
      return buildRoute(
        builder: (_) => const AlbumPage(),
      );

    case Routes.albumDetails:
      final arguments = settings.arguments as List<dynamic>;
      return buildRoute(
        builder: (_) => AlbumDetailsPage(
          album: arguments[0] as Album,
        ),
      );

    case Routes.photoPreviewer:
      final arguments = settings.arguments as List<dynamic>;
      return buildRoute(
        builder: (_) => PhotoPreviewerPage(
          item: arguments[0] as Medium,
        ),
      );

    default:
      return null;
  }
}
