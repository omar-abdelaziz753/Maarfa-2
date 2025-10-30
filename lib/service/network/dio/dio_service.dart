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
            "lang": Get.locale?.languageCode,
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

  post2(
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
            "lang": Get.locale?.languageCode,
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
          return Left(response.data["messages"]?.toString() ?? "Unknown error");
        }
      } else {
        // مهم جدًا: لو status مش 2xx نرجع Left مش null
        return Left(response.data["messages"]?.toString() ?? "Request failed");
      }
    } on dio.DioException catch (e) {
      debugPrint(e.response.toString());

      if (e.response?.data["status"] == 401) {
        debugPrint('response error 401');
        BlocProvider.of<AuthProviderCubit>(Get.context!).signout();
        return Left("Unauthorized");
      } else if (e.type == dio.DioExceptionType.connectionTimeout ||
          e.type == dio.DioExceptionType.receiveTimeout ||
          e.type == dio.DioExceptionType.sendTimeout) {
        // ممكن تعيد المحاولة أو ترجع Error
        return Left("اتصال الانترنت عندك ضعيف حاول مرة تانية");
      } else if (e.error is! SocketException) {
        debugPrint("failed");
        return Left(e.response?.data["messages"]?.toString() ?? "Unknown error");
      } else {
        return Left(tr("no_internet_connection"));
      }
    } on HandshakeException catch (e) {
      debugPrint(e.toString());
      return Left(tr("no_internet_connection_try_again"));
    } catch (e) {
      debugPrint(e.toString());
      return Left("Unexpected error: ${e.toString()}");
    }
  }

  post3(
      String path, {
        Map<String, dynamic>? body,
        Map<String, dynamic>? queryParams,
      }) async {
    debugPrint('POST3 => ${Get.locale?.languageCode} : $path');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "0";
    final headers = {
      "lang": Get.locale?.languageCode,
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": token == "0" ? null : "Bearer $token",
    };

    try {
      final response = await _dio!.post(
        path,
        queryParameters: queryParams,
        data: body,
        options: dio.Options(headers: headers),
      );

      debugPrint("📌 Response: ${json.encode(response.data)}");

      final msg = response.data["messages"]?.toString() ?? "Unknown error";
      final success = response.data["success"] == true;
      final status = response.data["status"] ?? 0;

      if (status == 401) {
        BlocProvider.of<AuthProviderCubit>(Get.context!).signout();
        return Left("Unauthorized");
      }

      if (success) {
        prefs.setInt("notification", response.data['notificationsCount']);
        return Right(response.data);
      }

      /// ❗ Always show the message from backend on errors
      return Left(msg);

    } on dio.DioException catch (e) {
      debugPrint("❌ DioException: $e");

      final msg = e.response?.data["messages"]?.toString();

      if (e.response?.data["status"] == 401) {
        BlocProvider.of<AuthProviderCubit>(Get.context!).signout();
        return Left("Unauthorized");
      }

      if (msg != null) {
        return Left(msg); // ✅ Important for backend message
      }

      if (e.type == dio.DioExceptionType.connectionTimeout ||
          e.type == dio.DioExceptionType.receiveTimeout ||
          e.type == dio.DioExceptionType.sendTimeout) {
        return Left("اتصال الانترنت ضعيف حاول مرة تانية");
      }

      return Left("Error: ${e.message}");
    } catch (e) {
      debugPrint("🔥 Unexpected: $e");
      return Left("Unexpected error: $e");
    }
  }



  post22(
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
            "lang": Get.locale?.languageCode,
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": value == '0' ? null : 'Bearer $value',
          },
        ),
        data: body,
      );

      debugPrint('response ${json.encode(response.data)}');
      debugPrint(response.statusCode.toString());

      if (response.data["status"] == 401) {
        debugPrint('response error 401');
        BlocProvider.of<AuthProviderCubit>(Get.context!).signout();
      }

      // ✅ هنا نرجع دايمًا قيمة، سواء نجاح أو خطأ
      if (200 <= response.statusCode! && response.statusCode! <= 299) {
        if (response.data['success'] == true) {
          prefs.setInt("notification", response.data['notificationsCount']);
          return Right(response.data);
        } else {
          return Left(response.data["messages"].toString());
        }
      } else {
        // 🔥 ده اللي كان ناقصك: لما يكون statusCode مش 200
        return Left(response.data["messages"]?.toString() ?? "حدث خطأ غير متوقع");
      }

    } on dio.DioException catch (e) {
      debugPrint(e.response.toString());

      if (e.response?.data["status"] == 401) {
        debugPrint('response error 401');
        BlocProvider.of<AuthProviderCubit>(Get.context!).signout();
      }

      if (e.type == dio.DioExceptionType.connectionTimeout ||
          e.type == dio.DioExceptionType.receiveTimeout ||
          e.type == dio.DioExceptionType.sendTimeout) {
        return await post(path, body: body);
      }

      if (e.response?.data != null) {
        return Left(e.response!.data["messages"].toString());
      }

      if (e.error is SocketException) {
        return Left(tr("no_internet_connection"));
      }

      return Left("حدث خطأ أثناء الاتصال بالسيرفر");
    } on HandshakeException {
      return Left(tr("no_internet_connection_try_again"));
    }
  }


  post23(
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
            "lang": Get.locale?.languageCode,
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": value == '0' ? null : 'Bearer $value',
          },
        ),
        data: body,
      );

      debugPrint('response ${json.encode(response.data)}');
      debugPrint(response.statusCode.toString());

      if (response.data["status"] == 401) {
        debugPrint('response error 401');
        BlocProvider.of<AuthProviderCubit>(Get.context!).signout();
      }

      // ✅ هنا حتى لو success = true نشيك على original.message
      if (200 <= response.statusCode! && response.statusCode! <= 299) {
        final originalMessage = response.data["data"]?["original"]?["message"];

        if (originalMessage != null) {
          return Left(originalMessage.toString());
        }

        if (response.data['success'] == true) {
          prefs.setInt("notification", response.data['notificationsCount']);
          return Right(response.data);
        } else {
          final errorMessage = response.data["messages"]?.toString()
              ?? "حدث خطأ غير متوقع";
          return Left(errorMessage);
        }
      } else {
        final errorMessage = response.data["data"]?["original"]?["message"]?.toString()
            ?? response.data["messages"]?.toString()
            ?? "حدث خطأ غير متوقع";
        return Left(errorMessage);
      }

    } on dio.DioException catch (e) {
      debugPrint(e.response.toString());

      if (e.response?.data["status"] == 401) {
        debugPrint('response error 401');
        BlocProvider.of<AuthProviderCubit>(Get.context!).signout();
      }

      if (e.type == dio.DioExceptionType.connectionTimeout ||
          e.type == dio.DioExceptionType.receiveTimeout ||
          e.type == dio.DioExceptionType.sendTimeout) {
        return await post(path, body: body);
      }

      if (e.response?.data != null) {
        final errorMessage = e.response?.data["data"]?["original"]?["message"]?.toString()
            ?? e.response?.data["messages"]?.toString()
            ?? "حدث خطأ غير متوقع";
        return Left(errorMessage);
      }

      if (e.error is SocketException) {
        return Left(tr("no_internet_connection"));
      }

      return Left("حدث خطأ أثناء الاتصال بالسيرفر");
    } on HandshakeException {
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
            "lang": Get.locale!.languageCode,
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
            "lang": Get.locale!.languageCode,
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
            "lang": Get.locale!.languageCode,
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

  delete22(path,
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
            "lang": Get.locale!.languageCode,
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

      debugPrint("response: $response");

      if (200 <= response.statusCode! && response.statusCode! <= 299) {
        if (response.data['status'] == true ||
            !response.data.toString().contains("status")) {
          return Right(response.data);
        } else {
          /// ✅ هنا هترجع messages زي ما انت عايز
          return Left(response.data['messages'].toString());
        }
      } else {
        /// ✅ في حالة statusCode مش ناجح
        return Left(response.data['messages'].toString());
      }
    } on dio.DioException catch (e) {
      debugPrint(e.response.toString());

      if (e.response != null &&
          e.response!.data != null &&
          e.response!.data["status"] == 401) {
        BlocProvider.of<AuthProviderCubit>(Get.context!).signout();
      } else if (e.type == dio.DioExceptionType.connectionTimeout ||
          e.type == dio.DioExceptionType.receiveTimeout ||
          e.type == dio.DioExceptionType.sendTimeout) {
        return await post(path, body: body);
      } else if (e.response != null &&
          e.response!.data != null &&
          e.response!.data["messages"] != null) {
        /// ✅ ترجيع رسالة الخطأ من السيرفر
        return Left(e.response!.data["messages"].toString());
      } else if (e.error.runtimeType != SocketException) {
        return Left('حدث خطأ غير متوقع');
      } else {
        return Left(tr("no_internet_connection"));
      }
    } on HandshakeException catch (e) {
      debugPrint(e.toString());
      return Left(tr("no_internet_connection_try_again"));
    }
  }


  requestWithFile22(File? file, Map<String, dynamic>? data, path, key) async {
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

      final response = await _dio!.post(
        path,
        data: formData,
        options: dio.Options(
          headers: {
            "Accept-Language": Get.locale!.languageCode,
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": value == '0' ? null : 'Bearer $value',
          },
        ),
      );

      debugPrint('response${json.encode(response.data)}');
      debugPrint(response.statusCode.toString());

      // ✅ لو 2xx
      if (200 <= response.statusCode! && response.statusCode! <= 299) {
        if (response.data['success'] == true) {
          return Right(response.data);
        } else {
          return Left(response.data['messages'].toString());
        }
      } else {
        // ✅ لو 400, 422, 500 ... الخ
        if (response.data != null && response.data is Map<String, dynamic>) {
          final msg = response.data['messages'] ?? "حدث خطأ غير متوقع";
          return Left(msg.toString());
        } else {
          return Left("فشل الاتصال بالسيرفر");
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

  requestWithFile222(File? file, Map<String, dynamic>? data, path, key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString("token") ?? "0";
    debugPrint('new request :$path');
    debugPrint('token :$value');

    try {
      String? fileName = file?.path.split('/').last;

      final fileMulti = file == null
          ? null
          : await dio.MultipartFile.fromFile(file.path, filename: fileName);

      data!.putIfAbsent(key, () => fileMulti);
      dio.FormData formData = dio.FormData.fromMap(data);

      debugPrint(path + formData.fields.toString());

      final response = await _dio!.post(
        path,
        data: formData,
        options: dio.Options(
          headers: {
            "Accept-Language": Get.locale!.languageCode,
            "Accept": "application/json",
            // ✅ مهم جدًا في الـ FormData: ما تحطش application/json
            "Content-Type": "multipart/form-data",
            "Authorization": value == '0' ? null : 'Bearer $value',
          },
        ),
      );

      debugPrint('response${json.encode(response.data)}');
      debugPrint(response.statusCode.toString());

      // ✅ لو 2xx
      if (200 <= response.statusCode! && response.statusCode! <= 299) {
        if (response.data['success'] == true) {
          return Right(response.data);
        } else {
          return Left(response.data['messages'].toString());
        }
      } else {
        // ✅ أي حالة تانية (400, 422, 500 ...)
        if (response.data != null && response.data is Map<String, dynamic>) {
          final msg = response.data['messages'] ?? "حدث خطأ غير متوقع";
          return Left(msg.toString());
        } else {
          return Left("فشل الاتصال بالسيرفر");
        }
      }
    } on dio.DioException catch (e) {
      debugPrint("DioException: $e");

      if (e.type == dio.DioExceptionType.connectionTimeout ||
          e.type == dio.DioExceptionType.receiveTimeout ||
          e.type == dio.DioExceptionType.sendTimeout) {
        // ✅ لازم ترجع return
        return requestWithFile22(file, data, path, key);
      } else if (e.error is SocketException) {
        return Left(tr("no_internet_connection"));
      } else {
        final msg = e.response?.data?["messages"] ?? e.message ?? "Unknown error";
        return Left(msg.toString());
      }
    } catch (e) {
      return Left("Unexpected error: $e");
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

class DioService2 {
  static final DioService2 _dioService = DioService2._internal();
  static dio.Dio? _dio;

  factory DioService2() {
    dio.BaseOptions options = dio.BaseOptions(
        followRedirects: false,
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

  DioService2._internal();

  Future<Either<String, Map<String, dynamic>>> post(
      String path, {
        Map<String, dynamic>? body,
        String? url,
        Map<String, dynamic>? queryParams,
      }) async {
    debugPrint('new request in ${Get.locale?.languageCode} :$path');
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString('token') ?? '0';
    try {
      body ??= {};
      queryParams ??= {};
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
        if (response.data['status'] == true) { // Changed from 'success' to 'status'
          prefs.setInt("notification", response.data['notificationsCount'] ?? 0);
          return Right(response.data);
        } else {
          return Left(response.data["message"]?.toString() ?? tr("unknown_error"));
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
        return Left(tr("connection_timeout"));
      } else if (e.error.runtimeType != SocketException) {
        debugPrint("failed");
        return Left(e.response?.data["message"]?.toString() ?? tr("unknown_error"));
      } else {
        return Left(tr("no_internet_connection"));
      }
    } on HandshakeException catch (e) {
      debugPrint(e.toString());
      return Left(tr("no_internet_connection_try_again"));
    }
    return Left(tr("unknown_error"));
  }

// ... (other methods like get, put, delete, requestWithFile, requestWithFiles remain unchanged)
}