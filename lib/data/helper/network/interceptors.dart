import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:galerio/base/di/app_module.dart';
import 'package:galerio/constants.dart';
import 'package:galerio/data/service/local/auth_local_service.dart';
import 'package:galerio/data/service/local/common_local_service.dart';
import 'package:galerio/injection.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@injectable
@singleton
class BaseInterceptor extends Interceptor {
  late CommonLocalService _globalProvider;
  late AuthLocalService _authProvider;
  late Uuid _uuid;

  BaseInterceptor() {
    _uuid = const Uuid();
    _globalProvider = getIt<CommonLocalService>();
    _authProvider = getIt<AuthLocalService>();
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final accessToken = _authProvider.getAuthToken();
    final language = _globalProvider.getLanguage()?.languageCode ?? 'en';
    final theme = _globalProvider.getThemeMode()?.name ?? ThemeMode.light.name;
    final requiresAuth =
        options.headers.remove(CustomHttpHeader.requiresAuth) as bool?;

    options.headers.addAll(
      {
        HttpHeaders.acceptHeader: CustomHttpHeaderValue.applicationJson,
        CustomHttpHeader.serviceName: CustomHttpHeaderValue.app,
        CustomHttpHeader.uuid: _uuid.v4(),
        CustomHttpHeader.theme: theme,
        HttpHeaders.userAgentHeader: appInfo.userAgent ?? "",
        HttpHeaders.acceptLanguageHeader: language,
        if (requiresAuth == true && accessToken != null)
          CustomHttpHeader.authorization: accessToken,
      },
    );
    super.onRequest(options, handler);
  }
}
