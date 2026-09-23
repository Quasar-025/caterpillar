import 'dart:convert';

import 'package:http/http.dart' as http;

abstract interface class VoicePhrasingService {
  Future<String> phrase({
    required String intent,
    required Map<String, Object?> facts,
    required String fallback,
  });

  void dispose();
}

class BackendVoicePhrasingService implements VoicePhrasingService {
  BackendVoicePhrasingService(this._baseUrl, [http.Client? client])
    : _client = client ?? http.Client();

  final String _baseUrl;
  final http.Client _client;

  @override
  Future<String> phrase({
    required String intent,
    required Map<String, Object?> facts,
    required String fallback,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$_baseUrl/phrase'),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({
              'intent': intent,
              'facts': facts,
              'fallback': fallback,
            }),
          )
          .timeout(const Duration(milliseconds: 3500));
      if (response.statusCode != 200) return fallback;
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final text = body['text'] as String?;
      return text == null || text.trim().isEmpty ? fallback : text.trim();
    } catch (_) {
      return fallback;
    }
  }

  @override
  void dispose() => _client.close();
}
