import 'package:appwrouter/appwrouter.dart';
import 'package:dart_appwrite/dart_appwrite.dart';

/// {@template middleware_payload}
/// A class that represents the middleware payload.
/// {@endtemplate}
class MiddlewarePayload {
  /// {@macro middleware_payload}
  MiddlewarePayload({
    required this.method,
    required this.client,
    required this.triggeredType,
    this.eventType,
    this.eventMap,
  });

  /// The Client instance from Appwrite SDK
  final Client client;

  /// A method type
  final MethodType method;

  /// A triggered type such as HTTP, Event, Schedule
  final TriggeredType triggeredType;

  /// An event type such as create, update, delete
  final EventType? eventType;

  /// Parsed event map from the 'x-appwrite-event' header into a Map
  final Map<String, dynamic>? eventMap;
}
