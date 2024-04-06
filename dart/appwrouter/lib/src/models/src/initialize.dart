import 'dart:async';

import 'package:appwrite/appwrite.dart';
import 'package:appwrouter/src/models/src/event_type.dart';
import 'package:appwrouter/src/models/src/method_type.dart';
import 'package:appwrouter/src/models/src/triggered_type.dart';

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
  final dynamic req;

  /// A result from Appwrite Function Context
  final dynamic res;

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
    required this.req,
    required this.res,
    required this.log,
    required this.error,
    required this.onMiddleware,
    required this.onNext,
    required this.onError,
  });

  /// A request from Appwrite Function Context
  final dynamic req;

  /// A result from Appwrite Function Context
  final dynamic res;

  /// A log from Appwrite Function Context
  final dynamic log;

  /// An error from Appwrite Function Context
  final dynamic error;

  /// A middleware function
  final FutureOr<Client> Function(OnMiddleware) onMiddleware;

  /// A next function
  final FutureOr<dynamic> Function(Client) onNext;

  /// An error function
  final FutureOr<void> Function(dynamic) onError;
}
