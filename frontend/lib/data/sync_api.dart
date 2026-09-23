import 'dart:convert';

import 'package:http/http.dart' as http;

import 'sync_models.dart';

class HttpSyncApi implements SyncApi {
  HttpSyncApi({required this.baseUrl, http.Client? client, this.deviceId = 'tablet-demo'})
      : _client = client ?? http.Client();

  final Uri baseUrl;
  final http.Client _client;
  final String deviceId;

  Uri _pullUri(String? since) {
    if (since == null) {
      return baseUrl.resolve('/sync/pull');
    }
    return baseUrl.resolve('/sync/pull').replace(queryParameters: {'since': since});
  }

  @override
  Future<void> push(List<SyncChange> changes) async {
    final response = await _client.post(
      baseUrl.resolve('/sync/push'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'device_id': deviceId,
        'changes': changes.map((change) => change.toJson()).toList(),
      }),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError('sync push failed: ${response.statusCode} ${response.body}');
    }
  }

  @override
  Future<PullResult> pull(String? since) async {
    final response = await _client.get(_pullUri(since));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError('sync pull failed: ${response.statusCode} ${response.body}');
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final changes = (body['changes'] as List<dynamic>)
        .map((item) => SyncChange.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
    return PullResult(cursor: body['cursor'] as String, changes: changes);
  }
}
