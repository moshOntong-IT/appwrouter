// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:appwrouter/appwrouter.dart';

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
  RouteMatchHandler? matchRoute({
    required String version,
    required MethodType method,
    required String path,
  }) {
    final versionRoutes = versions[version];
    if (versionRoutes == null) return null;

    for (final MapEntry(:key, :value) in versionRoutes.routes.entries) {
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

        if (routePattern.length != pathSegments.length) return null;

        final params = <String, dynamic>{};
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
              params: params,
              handler: handler,
            );
          }
        }
      }
    }

    return null;
  }

  /// A function to handle the request
  Future<dynamic> handleRequest({
    required HandleRequest handlerequest,
  }) async {
    final HandleRequest(
      :req,
      :res,
      :log,
      :error,
      :client,
    ) = handlerequest;
    final pathRequest = req.path;
    final pathSegments = pathRequest.split('/');
    if (pathSegments.length < 2) {
      error('Bad request');
      return res.send(
          jsonEncode(
            {'message': 'Bad request'},
          ),
          400,
          {
            'content-type': 'application/json',
          });
    }

    final version = pathSegments[1];
    final method = MethodType.fromCode(
      req.method.toUpperCase(),
    );
    final path = '/${pathSegments.sublist(2).join('/')}';

    final matchedRoute = matchRoute(
      version: version,
      method: method,
      path: path,
    );

    if (matchedRoute == null) {
      error('No route found for $path with method $method');
      return res.send(
          jsonEncode(
            {
              'message':
                  // ignore: lines_longer_than_80_chars
                  'The requested endpoint $path was not found for API version $version.',
            },
          ),
          404,
          {
            'content-type': 'application/json',
          });
    }

    log('Matched route: $pathRequest with method $method');

    try {
      final newReq = req.copyWith(params: matchedRoute.params);

      return await matchedRoute.handler(
        HandleRequest(
          req: newReq,
          res: res,
          log: log,
          error: error,
          client: client,
        ),
      );
    } catch (e) {
      error('Error while handling request: $e');
      return res.send(
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
}
