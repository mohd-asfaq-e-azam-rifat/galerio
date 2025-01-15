import 'dart:async';
import 'dart:convert' as json_convert;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:galerio/constants.dart';
import 'package:galerio/data/helper/encryption/encryption_helper.dart';
import 'package:galerio/data/model/local/exception/exceptions.dart';
import 'package:galerio/data/model/remote/response/base/api_response.dart';
import 'package:galerio/injection.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

extension StringX on String {
  String appendPathIntoUrl(String? value) {
    return value != null ? "${trim()}/$value" : trim();
  }

  String appendParamIntoPostfix(
    String key,
    String? value,
  ) {
    if (value != null) {
      final url = Uri.tryParse(this);
      if (url != null && url.hasQuery == false) {
        return "${trim()}?$key=$value";
      } else {
        return "${trim()}&$key=$value";
      }
    } else {
      return trim();
    }
  }

  String toTitleCase() {
    if (isEmpty) {
      return "";
    }

    final words = split(" ");
    final capitalizedWords = words.map(
      (word) {
        final firstLetter = word.substring(0, 1).toUpperCase();
        final restLetters = word.substring(1).toLowerCase();
        return "$firstLetter$restLetters";
      },
    );

    return capitalizedWords.join(" ");
  }

  int? parse() {
    return int.tryParse(this);
  }
}

extension DateTimeX on DateTime {
  String toDayMonthFormat() {
    return DateFormat("d MMM").format(this);
  }

  String toDayShortMonthYearFormat() {
    return DateFormat("dd MMM, yyyy").format(this);
  }

  String toDayFullMonthYearFormat() {
    return DateFormat("dd MMMM, yyyy").format(this);
  }

  String toMonthDayYearFormat() {
    return DateFormat("MMM dd, yyyy").format(this);
  }

  String toYearMonthDayFormat() {
    return DateFormat("yyyy-MM-dd").format(this);
  }
}

extension IntX on int {
  String toDayString() {
    return "$this ${this == 1 ? "day" : "days"}";
  }

  DateTime? toDateTime({bool isUtc = true}) {
    if (this < 0) {
      return null;
    }

    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      this * 1000,
      isUtc: isUtc,
    );

    return dateTime;
  }
}

extension MapX on Map<String, dynamic> {
  Map<String, dynamic> addData(String key, dynamic value) {
    if (value != null) {
      this[key] = value;
    }

    return this;
  }
}

