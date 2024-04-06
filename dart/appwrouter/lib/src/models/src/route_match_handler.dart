import 'package:appwrouter/appwrouter.dart';

/// {@template route_match_handler}
/// A class for handling property for matching route.
/// {@endtemplate}
class RouteMatchHandler {
  ///{@macro route_match_handler}
  RouteMatchHandler({
    required this.params,
    required this.handler,
  });

  /// A map of all params
  final Map<String, dynamic> params;

  /// A handler function
  final RouteHandler handler;
}
