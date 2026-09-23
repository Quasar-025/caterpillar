import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

String get _developmentApiUrl {
  if (kIsWeb) return 'http://127.0.0.1:8000';
  if (defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2:8000';
  }
  return 'http://127.0.0.1:8000';
}

final apiBaseUrlProvider = Provider<String>((_) {
  return const String.fromEnvironment('API_BASE_URL').isEmpty
      ? _developmentApiUrl
      : const String.fromEnvironment('API_BASE_URL');
});