extension DioX on Dio {
  Future<Response<T>?> getRequest<T>({
    required String endPoint,
    Map<String, dynamic> queryParameters = const {},
    bool requiresAuth = true,
  }) async {
    Response<T>? response;

    try {
      response = await get<T>(
        endPoint,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            CustomHttpHeader.requiresAuth: requiresAuth,
          },
        ),
      );
    } on Exception catch (e, stacktrace) {
      _handleException(e, stacktrace);
    }

    return response;
  }

  Future<Response<T>?> postRequest<T>({
    required String endPoint,
    required Map<String, dynamic> data,
    bool requiresAuth = true,
  }) async {
    Response<T>? response;

    try {
      response = await post<T>(
        endPoint,
        data: data,
        options: Options(
          headers: {
            CustomHttpHeader.requiresAuth: requiresAuth,
          },
        ),
      );
    } on Exception catch (e, stacktrace) {
      _handleException(e, stacktrace);
    }

    return response;
  }

  Future<Response<T>?> putRequest<T>({
    required String endPoint,
    required Map<String, dynamic> data,
    bool requiresAuth = true,
  }) async {
    Response<T>? response;

    try {
      response = await put<T>(
        endPoint,
        data: data,
        options: Options(
          headers: {
            CustomHttpHeader.requiresAuth: requiresAuth,
          },
        ),
      );
    } on Exception catch (e, stacktrace) {
      _handleException(e, stacktrace);
    }

    return response;
  }

  Future<Response<T>?> multiPartPostRequest<T>({
    required String endPoint,
    required Map<String, dynamic> data,
    bool requiresAuth = true,
  }) async {
    Response<T>? response;

    try {
      response = await post<T>(
        endPoint,
        data: FormData.fromMap(data),
        options: Options(
          headers: {
            CustomHttpHeader.requiresAuth: requiresAuth,
          },
        ),
      );
    } on Exception catch (e, stacktrace) {
      _handleException(e, stacktrace);
    }

    return response;
  }

  void _handleException(Exception? err, StackTrace stackTrace) {
    if (err != null && err is DioException) {
      if (err.error is SocketException) {
        const message = "Please check your network connectivity and try again.";
        final ex = AppException(message);

        throw ex;
      } else if (err.type == DioExceptionType.connectionTimeout) {
        const message = "We’re having difficulty connecting to the server."
            " Verify server accessibility and retry.";
        final ex = AppException(message);

        throw ex;
      } else if (err.type == DioExceptionType.receiveTimeout) {
        const message = "It's taking more than usual."
            "\nCheck if your internet connection is stable!";
        final ex = AppException(message);

        throw ex;
      } else if (err.response?.statusCode == HttpStatus.forbidden) {
        // Log out the user forcefully
        const message = "Logging out forcefully.";
        final ex = AppException(message);

        throw ex;
      } else if (err.response?.statusCode == HttpStatus.tooManyRequests) {
        ApiResponse<void>? apiResponse;
        try {
          apiResponse = err.response?.data != null &&
                  err.response?.data is Map<String, dynamic>
              ? ApiResponse.fromJson(
                  err.response?.data,
                  (json) => {},
                )
              : null;
        } on Exception catch (e, trace) {
          apiResponse = null;
        }

        final ex = AppException(err.message ?? err.toString(), apiResponse);
        throw ex;
      } else if (err.response?.statusCode?.toString().startsWith("5") == true) {
        final data = err.response?.data;
        Map<String, dynamic>? jsonData;
        ApiResponse<void>? apiResponse;

        if (data != null) {
          if (data is String) {
            try {
              jsonData = json_convert.json.decode(data);
            } on Exception catch (e, trace) {}
          } else if (data is Map<String, dynamic>) {
            jsonData = data;
          }

          try {
            apiResponse = jsonData != null
                ? ApiResponse.fromJson(
                    jsonData,
                    (json) => {},
                  )
                : null;
          } on Exception catch (e, trace) {
            apiResponse = null;
          }
        }

        const message = "Service unavailable.";
        final ex = AppException(message, apiResponse);
        throw ex;
      } else {
        ApiResponse<void>? apiResponse;
        try {
          apiResponse = err.response?.data != null &&
                  err.response?.data is Map<String, dynamic>
              ? ApiResponse.fromJson(
                  err.response?.data,
                  (json) => {},
                )
              : null;
        } on Exception catch (e, trace) {
          apiResponse = null;
        }

        final ex = AppException(
          apiResponse?.message ??
              apiResponse?.errors?.description ??
              err.message ??
              err.toString(),
          apiResponse,
        );

        throw ex;
      }
    } else {
      final exception = AppException(err.toString());

      throw exception;
    }
  }
}

extension ExceptionX on Exception {
  String getErrorMessage() {
    String errorMessage = "Unknown";

    if (this is AppException) {
      errorMessage = (this as AppException).getErrorMessage();
    } else if (this is DioException) {
      errorMessage = (this as DioException).simplify();
    } else if (this is DioError) {
      errorMessage = (this as DioError).simplifyOld();
    } else {
      errorMessage = toString();
    }

    return errorMessage;
  }
}

extension AppExceptionX on AppException {
  String getErrorMessage() {
    final items = apiResponse?.errors?.details;
    final description = apiResponse?.errors?.description;

    if (message?.trim().isNotEmpty == true) {
      return message!.trim();
    } else if (description?.trim().isNotEmpty == true) {
      return description!.trim();
    } else if (items?.firstOrNull?.message?.trim().isNotEmpty == true) {
      return items!.first.message!.trim();
    } else {
      return toString();
    }
  }
}

extension DioExceptionX on DioException {
  String simplify() {
    return message ?? (error?.toString() ?? "Something went wrong");
  }
}

extension DioErrorX on DioError {
  String simplifyOld() {
    return message ?? (error?.toString() ?? "Something went wrong");
  }
}

extension GetStorageX on GetStorage {
  Future<void> writeStringSecured(String key, String value) {
    final encryptionHelper = getIt<EncryptionHelper>();
    return write(
      key,
      encryptionHelper.encrypt(value),
    );
  }

  String? readStringSecured(String key) {
    final encryptionHelper = getIt<EncryptionHelper>();
    final value = read<String>(key);
    return value != null ? encryptionHelper.decrypt(value) : null;
  }
}
