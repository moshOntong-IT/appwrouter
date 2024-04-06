import 'package:appwrite/appwrite.dart';

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

  /// A request from Appwrite Function Context
  final dynamic req;

  /// A result from Appwrite Function Context
  final dynamic res;

  /// A log from Appwrite Function Context
  final dynamic log;

  /// An error from Appwrite Function Context
  final dynamic error;

  /// A client instance from Appwrite SDK
  final Client client;
}
