import 'dart:convert';

import 'package:appwrouter/appwrouter.dart';
import 'package:dart_appwrite/dart_appwrite.dart';

Future<dynamic> indexHandler({
  required AppwrouterRequest req,
  required AppwrouterResponse res,
  required dynamic log,
  required dynamic error,
  required Client client,
}) async {
  try {
    log("Hi Appwriters, this is a log message");
    return res.send(
        jsonEncode({
          "message": "Hello from Appwrouter!",
        }),
        201,
        {
          "content-type": "application/json",
        });
  } catch (e) {
    error(e.toString());
    if (e is AppwriteException) {
      return res.send(
          jsonEncode({
            "message": e.message,
          }),
          500,
          {
            "content-type": "application/json",
          });
    } else {
      return res.send(
          jsonEncode({
            "message": "Internal Server Error",
          }),
          500,
          {
            "content-type": "application/json",
          });
    }
  }
}
