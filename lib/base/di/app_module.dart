import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:galerio/base/app_config/app_config_state.dart';
import 'package:galerio/base/env/env.dart';
import 'package:galerio/constants.dart' as constants;
import 'package:galerio/data/helper/network/interceptors.dart';
import 'package:galerio/data/model/local/app_info/app_info.dart';
import 'package:galerio/injection.dart';
import 'package:get_storage/get_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

@module
abstract class AppModule {
  @preResolve
  @injectable
  @singleton
  Future<GetStorage> get getStorage async {
    await GetStorage.init();
    return GetStorage();
  }

  @preResolve
  @injectable
  @singleton
  Future<AndroidDeviceInfo> get androidInfo async {
    return DeviceInfoPlugin().androidInfo;
  }

  @preResolve
  @injectable
  @singleton
  Future<AppInfo> get appInfo async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    final appFlavor = AppFlavor.development;

    final platform = defaultTargetPlatform;

    String? deviceModel;
    String? deviceId = "unknown";
    String? manufacturer;
    String? platformVersion;

    if (kIsWeb) {
      final webBrowserInfo = await deviceInfoPlugin.webBrowserInfo;

      deviceModel = webBrowserInfo.userAgent;
      manufacturer = null;
      platformVersion = null;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;

      deviceModel = iosInfo.utsname.machine;
      deviceId = iosInfo.identifierForVendor;
      manufacturer = "Apple";
      platformVersion = iosInfo.systemVersion;
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      const androidIdGenerator = AndroidId();

      deviceModel = androidInfo.model;
      deviceId = await androidIdGenerator.getId();
      manufacturer = androidInfo.manufacturer;
      platformVersion = androidInfo.version.release;
    } else {
      deviceModel = null;
      manufacturer = null;
      platformVersion = null;
    }

    return AppInfo(
      appFlavor: appFlavor,
      baseUrl: Env.baseUrl,
      platform: platform,
      platformVersion: platformVersion,
      deviceModel: deviceModel,
      deviceId: deviceId,
      manufacturer: manufacturer,
      buildType: kReleaseMode == true ? BuildType.release : BuildType.debug,
    );
  }

  @injectable
  @singleton
  Dio get dioClient {
    return Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        receiveTimeout: const Duration(seconds: 25),
        connectTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 5),
      ),
    )..interceptors.addAll(
        [
          getIt<BaseInterceptor>(),
          PrettyDioLogger(
            requestHeader: isDevFlavor,
            requestBody: isDevFlavor,
            responseHeader: isDevFlavor,
          ),
        ],
      );
  }
}

BuildContext? get appContext {
  return AppConfigState.appKey.currentContext;
}

AppInfo get appInfo {
  return getIt<AppInfo>();
}

String get appFlavor {
  return String.fromEnvironment(constants.LocalKey.flavor);
}

bool get isDevFlavor {
  // We're going to return true always as this is a "development only" app
  return true;
}

bool get isProdFlavor {
  return appFlavor == constants.LocalValue.prod;
}
