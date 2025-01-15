import 'package:flutter/material.dart';

// Colors
const colorPrimary = Colors.black;
const colorLightGreen = Color(0xFF66FFB6);
const colorText1 = Colors.black;
const colorText2 = Color(0xFF212020);
const colorText3 = Color(0xFF676767);
const colorText4 = Color(0xFF363636);
const colorText5 = Colors.white;
const colorText6 = Color(0xFFD8D8D8);
const colorDisabled1 = Color(0xFFE0E0E0);
const colorDisabled2 = Color(0xFFAAA9A9);

// Font-family
const fontFamilyRoboto = "Roboto";

// Text Styles
const textStyleBodyTitle = TextStyle(
  fontFamily: fontFamilyRoboto,
  color: colorText2,
  fontWeight: FontWeight.w400,
  fontSize: 20.0,
  height: 1.172,
);

const textStyleBodySubtitle = TextStyle(
  fontFamily: fontFamilyRoboto,
  color: colorText3,
  fontWeight: FontWeight.w400,
  fontSize: 14.0,
  height: 1.172,
);

const textStyleAppBarTitle1 = TextStyle(
  fontFamily: fontFamilyRoboto,
  color: colorText4,
  fontWeight: FontWeight.w500,
  fontSize: 26.0,
  height: 1.172,
);

const textStyleAppBarTitle2 = TextStyle(
  fontFamily: fontFamilyRoboto,
  color: colorText1,
  fontWeight: FontWeight.w400,
  fontSize: 20.0,
  height: 1.172,
);

const textStyleAlbumTitle = TextStyle(
  fontFamily: fontFamilyRoboto,
  color: colorText5,
  fontWeight: FontWeight.w400,
  fontSize: 20.0,
  height: 1.172,
);

const textStyleAlbumSubtitle = TextStyle(
  fontFamily: fontFamilyRoboto,
  color: colorText6,
  fontWeight: FontWeight.w400,
  fontSize: 12.0,
  height: 1.172,
);

abstract class CustomHttpHeader {
  static const serviceName = "x-service-name";
  static const uuid = "x-request-uuid";
  static const theme = "accept-theme";
  static const settingsHash = "x-settings-hash";
  static const token = "token";
  static const requiresAuth = "requires-auth";
  static const authorization = "Authorization";
}

abstract class CustomHttpHeaderValue {
  static const applicationJson = "application/json";
  static const app = "app";
}

abstract class LocalKey {
  static const flavor = "flavor";
}

abstract class LocalValue {
  static const dev = "dev";
  static const prod = "prod";
}

abstract class Regex {
  static const mobileNumberRegex = r"(^(\\+88)?(01)[2-9][0-9]{8,8}$)";
  static const emailAddressRegex =
      r'^[a-zA-Z\d._%+-]+@[a-zA-Z\d.-]+\.[a-zA-Z]{2,}$';
  static const passwordRegex = r"(^[a-zA-Z0-9]{4,}$)";
  static const websiteUrlRegex =
      "(http|ftp|https)://[\\w-]+(\\.[\\w-]+)+([\\w.,@?^=%&amp;:/~+#-]*[\\w@?^=%&amp;/~+#-])?";
}

// Pagination
const paginationRatio = 0.75;
