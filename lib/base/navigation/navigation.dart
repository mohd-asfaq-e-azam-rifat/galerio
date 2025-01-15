import 'package:flutter/material.dart';
import 'package:galerio/data/model/local/exception/exceptions.dart';
import 'package:galerio/data/repository/auth_repository.dart';
import 'package:galerio/data/repository/common_repository.dart';
import 'package:galerio/injection.dart';
import 'package:galerio/routes/routes.dart';
import 'package:url_launcher/url_launcher.dart';

extension NavigationContextX on BuildContext {
  Map<String, String>? getArgs() {
    final args = ModalRoute.of(this)?.settings.arguments;
    return args is Map<String, String> ? args : null;
  }

  Future<T?> showBottomSheet<T>({
    required WidgetBuilder builder,
    bool isScrollControlled = true,
    bool useSafeArea = true,
  }) {
    return showModalBottomSheet(
      context: this,
      builder: builder,
      isScrollControlled: isScrollControlled,
      useSafeArea: useSafeArea,
    );
  }

  void back<T extends Object?>({T? result}) {
    Navigator.pop<T>(this, result);
  }

  Future<T?> to<T extends Object?>(
    String routeName, {
    Object? arguments,
    bool clearBackstack = false,
    bool requiresAuth = false,
  }) async {
    Future<R?> innerTo<R extends Object?>(
      String routeName, {
      Object? arguments,
      bool clearBackstack = false,
    }) {
      if (clearBackstack == true) {
        return Navigator.pushNamedAndRemoveUntil<R>(
          this,
          routeName,
          (route) => false,
          arguments: arguments,
        );
      } else {
        return Navigator.pushNamed<R>(
          this,
          routeName,
          arguments: arguments,
        );
      }
    }

    if (ModalRoute.of(this)?.settings.name == routeName) {
      return null;
    } else if (routeName.routeExists() == true) {
      if (requiresAuth == true &&
          getIt<AuthRepository>().isLoggedIn() == false) {
        await getIt<CommonRepository>().storeDestinationAfterLogin(routeName);
        return Future.error(
          UnauthenticatedException("Login to continue", routeName),
        );
      } else {
        return innerTo<T>(
          routeName,
          arguments: arguments,
          clearBackstack: clearBackstack,
        );
      }
    } else {
      return Future.error(
        ComingSoonFeatureException("Invalid URL found"),
      );
    }
  }

  Future<T?> replace<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed<T, TO>(
      this,
      routeName,
      arguments: arguments,
      result: result,
    );
  }
}

extension NavigationStringX on String {
  bool routeExists() {
    return routes.contains(this);
  }

  Future<T?> to<T extends Object?>(
    BuildContext context, {
    Object? arguments,
    bool clearBackstack = false,
    bool requiresAuth = false,
  }) async {
    return context.to<T>(
      this,
      arguments: arguments,
      clearBackstack: clearBackstack,
      requiresAuth: requiresAuth,
    );
  }

  Future<T?> replace<T extends Object?, TO extends Object?>(
    BuildContext context, {
    TO? result,
    Object? arguments,
  }) {
    return context.replace<T, TO>(this, result: result, arguments: arguments);
  }
}

extension UrlX on String {
  Future<bool> launchExternalUrl(BuildContext context) async {
    final url = Uri.tryParse(this);

    if (url != null) {
      try {
        return launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } on Exception catch (error) {
        final e = error.toString();
        return Future.error(
          AppException(
            "Could not launch the URL. "
            "${e.trim().isNotEmpty == true ? e.trim() : ""}",
          ),
        );
      }
    } else {
      return Future.error(AppException("Invalid URL found"));
    }
  }
}
