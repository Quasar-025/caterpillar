import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String get _developmentApiUrl {
  if (kIsWeb) return 'http://127.0.0.1:8000';
  if (defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.200.15.28:8000'; // Connecting directly to PC
  }
  return 'http://127.0.0.1:8000';
}

final apiBaseUrlProvider = Provider<String>((_) {
  return const String.fromEnvironment('API_BASE_URL').isEmpty
      ? _developmentApiUrl
      : const String.fromEnvironment('API_BASE_URL');
});

final wsBaseUrlProvider = Provider<String>((ref) {
  final apiBaseUrl = ref.watch(apiBaseUrlProvider);
  return apiBaseUrl.replaceFirst('http://', 'ws://').replaceFirst('https://', 'wss://');
});
