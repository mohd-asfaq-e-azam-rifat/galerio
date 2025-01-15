import 'package:galerio/data/model/remote/response/base/api_response.dart';

class AppException implements Exception {
  String? message;
  ApiResponse<void>? apiResponse;

  AppException([this.message, this.apiResponse]);

  @override
  String toString() {
    return message?.trim().isNotEmpty == true ? "$message" : "";
  }
}

class UnauthenticatedException implements Exception {
  String? message;
  String? url;

  UnauthenticatedException([this.message, this.url]);

  @override
  String toString() {
    return message?.trim().isNotEmpty == true ? "$message" : "";
  }
}

class ComingSoonFeatureException implements Exception {
  String? message;

  ComingSoonFeatureException([this.message]);

  @override
  String toString() {
    return message?.trim().isNotEmpty == true ? "$message" : "";
  }
}
