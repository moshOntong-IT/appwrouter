import 'package:appwrouter/appwrouter.dart';

/// {@template route_match_handler}
/// A class for handling property for matching route.
/// {@endtemplate}
class RouteMatchHandler {
  ///{@macro route_match_handler}
  RouteMatchHandler({
    required this.version,
    required this.path,
    required this.method,
    required this.params,
    this.handler,
  });

  /// The version of route handler;
  final String version;

  /// The path of route handler;
  final String path;

  /// The method type of route handler;
  final MethodType method;

  /// A map of all params
  final Map<String, dynamic> params;

  /// A handler function
  final RouteHandler? handler;
}
