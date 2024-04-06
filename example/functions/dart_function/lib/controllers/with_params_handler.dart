import 'dart:convert';

import 'package:appwrouter/appwrouter.dart';
import 'package:dart_appwrite/dart_appwrite.dart';

Future<dynamic> withParamsHandler(HandleRequest handler) async {
  final HandleRequest(
    :req,
    :res,
    :error,
    :log,
  ) = handler;
  try {
    final params = req.params;
    log("Hi Appwriters, this is a log message");
    log(params.toString());
    return res.send(
        jsonEncode({
          "message": "Hello from Appwrouter!",
          "data": {
            "studentId": params["studentId"],
            "id": params["id"],
          }
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
