import 'dart:async';
import 'dart:isolate';

import '../telemetry/tick.dart';
import 'risk_engine.dart';
import 'risk_state.dart';

void _runRiskEngine(SendPort hostPort) {
  final commandPort = ReceivePort();
  final engine = RiskEngine();
  hostPort.send(commandPort.sendPort);

  commandPort.listen((message) {
    final request = message as Map<Object?, Object?>;
    if (request['type'] == 'close') {
      commandPort.close();
      return;
    }

    final id = request['id'] as int;
    try {
      final tick = TelemetryTick.fromJson(
        request['tick'] as Map<String, dynamic>,
      ).copyWith(t0: DateTime.parse(request['t0'] as String));
      hostPort.send({'id': id, 'state': engine.evaluate(tick).toJson()});
    } on Object catch (error, stackTrace) {
      hostPort.send({
        'id': id,
        'error': error.toString(),
        'stack': stackTrace.toString(),
      });
    }
  });
}

/// Long-lived isolate that keeps risk evaluation off the Flutter UI isolate.
class RiskEngineWorker {
  RiskEngineWorker._(
    this._isolate,
    this._commandPort,
    this._responsePort,
    this._responseSubscription,
    this._pending,
  );

  final Isolate _isolate;
  final SendPort _commandPort;
  final ReceivePort _responsePort;
  final StreamSubscription<Object?> _responseSubscription;
  final Map<int, Completer<RiskState>> _pending;

  var _nextRequestId = 0;
  var _closed = false;

  static Future<RiskEngineWorker> start() async {
    final responsePort = ReceivePort();
    final ready = Completer<SendPort>();
    final pending = <int, Completer<RiskState>>{};

    late final StreamSubscription<Object?> subscription;
    subscription = responsePort.listen((message) {
      if (message is SendPort) {
        ready.complete(message);
        return;
      }
      final response = message as Map<Object?, Object?>;
      final completer = pending.remove(response['id'] as int);
      if (completer == null) return;
      if (response['error'] != null) {
        completer.completeError(
          StateError(response['error'] as String),
          StackTrace.fromString(response['stack'] as String),
        );
        return;
      }
      completer.complete(
        RiskState.fromJson(response['state'] as Map<Object?, Object?>),
      );
    });

    final isolate = await Isolate.spawn(_runRiskEngine, responsePort.sendPort);
    final commandPort = await ready.future;
    return RiskEngineWorker._(
      isolate,
      commandPort,
      responsePort,
      subscription,
      pending,
    );
  }

  Future<RiskState> evaluate(TelemetryTick tick) {
    if (_closed) {
      throw StateError('RiskEngineWorker is closed');
    }
    final id = _nextRequestId++;
    final completer = Completer<RiskState>();
    _pending[id] = completer;
    _commandPort.send({
      'type': 'evaluate',
      'id': id,
      'tick': tick.toJson(),
      't0': tick.t0.toIso8601String(),
    });
    return completer.future;
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    _commandPort.send({'type': 'close'});
    for (final completer in _pending.values) {
      completer.completeError(StateError('RiskEngineWorker closed'));
    }
    _pending.clear();
    await _responseSubscription.cancel();
    _responsePort.close();
    _isolate.kill(priority: Isolate.immediate);
  }
}
