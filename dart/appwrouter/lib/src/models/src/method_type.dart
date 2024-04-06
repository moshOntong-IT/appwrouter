/// Enumerate the HTTP methods.
enum MethodType {
  /// The GET method requests a representation of the
  /// specified resource.
  get(code: 'GET'),

  /// The POST method is used to submit an entity
  /// to the specified resource, often causing a
  /// change in state or side effects on the server.
  post(code: 'POST'),

  /// The PUT method replaces all current
  /// representations of the target resource
  /// with the request payload.
  put(code: 'PUT'),

  /// The DELETE method deletes the specified resource.
  delete(code: 'DELETE'),

  /// The PATCH method is used to apply partial
  /// modifications to a resource.
  patch(code: 'PATCH');

  const MethodType({required this.code});

  /// The code of the enum
  final String code;

  /// Parsing String code to MethodType
  static MethodType fromCode(String method) {
    switch (method) {
      case 'GET':
        return MethodType.get;
      case 'POST':
        return MethodType.post;
      case 'PUT':
        return MethodType.put;
      case 'DELETE':
        return MethodType.delete;
      case 'PATCH':
        return MethodType.patch;
      default:
        throw ArgumentError('Invalid method: $method');
    }
  }

  @override
  String toString() => code;
}
