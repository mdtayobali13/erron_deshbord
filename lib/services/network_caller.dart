import 'dart:convert';
import 'package:http/http.dart' as http;
import 'prefs_service.dart';

class NetworkResponse {
  final bool isSuccess;
  final int statusCode;
  final dynamic responseData;
  final String? errorMessage;

  NetworkResponse({
    required this.isSuccess,
    required this.statusCode,
    this.responseData,
    this.errorMessage,
  });
}

class NetworkCaller {
  static Future<NetworkResponse> postRequest(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final token = await PrefsService.getToken();

      // Determine content type - many auth APIs require form-urlencoded
      final bool isLogin = url.contains('login');
      final Map<String, String> headers = {
        'accept': 'application/json',
        if (isLogin)
          'Content-Type': 'application/x-www-form-urlencoded'
        else if (body != null)
          'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: isLogin ? body : (body != null ? jsonEncode(body) : null),
      );

      // CRITICAL: Bringing back detailed logging to find the 422/401 root cause
      print('🚀 [POST] URL: $url');
      print('✅ Status: ${response.statusCode}');
      print('📦 Response: ${response.body}');

      dynamic decodedData;
      try {
        decodedData = jsonDecode(response.body);
      } catch (e) {
        decodedData = response.body;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedData,
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          responseData: decodedData,
        );
      }
    } catch (e) {
      print('❌ [POST] Error: $e');
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<NetworkResponse> patchRequest(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final token = await PrefsService.getToken();
      final Map<String, String> headers = {
        'accept': 'application/json',
        if (body != null) 'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );

      print('🚀 [PATCH] URL: $url');
      if (token != null) {
        print('🔑 Token: ${token.substring(0, 10)}...');
      } else {
        print('🔑 Token: MISSING');
      }
      print('✅ Status: ${response.statusCode}');
      print('📦 Response: ${response.body}');

      dynamic decodedData;
      try {
        decodedData = jsonDecode(response.body);
      } catch (e) {
        decodedData = response.body;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedData,
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          responseData: decodedData,
        );
      }
    } catch (e) {
      print('❌ [PATCH] Error: $e');
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<NetworkResponse> putRequest(
    String url, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final token = await PrefsService.getToken();
      final Map<String, String> headers = {
        'accept': 'application/json',
        if (body != null) 'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );

      print('🚀 [PUT] URL: $url');
      if (token != null) {
        print('🔑 Token: ${token.substring(0, 10)}...');
      } else {
        print('🔑 Token: MISSING');
      }
      print('✅ Status: ${response.statusCode}');
      print('📦 Response: ${response.body}');

      dynamic decodedData;
      try {
        decodedData = jsonDecode(response.body);
      } catch (e) {
        decodedData = response.body;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedData,
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          responseData: decodedData,
        );
      }
    } catch (e) {
      print('❌ [PUT] Error: $e');
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<NetworkResponse> getRequest(String url) async {
    try {
      final token = await PrefsService.getToken();
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      dynamic decodedData;
      try {
        decodedData = jsonDecode(response.body);
      } catch (e) {
        decodedData = response.body;
      }

      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedData,
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          responseData: decodedData,
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<NetworkResponse> deleteRequest(String url) async {
    try {
      final token = await PrefsService.getToken();
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      dynamic decodedData;
      try {
        decodedData = jsonDecode(response.body);
      } catch (e) {
        decodedData = response.body;
      }

      if (response.statusCode == 200 || response.statusCode == 204) {
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          responseData: decodedData,
        );
      } else {
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          responseData: decodedData,
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        statusCode: -1,
        errorMessage: e.toString(),
      );
    }
  }
}
