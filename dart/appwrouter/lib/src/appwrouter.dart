// ignore: lines_longer_than_80_chars
// ignore_for_file: avoid_dynamic_calls, inference_failure_on_function_return_type

import 'dart:convert';

import 'package:appwrouter/appwrouter.dart';
import 'package:dart_appwrite/dart_appwrite.dart';

/// {@template appwrouter}
/// A router for appwrite cloud functions
/// {@endtemplate}

class Appwrouter {
  /// Singleton instance of the router
  factory Appwrouter() {
    return _instance;
  }
  Appwrouter._internal();

  /// Singleton instance of the router
  static Appwrouter get instance => _instance;

  /// Registration of all versions, routes and handlers
  Map<String, VersionedRoutes> versions = {};
  static final Appwrouter _instance = Appwrouter._internal();

  /// A method for registration for version routes
  void register({
    required String version,
    required MethodType method,
    required String path,
    required RouteHandler handler,
  }) {
    if (!versions.containsKey(version)) {
      versions[version] = VersionedRoutes();
    }
    if (!versions[version]!.routes.containsKey(path)) {
      versions[version]!.routes[path] = Route();
    }
    versions[version]!.routes[path]!.methods[method] = handler;
  }

  /// A Client instance from Appwrite SDK
  late final Client? _client;

  /// A Request mimic from Appwrite Context
  late final AppwrouterRequest? _req;

  /// A Response mimic from Appwrite Context
  late final AppwrouterResponse? _res;

  /// A log method from Appwrite Context
  late final dynamic _log;

  /// An error log method from Appwrite context
  late final dynamic _errorLog;

  /// GET registration method
  void get({
    required String version,
    required String path,
    required RouteHandler handler,
  }) {
    register(
      version: version,
      method: MethodType.get,
      path: path,
      handler: handler,
    );
  }

  /// POST registration method
  void post({
    required String version,
    required String path,
    required RouteHandler handler,
  }) {
    register(
      version: version,
      method: MethodType.post,
      path: path,
      handler: handler,
    );
  }

  /// DELETE registration method
  void delete({
    required String version,
    required String path,
    required RouteHandler handler,
  }) {
    register(
      version: version,
      method: MethodType.delete,
      path: path,
      handler: handler,
    );
  }

  /// PUT registration method
  void put({
    required String version,
    required String path,
    required RouteHandler handler,
  }) {
    register(
      version: version,
      method: MethodType.put,
      path: path,
      handler: handler,
    );
  }

  /// PATCH registration method
  void patch({
    required String version,
    required String path,
    required RouteHandler handler,
  }) {
    register(
      version: version,
      method: MethodType.patch,
      path: path,
      handler: handler,
    );
  }

  /// A function to match the route
  RouteMatchHandler _matchRoute() {
    final pathRequest = _req!.path;
    final pathSegments = pathRequest.split('/');
    if (pathSegments.length < 2) {
      _errorLog('Bad request');
      throw Exception('Bad request');
    }

    final version = pathSegments[1];
    final method = MethodType.fromCode(
      _req!.method.toUpperCase(),
    );
    final path = '/${pathSegments.sublist(2).join('/')}';

    final versionRoutes = versions[version];
    if (versionRoutes == null) {
      // ignore: lines_longer_than_80_chars
      _errorLog('The version indicate does not exist on registration');
      throw const AppwrouterException(
        message:
            // ignore: lines_longer_than_80_chars
            'The requested endpoint version could not be found. Please ensure that the specified version exists and is correctly configured in your application.',
        status: 400,
      );
    }
    late Map<String, dynamic> params;
    for (final MapEntry(:key, :value) in versionRoutes.routes.entries) {
      params = <String, dynamic>{};
      if (value.methods[method] != null) {
        final routePattern = key
            .split('/')
            .where(
              (item) => item.isNotEmpty,
            )
            .toList();
        final pathSegments = path
            .split('/')
            .where(
              (item) => item.isNotEmpty,
            )
            .toList();

        if (routePattern.length != pathSegments.length) {
          _errorLog(
            // ignore: lines_longer_than_80_chars
            'The number of segments in the route pattern does not match the number of segments in the provided path. Please ensure they align.',
          );
          throw const AppwrouterException(
            message:
                // ignore: lines_longer_than_80_chars
                'The requested URL does not match any of our routes. Please check the URL and try again.',
            status: 400,
          );
        }

        var isMatch = true;
        for (var i = 0; i < routePattern.length; i++) {
          if (routePattern[i].startsWith(':')) {
            params[routePattern[i].substring(1)] = pathSegments[i];
          } else if (routePattern[i] != pathSegments[i]) {
            isMatch = false;
            break;
          }
        }

        if (isMatch) {
          final handler = value.methods[method];

          if (handler != null) {
            return RouteMatchHandler(
              path: path,
              version: version,
              method: method,
              params: params,
              handler: handler,
            );
          }
        }
      }
    }

    return RouteMatchHandler(
      path: path,
      version: version,
      method: method,
      params: params,
    );
  }

