/// A router for appwrite cloud functions
library;

import 'package:appwrouter/appwrouter.dart';
import 'package:dart_appwrite/dart_appwrite.dart';

export 'src/appwrouter.dart';
export 'src/initialize.dart';
export 'src/models/models.dart';
export 'src/utils/utils.dart';

/// An Alias name for Function Handler
typedef RouteHandler = Future<dynamic> Function({
  required AppwrouterRequest req,
  required AppwrouterResponse res,
  required dynamic log,
  required dynamic error,
  required Client client,
});
