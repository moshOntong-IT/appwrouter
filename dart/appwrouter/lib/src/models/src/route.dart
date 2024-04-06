import 'package:appwrouter/appwrouter.dart';

/// {@template route}
/// A route class
/// {@endtemplate}
class Route {
  /// The holder for all handler functions that depends on the method type
  Map<MethodType, RouteHandler> methods = {};

  /// A method for create new handler that dedicated for this method type
  void addMethod(MethodType method, RouteHandler handler) {
    methods[method] = handler;
  }

  /// A getter method
  RouteHandler getMethod(MethodType method) {
    return methods[method]!;
  }

  @override
  String toString() {
    return methods.toString();
  }
}
