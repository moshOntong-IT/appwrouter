import 'package:appwrouter/appwrouter.dart';

/// {@template versioned_routes}
/// A class that store all routes version.
/// {@endtemplate}
class VersionedRoutes {
  /// A map of all routes with its own version
  Map<String, Route> routes = {};

  /// Add route
  void addRoute(String path, Route route) {
    routes[path] = route;
  }

  /// Get route
  Route getRoute(String path) {
    return routes[path]!;
  }
}
