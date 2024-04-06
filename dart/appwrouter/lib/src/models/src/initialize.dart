import 'dart:async';

import 'package:appwrouter/src/models/models.dart';
import 'package:dart_appwrite/dart_appwrite.dart';

/// {@template on_middleware}
/// A property of middleware
/// {@endtemplate}
class OnMiddleware {
  /// {@macro on_middleware}
  OnMiddleware({
    required this.req,
    required this.res,
    required this.log,
    required this.error,
    required this.method,
    required this.triggeredType,
    required this.path,
    this.eventType,
    this.eventMap,
  });

  /// A request from Appwrite Function Context
  final AppwrouterRequest req;

  /// A response from Appwrite Function Context
  final AppwrouterResponse res;

  /// A log from Appwrite Function Context
  final dynamic log;

  /// An error from Appwrite Function Context
  final dynamic error;

  /// A method type
  final MethodType method;

  /// A triggered type such as HTTP, Event, Schedule
  final TriggeredType triggeredType;

  /// An event type such as create, update, delete
  final EventType? eventType;

  /// Parsed event map from the 'x-appwrite-event' header into a Map
  final Map<String, dynamic>? eventMap;

  /// A path of the request
  final String path;
}

/// {@template middleware}
/// A class for handling the Middleware in Function
/// {@endtemplate}
class Initialize {
  /// {@macro middleware}
  Initialize({
    required dynamic req,
    required dynamic res,
    required this.log,
    required this.error,
    required this.onMiddleware,
    required this.onNext,
    required this.onError,
  })  : req = AppwrouterRequest.parse(req),
        res = AppwrouterResponse.parse(res);

  /// A request instance parsed from Appwrite Function Context
  final AppwrouterRequest req;

  /// A result instance parsed from Appwrite Function Context
  final AppwrouterResponse res;

  /// A log from Appwrite Function Context
  final dynamic log;

  /// An error from Appwrite Function Context
  final dynamic error;

  /// A middleware function
  final Future<Client> Function(OnMiddleware) onMiddleware;

  /// A next function
  final Future<dynamic> Function(
    AppwrouterRequest req,
    AppwrouterResponse res,
    Client client,
  ) onNext;

  /// An error function
  final Future<void> Function(dynamic) onError;
}
