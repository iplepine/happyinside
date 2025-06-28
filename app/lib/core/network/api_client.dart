import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../errors/failures.dart';

/// 공통 API 클라이언트
class ApiClient {
  final http.Client client;
  final String baseUrl;

  ApiClient({
    required this.client,
    this.baseUrl = AppConstants.baseUrl,
  });

  /// GET 요청
  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await client
          .get(
            Uri.parse('$baseUrl$endpoint'),
            headers: {
              'Content-Type': 'application/json',
              ...?headers,
            },
          )
          .timeout(Duration(milliseconds: AppConstants.timeoutDuration));

      return _handleResponse(response);
    } catch (e) {
      throw NetworkFailure('GET 요청 실패: $e');
    }
  }

  /// POST 요청
  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await client
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: {
              'Content-Type': 'application/json',
              ...?headers,
            },
            body: body != null ? json.encode(body) : null,
          )
          .timeout(Duration(milliseconds: AppConstants.timeoutDuration));

      return _handleResponse(response);
    } catch (e) {
      throw NetworkFailure('POST 요청 실패: $e');
    }
  }

  /// PUT 요청
  Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await client
          .put(
            Uri.parse('$baseUrl$endpoint'),
            headers: {
              'Content-Type': 'application/json',
              ...?headers,
            },
            body: body != null ? json.encode(body) : null,
          )
          .timeout(Duration(milliseconds: AppConstants.timeoutDuration));

      return _handleResponse(response);
    } catch (e) {
      throw NetworkFailure('PUT 요청 실패: $e');
    }
  }

  /// DELETE 요청
  Future<http.Response> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await client
          .delete(
            Uri.parse('$baseUrl$endpoint'),
            headers: {
              'Content-Type': 'application/json',
              ...?headers,
            },
          )
          .timeout(Duration(milliseconds: AppConstants.timeoutDuration));

      return _handleResponse(response);
    } catch (e) {
      throw NetworkFailure('DELETE 요청 실패: $e');
    }
  }

  /// 응답 처리
  http.Response _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      throw ServerFailure('클라이언트 오류: ${response.statusCode}');
    } else if (response.statusCode >= 500) {
      throw ServerFailure('서버 오류: ${response.statusCode}');
    } else {
      throw NetworkFailure('알 수 없는 오류: ${response.statusCode}');
    }
  }
} 