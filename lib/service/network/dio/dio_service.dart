import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart' as dio;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../bloc/auth/provider/auth_provider_cubit.dart';
import '../../../failure.dart';
import '../api/api.dart';

class DioService {
  static final DioService _dioService = DioService._internal();
  static dio.Dio? _dio;

  factory DioService() {
    dio.BaseOptions options = dio.BaseOptions(
        followRedirects: false,
        // will not throw errors
        validateStatus: (status) => true,
        baseUrl: ApiUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30));
    _dio = dio.Dio(options);
    _dio?.interceptors.add(PrettyDioLogger(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
      error: true,
    ));
    return _dioService;
  }
  // thamerbintm@gmail.com
  // 12345678

  DioService._internal();

  post(
    path, {
    Map<String, dynamic>? body,
    String? url,
    Map<String, dynamic>? queryParams,
  }) async {
    debugPrint('new request in ${Get.locale?.languageCode} :$path');
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('token') ?? '0';
    try {
      body ?? {};
      queryParams ?? {};
      debugPrint(jsonEncode(body));
      debugPrint('token $value');
      final response = await _dio!.post(
        path,
        queryParameters: queryParams,
        options: dio.Options(
          headers: {
            "Accept-Language": Get.locale?.languageCode,
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": value == '0' ? null : 'Bearer $value',
          },
        ),
        data: body,
      );
      debugPrint('response${json.encode(response.data)}');
      debugPrint(response.statusCode.toString());

      if (response.data["status"] == 401) {
        debugPrint('response error 401');
        BlocProvider.of<AuthProviderCubit>(Get.context!).signout();
      }

      if (200 <= response.statusCode! && response.statusCode! <= 299) {
        if (response.data['success'] == true) {
          prefs.setInt("notification", response.data['notificationsCount']);
          return Right(response.data);
        } else {
          return Left(response.data["messages"].toString());
        }
      }
    } on dio.DioException catch (e) {
      debugPrint(e.response.toString());

      /// problem here when no internet "null check here"
      if (e.response?.data["status"] == 401) {
        debugPrint('response error 401');
        BlocProvider.of<AuthProviderCubit>(Get.context!).signout();
      } else if (e.type == dio.DioExceptionType.connectionTimeout ||
          e.type == dio.DioExceptionType.receiveTimeout ||
          e.type == dio.DioExceptionType.sendTimeout) {
        return await post(path, body: body);
        // return Left(Failure("اتصال الانترنت عندك ضعيف حاول مرة تانية "));
      } else if (e.error.runtimeType != SocketException) {
        debugPrint("failed");
        return Left(e.response!.data["messages"].toString());
      } else {
        return Left(tr("no_internet_connection"));
      }
    } on HandshakeException catch (e) {
      debugPrint(e.toString());
      return Left(tr("no_internet_connection_try_again"));
    }
  }

  get(path,
      {Map<String, dynamic>? body,
      // String? url,
      Map<String, dynamic>? queryParams}) async {
    debugPrint('new request in ${Get.locale!.languageCode} :$path');
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('token') ?? '0';
    // final fcmToken = await NotificationService.instance!.getToken();
    // debugPrint("fcm: $fcmToken");
    try {
      body ??= {};
      queryParams ??= {};
      debugPrint("body $ApiUrl$path : ${jsonEncode(body)}");
      debugPrint('token $value');

      final response = await _dio!.get(
        path,
        queryParameters: queryParams,
        options: dio.Options(
          headers: {
            "Accept-Language": Get.locale!.languageCode,
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": value == '0' ? null : 'Bearer $value',
            // "device-token": fcmToken,
          },
        ),
      );
      debugPrint('response$path ${response.data}');
      debugPrint('code: ${response.statusCode}');

      if (response.data["status"] == 401) {
        debugPrint('response error 401');
        BlocProvider.of<AuthProviderCubit>(Get.context!).signout();
      }

      if (200 <= response.statusCode! && response.statusCode! <= 299) {
        if (response.data['success'] == false) {
          prefs.setInt("notification", response.data['notificationsCount']);
          return Left(response.data["messages"].toString());
        } else {
          return Right(response.data);
        }
      }
    } on dio.DioException catch (e) {
      debugPrint(e.response.toString());
      if (e.response?.data["status"] == 401) {
        debugPrint('response error 401');
        BlocProvider.of<AuthProviderCubit>(Get.context!).signout();
      } else if (e.type == dio.DioExceptionType.connectionTimeout ||
          e.type == dio.DioExceptionType.receiveTimeout ||
          e.type == dio.DioExceptionType.sendTimeout) {
        return await post(path, body: body);
        // return Left(Failure("اتصال الانترنت عندك ضعيف حاول مرة تانية "));
      } else {
        return Left(tr("no_internet_connection"));
      }
    } on HandshakeException catch (e) {
      debugPrint(e.toString());
      return Left(tr("no_internet_connection_try_again"));
    }
  }

  put(path,
      {Map<String, dynamic>? body,
      String? url,
      Map<String, dynamic>? queryParams}) async {
    debugPrint('new request :$path');
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString("token") ?? "0";
    try {
      body ??= {};
      queryParams ??= {};

      debugPrint(jsonEncode(body));

      final response = await _dio!.put(
        path,
        queryParameters: queryParams,
        options: dio.Options(
          headers: {
            "Accept-Language": Get.locale!.languageCode,
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": value == '0' ? null : 'Bearer $value',
          },
        ),
        data: body,
      );
      debugPrint('response$path ${response.data}');
      debugPrint('code: $queryParams');

      if (response.data["status"] == 401) {
        debugPrint('response error 401');
        BlocProvider.of<AuthProviderCubit>(Get.context!).signout();
      }

      if (200 <= response.statusCode! && response.statusCode! <= 299) {
        if (response.data['status'] == true ||
            !response.data.toString().contains("status")) {
          return Right(response.data);
        } else {
          return Left(response.data['messages'].toString());
        }
      }
    } on dio.DioException catch (e) {
      debugPrint(e.response.toString());
      if (e.response!.data["status"] == 401) {
        debugPrint('response error 401');
        BlocProvider.of<AuthProviderCubit>(Get.context!).signout();
      } else if (e.type == dio.DioExceptionType.connectionTimeout ||
          e.type == dio.DioExceptionType.receiveTimeout ||
          e.type == dio.DioExceptionType.sendTimeout) {
        return await post(path, body: body);
        // return Left(Failure("اتصال الانترنت عندك ضعيف حاول مرة تانية "));
      } else {
        return Left(tr("no_internet_connection"));
      }
    } on HandshakeException catch (e) {
      debugPrint(e.toString());
      return Left(tr("no_internet_connection_try_again"));
    }
  }

  delete(path,
      {Map<String, dynamic>? body,
      String? url,
      Map<String, dynamic>? queryParams}) async {
    debugPrint('new request :$path');
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString("token") ?? "0";
    try {
      body ??= {};
      queryParams ??= {};

      debugPrint(jsonEncode(body));

      final response = await _dio!.delete(
        path,
        queryParameters: queryParams,
        options: dio.Options(
          headers: {
            "Accept-Language": Get.locale!.languageCode,
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": value == '0' ? null : 'Bearer $value',
          },
        ),
        data: body,
      );
      debugPrint(response.toString());

      if (response.data["status"] == 401) {
        BlocProvider.of<AuthProviderCubit>(Get.context!).signout();
      }

      debugPrint("respose: $response");

      if (200 <= response.statusCode! && response.statusCode! <= 299) {
        if (response.data['status'] == true ||
            !response.data.toString().contains("status")) {
          return Right(response.data);
        } else {
          return Left(response.data['messages'].toString());
        }
      }
    } on dio.DioException catch (e) {
      debugPrint(e.response.toString());
      if (e.response!.data["status"] == 401) {
        BlocProvider.of<AuthProviderCubit>(Get.context!).signout();
      } else if (e.type == dio.DioExceptionType.connectionTimeout ||
          e.type == dio.DioExceptionType.receiveTimeout ||
          e.type == dio.DioExceptionType.sendTimeout) {
        return await post(path, body: body);
        // return Left(Failure("اتصال الانترنت عندك ضعيف حاول مرة تانية "));
      } else if (e.error.runtimeType != SocketException) {
        return Left('${e.response!.data['messages']}');
      } else {
        return Left(tr("no_internet_connection"));
      }
    } on HandshakeException catch (e) {
      debugPrint(e.toString());
      return Left(tr("no_internet_connection_try_again"));
    }
  }

  requestWithFile(File? file, Map<String, dynamic>? data, path, key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString("token") ?? "0";
    debugPrint('new request :$path');
    debugPrint('token :$value');
    try {
      String? fileName;
      if (file == null) {
        fileName = null;
      } else {
        fileName = file.path.split('/').last;
      }
      final fileMulti = file == null
          ? null
          : await dio.MultipartFile.fromFile(file.path, filename: fileName);
      data!.putIfAbsent(key, () => file == null ? null : fileMulti);
      dio.FormData formData = dio.FormData.fromMap(data);
      debugPrint(path + formData.fields.toString());
      final response = await _dio!.post(path,
          data: formData,
          options: dio.Options(
            headers: {
              "Accept-Language": Get.locale!.languageCode,
              "Accept": "application/json",
              "Content-Type": "application/json",
              "Authorization": value == '0' ? null : 'Bearer $value',
            },
          ));

      debugPrint('response${json.encode(response.data)}');
      debugPrint(response.statusCode.toString());
      if (200 <= response.statusCode! && response.statusCode! <= 299) {
        if (response.data['success'] == true) {
          return Right(response.data);
        } else {
          debugPrint('response${json.encode(response.data)}');
          return Left(response.data['messages'].toString());
        }
      }
    } on dio.DioException catch (e) {
      if (e.error.runtimeType != SocketException) {
        return Left(e.message.toString());
      } else if (e.type == dio.DioExceptionType.connectionTimeout ||
          e.type == dio.DioExceptionType.receiveTimeout ||
          e.type == dio.DioExceptionType.sendTimeout) {
        requestWithFile(file, data, path, key);
      } else {
        return Left(tr("no_internet_connection"));
      }
    }
  }

  requestWithFiles(List<File?> images, Map<String, dynamic>? data, path) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString("token") ?? "0";
    try {
      dio.FormData formData = dio.FormData.fromMap(data!);
      for (var file in images) {
        formData.files.add(MapEntry(
            'images[]',
            await dio.MultipartFile.fromFile(file!.path,
                filename: file.path.split('/').last)));
      }
      debugPrint(formData.fields.toString());
      final response = await _dio!.post(path,
          data: formData,
          options: dio.Options(
            headers: {
              "Accept-Language": Get.locale!.languageCode,
              "Accept": "application/json",
              "Content-Type": "application/json",
              "Authorization": value == '0' ? null : 'Bearer $value',
            },
          ));
      debugPrint('response${json.encode(response.data)}');
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 200) {
        if (response.data['status'] == 1) {
          return Right(response.data);
        } else {
          return Left(response.data['messages'].toString());
        }
      }
    } on dio.DioException catch (e) {
      debugPrint("dio error : ${e.response}");
      if (e.error.runtimeType != SocketException) {
        return Left(Failure(e.response!.data["message"]));
      } else if (e.type == dio.DioExceptionType.connectionTimeout ||
          e.type == dio.DioExceptionType.receiveTimeout ||
          e.type == dio.DioExceptionType.sendTimeout) {
        requestWithFiles(images, data, path);
      } else {
        return Left(tr("no_internet_connection"));
      }
    }
  }
}
