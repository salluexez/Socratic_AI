import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/api_session.dart';
import '../models/api_user.dart';
import 'app_config.dart';

class BackendApiService {
  BackendApiService._();

  static final BackendApiService instance = BackendApiService._();

  final http.Client _client = http.Client();
  String? _cookie;
  ApiUser? currentUser;

  bool get isConfigured => AppConfig.hasApiBaseUrl;
  bool get isAuthenticated => _cookie != null;

  String get _normalizedBaseUrl {
    final raw = AppConfig.apiBaseUrl.trim();
    if (raw.isEmpty) return raw;

    var normalized = raw.endsWith('/') ? raw.substring(0, raw.length - 1) : raw;
    if (!normalized.endsWith('/api')) {
      normalized = '$normalized/api';
    }
    return normalized;
  }

  Uri _uri(String path) => Uri.parse('$_normalizedBaseUrl$path');

  Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      if (_cookie != null) 'Cookie': _cookie!,
    };
  }

  void _captureCookie(http.Response response) {
    final rawCookie = response.headers['set-cookie'];
    if (rawCookie == null || rawCookie.isEmpty) return;
    _cookie = rawCookie.split(';').first;
  }

  Map<String, dynamic> _parseBody(http.Response response) {
    if (response.body.isEmpty) return <String, dynamic>{};
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Never _throwApiError(http.Response response) {
    final body = _parseBody(response);
    throw BackendApiException(
      (body['error'] ?? body['message'] ?? 'Request failed') as String,
    );
  }

  Future<ApiUser> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      _uri('/auth/signup'),
      headers: _headers(),
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 201) _throwApiError(response);
    _captureCookie(response);
    final user =
        ApiUser.fromJson(_parseBody(response)['data'] as Map<String, dynamic>);
    currentUser = user;
    return user;
  }

  Future<ApiUser> signin({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      _uri('/auth/signin'),
      headers: _headers(),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 200) _throwApiError(response);
    _captureCookie(response);
    final user =
        ApiUser.fromJson(_parseBody(response)['data'] as Map<String, dynamic>);
    currentUser = user;
    return user;
  }

  Future<ApiUser> getMe() async {
    final response = await _client.get(
      _uri('/auth/me'),
      headers: _headers(),
    );

    if (response.statusCode != 200) _throwApiError(response);
    final user =
        ApiUser.fromJson(_parseBody(response)['data'] as Map<String, dynamic>);
    currentUser = user;
    return user;
  }

  Future<void> logout() async {
    final response = await _client.post(
      _uri('/auth/logout'),
      headers: _headers(),
    );

    if (response.statusCode != 200) _throwApiError(response);
    _cookie = null;
    currentUser = null;
  }

  Future<ApiSession> createSession({
    required String subject,
  }) async {
    final response = await _client.post(
      _uri('/sessions'),
      headers: _headers(),
      body: jsonEncode({'subject': subject}),
    );

    if (response.statusCode != 201) _throwApiError(response);
    return ApiSession.fromJson(
        _parseBody(response)['data'] as Map<String, dynamic>);
  }

  Future<List<ApiSession>> getSessions({String? subject}) async {
    final base = _uri('/sessions');
    final uri = subject == null || subject.isEmpty
        ? base
        : base.replace(queryParameters: {'subject': subject});

    final response = await _client.get(
      uri,
      headers: _headers(),
    );

    if (response.statusCode != 200) _throwApiError(response);
    final data = (_parseBody(response)['data'] as List<dynamic>? ?? const []);
    return data
        .map((item) => ApiSession.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<ApiSession> getSessionById(String sessionId) async {
    final response = await _client.get(
      _uri('/sessions/$sessionId'),
      headers: _headers(),
    );

    if (response.statusCode != 200) _throwApiError(response);
    return ApiSession.fromJson(
      _parseBody(response)['data'] as Map<String, dynamic>,
    );
  }

  Future<String> sendChatMessage({
    required String sessionId,
    required String content,
  }) async {
    final response = await _client.post(
      _uri('/chat'),
      headers: _headers(),
      body: jsonEncode({
        'sessionId': sessionId,
        'content': content,
      }),
    );

    if (response.statusCode != 200) _throwApiError(response);
    final data = _parseBody(response)['data'] as Map<String, dynamic>;
    return (data['content'] ?? '') as String;
  }
}

class BackendApiException implements Exception {
  const BackendApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
