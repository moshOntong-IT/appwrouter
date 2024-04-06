import 'package:appwrouter/src/models/models.dart';
import 'package:dart_appwrite/dart_appwrite.dart';

/// {@template handle_requuest_type}
/// A class for handling the Request in Function
/// {@endtemplate}
class HandleRequest {
  ///{@macro handle_requuest_type}
  HandleRequest({
    required this.req,
    required this.res,
    required this.log,
    required this.error,
    required this.client,
  });

  /// A request parsed from Appwrite Function Context
  final AppwrouterRequest req;

  /// A response parsed from Appwrite Function Context
  final AppwrouterResponse res;

  /// A log from Appwrite Function Context
  final dynamic log;

  /// An error from Appwrite Function Context
  final dynamic error;

  /// A client instance from Appwrite SDK
  final Client client;
}
