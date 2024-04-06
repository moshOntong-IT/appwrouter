// ignore_for_file: avoid_dynamic_calls

/// {@template appwrouter_request}
/// A class that represents the request object.
/// {@endtemplate}
class AppwrouterRequest {
  /// {@macro appwrouter_request}
  const AppwrouterRequest({
    required this.bodyRaw,
    required this.body,
    required this.headers,
    required this.scheme,
    required this.method,
    required this.url,
    required this.host,
    required this.port,
    required this.path,
    required this.queryString,
    required this.query,
    this.params = const <String, dynamic>{},
  });

  /// Parsing the Request from Appwrite,
  factory AppwrouterRequest.parse(dynamic req) {
    return AppwrouterRequest(
      bodyRaw: req.bodyRaw as String,
      body: req.body,
      headers: req.headers as Map<String, dynamic>,
      scheme: req.scheme as dynamic,
      method: req.method as String,
      url: req.url as String,
      host: req.host as String,
      port: req.port as int,
      path: req.path as String,
      queryString: req.queryString as String,
      query: req.query as Map<String, dynamic>,
    );
  }

  /// The raw body of the request.
  final String bodyRaw;

  /// The body of the request.
  final dynamic body;

  /// The headers of the request.
  final Map<String, dynamic> headers;

  /// The scheme of the request.
  final dynamic scheme;

  /// The method of the request.
  final String method;

  /// The url of the request.
  final String url;

  /// The host of the request.
  final String host;

  /// The port of the request.
  final int port;

  /// The path of the request.
  final String path;

  /// The query string of the request.
  final String queryString;

  /// The query of the request.
  final Map<String, dynamic> query;

  /// The params of the request.
  final Map<String, dynamic> params;

  /// Copy with
  AppwrouterRequest copyWith({
    String? bodyRaw,
    dynamic body,
    Map<String, dynamic>? headers,
    dynamic scheme,
    String? method,
    String? url,
    String? host,
    int? port,
    String? path,
    String? queryString,
    Map<String, dynamic>? query,
    Map<String, dynamic>? params,
  }) {
    return AppwrouterRequest(
      bodyRaw: bodyRaw ?? this.bodyRaw,
      body: body ?? this.body,
      headers: headers ?? this.headers,
      scheme: scheme ?? this.scheme,
      method: method ?? this.method,
      url: url ?? this.url,
      host: host ?? this.host,
      port: port ?? this.port,
      path: path ?? this.path,
      queryString: queryString ?? this.queryString,
      query: query ?? this.query,
      params: params ?? this.params,
    );
  }
}
