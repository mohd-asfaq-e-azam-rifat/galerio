import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galerio/ui/album/album_page.dart';
import 'package:galerio/ui/album_details/album_details_page.dart';
import 'package:galerio/ui/photo_previewer/photo_previewer_page.dart';
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
        builder: (_) => const RequestPermissionPage(),
      );

    case Routes.album:
      return buildRoute(
        builder: (_) => const AlbumPage(),
      );

    case Routes.albumDetails:
      return buildRoute(
        builder: (_) => const AlbumDetailsPage(),
      );

    case Routes.photoPreviewer:
      return buildRoute(
        builder: (_) => const PhotoPreviewerPage(),
      );

    default:
      return null;
  }
}
