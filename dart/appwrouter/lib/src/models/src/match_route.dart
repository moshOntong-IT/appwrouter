/// {@template match_route}
/// A class for handling property for matching route.
/// {@endtemplate}
class MatchRoute {
  /// {@macro match_route}
  MatchRoute({
    required this.version,
    required this.method,
    required this.path,
  });

  /// The version of all routes
  final String version;

  /// The method of type such as `GET`, `POST`, and etc.
  final String method;

  /// The string path of the route.
  final String path;
}
