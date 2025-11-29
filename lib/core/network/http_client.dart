import 'dart:io';
import 'package:http/http.dart' as http;

class HttpClient {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  HttpClient({required this.baseUrl, Map<String, String>? defaultHeaders})
    : defaultHeaders = defaultHeaders ?? {};

  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http.get(
        uri,
        headers: {...defaultHeaders, ...?headers},
      );
      return response;
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final response = await http.post(
        uri,
        headers: {...defaultHeaders, ...?headers},
        body: body,
      );
      return response;
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
