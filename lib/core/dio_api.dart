import 'package:dio/dio.dart';
import 'dart:io'; // For file uploads if needed

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;
  final DioException? dioException;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
    this.dioException,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

/// Enhanced Dio API client that covers common use cases
class DioApi {
  final Dio dio;

  DioApi(this.dio) {
    // Ensure default ngrok header (useful during local dev)
    dio.options.headers.putIfAbsent(
      "ngrok-skip-browser-warning",
      () => "69420",
    );
  }

  /// Factory constructor with common configuration
  factory DioApi.withConfig({
    String? baseUrl,
    Duration? connectTimeout = const Duration(seconds: 30),
    Duration? receiveTimeout = const Duration(seconds: 30),
    Map<String, dynamic>? defaultHeaders,
    List<Interceptor>? interceptors,
    bool enableLogging = true,
  }) {
    final options = BaseOptions(
      baseUrl: baseUrl ?? '',
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        ...?defaultHeaders,
      },
    );

    final dio = Dio(options);

    // Add default logging interceptor in debug mode (or always if enabled)
    if (enableLogging) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
        ),
      );
    }

    // Add custom interceptors
    if (interceptors != null) {
      dio.interceptors.addAll(interceptors);
    }

    return DioApi(dio);
  }

  /// Generic GET request
  Future<Response<T>> get<T>(
    String path, {
    Options? options,
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await dio.get<T>(
        path,
        queryParameters: params,
        options: options ?? Options(),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleDioError(e, 'GET');
    } catch (e) {
      throw ApiException(message: 'Unexpected error during GET: $e');
    }
  }

  /// Generic POST request
  Future<Response<T>> post<T>(
    String path, {
    Options? options,
    Object? data,
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await dio.post<T>(
        path,
        data: data,
        queryParameters: params,
        options: options ?? Options(),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleDioError(e, 'POST');
    } catch (e) {
      throw ApiException(message: 'Unexpected error during POST: $e');
    }
  }

  /// Generic PUT request
  Future<Response<T>> put<T>(
    String path, {
    Options? options,
    Object? data,
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await dio.put<T>(
        path,
        data: data,
        queryParameters: params,
        options: options ?? Options(),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleDioError(e, 'PUT');
    } catch (e) {
      throw ApiException(message: 'Unexpected error during PUT: $e');
    }
  }

  /// Generic PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    Options? options,
    Object? data,
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await dio.patch<T>(
        path,
        data: data,
        queryParameters: params,
        options: options ?? Options(),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleDioError(e, 'PATCH');
    } catch (e) {
      throw ApiException(message: 'Unexpected error during PATCH: $e');
    }
  }

  /// Generic DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    Options? options,
    Object? data,
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
  }) async {
    try {
      return await dio.delete<T>(
        path,
        data: data,
        queryParameters: params,
        options: options ?? Options(),
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e, 'DELETE');
    } catch (e) {
      throw ApiException(message: 'Unexpected error during DELETE: $e');
    }
  }

  /// Helper for file upload (multipart)
  Future<Response<T>> uploadFile<T>(
    String path, {
    required String fieldName,
    required File file,
    Map<String, dynamic>? additionalData,
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    final formData = FormData.fromMap({
      fieldName: await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
      if (additionalData != null) ...additionalData,
    });

    return post<T>(
      path,
      data: formData,
      params: params,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
  }

  /// Helper for multiple file uploads
  Future<Response<T>> uploadMultipleFiles<T>(
    String path, {
    required String fieldName,
    required List<File> files,
    Map<String, dynamic>? additionalData,
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
  }) async {
    final formDataMap = <String, dynamic>{
      if (additionalData != null) ...additionalData,
    };

    final fileList = <MultipartFile>[];
    for (final file in files) {
      fileList.add(
        await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      );
    }
    formDataMap[fieldName] = fileList;

    final formData = FormData.fromMap(formDataMap);

    return post<T>(
      path,
      data: formData,
      params: params,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
    );
  }

  /// Download file helper
  Future<Response> download(
    String url,
    String savePath, {
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    Options? options,
  }) async {
    try {
      return await dio.download(
        url,
        savePath,
        queryParameters: params,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e, 'DOWNLOAD');
    } catch (e) {
      throw ApiException(message: 'Unexpected error during download: $e');
    }
  }

  /// Centralized error handler
  ApiException _handleDioError(DioException e, String method) {
    final statusCode = e.response?.statusCode;
    final responseData = e.response?.data;

    String message = 'Unknown error';

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Send timeout';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Receive timeout';
        break;
      case DioExceptionType.badCertificate:
        message = 'Bad certificate';
        break;
      case DioExceptionType.badResponse:
        message = _getErrorMessageFromStatus(statusCode, responseData);
        break;
      case DioExceptionType.cancel:
        message = 'Request cancelled';
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection';
        break;
      default:
        message = e.message ?? 'Request failed';
    }

    return ApiException(
      message: '$method request failed: $message',
      statusCode: statusCode,
      data: responseData,
      dioException: e,
    );
  }

  String _getErrorMessageFromStatus(int? statusCode, dynamic data) {
    if (data != null && data is Map && data.containsKey('message')) {
      return data['message'].toString();
    }

    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not found';
      case 500:
        return 'Internal server error';
      default:
        return 'Server error ($statusCode)';
    }
  }

  /// Add auth token dynamically (useful with interceptor)
  void setAuthToken(String token, {String header = 'Authorization'}) {
    dio.options.headers[header] = 'Bearer $token';
  }

  /// Clear auth token
  void clearAuthToken({String header = 'Authorization'}) {
    dio.options.headers.remove(header);
  }

  /// Update base URL at runtime
  void updateBaseUrl(String baseUrl) {
    dio.options.baseUrl = baseUrl;
  }
}