  Future<dynamic> _handleRequest({
    required RouteMatchHandler routeMatch,
  }) async {
    if (routeMatch.handler == null) {
      _errorLog(
        // ignore: lines_longer_than_80_chars
        'No route found for ${routeMatch.path} with method ${routeMatch.method}',
      );
      return _res!.send(
          jsonEncode(
            {
              'message':
                  // ignore: lines_longer_than_80_chars
                  'The requested endpoint ${routeMatch.path} was not found for API version ${routeMatch.method}.',
            },
          ),
          404,
          {
            'content-type': 'application/json',
          });
    }

    _log('Matched route: ${_req!.path} with method ${_req!.method}');

    try {
      final newReq = _req!.copyWith(params: routeMatch.params);

      return await routeMatch.handler!(
        req: newReq,
        res: _res!,
        log: _log,
        error: _errorLog,
        client: _client!,
      );
    } catch (e) {
      _errorLog('Error while handling request: $e');
      return _res!.send(
          jsonEncode(
            {
              'message': 'Internal server error',
            },
          ),
          500,
          {
            'content-type': 'application/json',
          });
    }
  }

  /// A method for initialization of the Appwrouter
  Future<dynamic> initialize(
    dynamic context, {
    Future<dynamic> Function(
      AppwrouterRequest req,
      AppwrouterResponse res,
      MiddlewarePayload payload,
      Client client,
      Future<dynamic> Function(String path) redirect,
      Future<dynamic> Function() next,
    )? onMiddleware,
    dynamic Function(
      AppwrouterRequest req,
      AppwrouterResponse res,
      dynamic errorLog,
      AppwrouterException error,
    )? onError,
  }) async {
    final req = AppwrouterRequest.parse(context.req);
    final res = AppwrouterResponse.parse(context.res);
    final log = context.log;
    final error = context.error;
    try {
      _clean();
      _client = Client();
      _req = req;
      _res = res;
      _log = log;
      _errorLog = error;

      _log('Initializing appwrouter...');

      if (onMiddleware == null) {
        final routeMatch = _matchRoute();
        return await _handleRequest(
          routeMatch: routeMatch,
        );
      } else {
        final triggeredType = TriggeredType.fromCode(
          req.headers['x-appwrite-trigger'] as String,
        );
        String? fullEventType;
        EventType? eventType;
        Map<String, dynamic>? eventMap;

        if (triggeredType == TriggeredType.event) {
          fullEventType = req.headers['x-appwrite-event'] as String;
          eventType = EventType.fromCode(fullEventType);
          eventMap = req.body as Map<String, dynamic>;
        }

        final middlewarePayload = MiddlewarePayload(
          method: MethodType.fromCode(req.method),
          triggeredType: triggeredType,
          eventType: eventType,
          eventMap: eventMap,
        );

        final onMiddlewareResponse = await onMiddleware(
          req,
          res,
          middlewarePayload,
          _client!,
          _redirect,
          _next,
        );

        if (onMiddlewareResponse is! Future<dynamic>) {
          throw AppwrouterException(
            message: '''
The onMiddleware function should return a Future<dynamic> but got ${onMiddlewareResponse.runtimeType}
To fix this, use the next as a `return await next();`. If you use the redirect then,
use `return await redirect('/v1/path'). If the error is still there, please raise an issue at
https://github.com/moshOntong-IT/appwrouter/issues.

This error occured because you did not get the Response object from `AppwrouterResponse`.
''',
            status: 500,
          );
        } else {
          return onMiddlewareResponse;
        }
      }
    } on AppwrouterException catch (e) {
      if (onError == null) {
        error(e.message);
        return res.send(
            jsonEncode({
              'message': e.message,
            }),
            e.status,
            {
              'content-type': 'application/json',
            });
      } else {
        return onError(req, res, error, e);
      }
    } catch (e) {
      if (onError == null) {
        error(e.toString());
        return res.send(
            jsonEncode({
              'message': error.toString(),
            }),
            500,
            {
              'content-type': 'application/json',
            });
      } else {
        return onError(
          req,
          res,
          error,
          AppwrouterException(
            message: e.toString(),
            status: 500,
          ),
        );
      }
    }
  }

  void _clean() {
    _client = null;
    _req = null;
    _res = null;
    _log = null;
    _errorLog = null;
  }

  Future<dynamic> _redirect(String path) async {
    final routeMatch = _matchRoute();
    return _handleRequest(routeMatch: routeMatch);
  }

  Future<dynamic> _next() async {
    final routeMatch = _matchRoute();
    return _handleRequest(routeMatch: routeMatch);
  }
}
