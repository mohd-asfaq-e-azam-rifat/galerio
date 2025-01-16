import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:galerio/base/app_config/app_config_bloc.dart';
import 'package:galerio/base/app_config/app_config_event.dart';
import 'package:galerio/base/widget/button/base_filled_button.dart';
import 'package:galerio/constants.dart';
import 'package:permission_handler/permission_handler.dart';

class RequestPermissionPage extends StatelessWidget {
  final AndroidDeviceInfo _androidInfo;

  const RequestPermissionPage(this._androidInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/icons/ic_photo_folders.svg",
              width: 123.0,
              height: 149.0,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 40.0),
            Text(
              "Require Permission",
              style: textStyleBodyTitle,
            ),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 56.0),
              child: Text(
                "To show your black and white photos we just need your folder permission. We promise, we don’t take your photos.",
                style: textStyleBodySubtitle,
                textAlign: TextAlign.center,
              ),
            ),
            BaseFilledButton(
              title: "Grant Access",
              buttonWidth: double.maxFinite,
              buttonHeight: 42.0,
              margin: const EdgeInsets.only(
                top: 40.0,
                left: 40.0,
                right: 40.0,
              ),
              onPressed: () async {
                final requiredPermission = getRequiredPermission();
                if (await requiredPermission.status.isPermanentlyDenied) {
                  openAppSettings();
                } else {
                  final updatedStatus = await requiredPermission.request();

                  if (updatedStatus.isGranted || updatedStatus.isLimited) {
                    final bloc = context.read<AppConfigBloc>();
                    bloc.add(UserAuthStateUpdated());
                  } else {
                    // Do nothing
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Permission getRequiredPermission() {
    Permission requiredPermission;

    if (Platform.isAndroid == true) {
      if (_androidInfo.version.sdkInt <= 32) {
        requiredPermission = Permission.storage;
      } else {
        requiredPermission = Permission.photos;
      }
    } else {
      requiredPermission = Permission.photos;
    }

    return requiredPermission;
  }
}
