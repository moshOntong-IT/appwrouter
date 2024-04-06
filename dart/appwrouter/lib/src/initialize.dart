// ignore_for_file: avoid_dynamic_calls, unnecessary_parenthesis

import 'package:appwrouter/appwrouter.dart';

/// A method for initialization of the Appwrouter
Future<dynamic> initialize(Initialize initialize) async {
  final Initialize(
    :req,
    :res,
    :log,
    :error,
    :onMiddleware,
    :onNext,
    :onError,
  ) = initialize;
  try {
    final triggeredType = TriggeredType.fromCode(
      (req['headers'])['x-appwrite-trigger'] as String,
    );
    String? fullEventType;
    EventType? eventType;
    Map<String, dynamic>? eventMap;

    if (triggeredType == TriggeredType.event) {
      fullEventType = req.headers['x-appwrite-event'] as String;
      eventType = EventType.fromCode(fullEventType);
      eventMap = req.body as Map<String, dynamic>;
    }

    final client = await onMiddleware(
      OnMiddleware(
        req: req,
        res: res,
        log: log,
        error: error,
        method: MethodType.fromCode(req['method'] as String),
        triggeredType: triggeredType,
        path: req['path'] as String,
        eventType: eventType,
        eventMap: eventMap,
      ),
    );

    return await onNext(client);
  } catch (e) {
    return onError(e);
  }
}
