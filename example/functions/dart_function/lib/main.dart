import 'dart:async';
import 'dart:convert';

import 'package:appwrouter/appwrouter.dart';
import 'package:starter_template/controllers/index_handler.dart';
import 'package:starter_template/controllers/with_params_handler.dart';

final router = Appwrouter.instance
  ..get(
    version: "v1",
    path: "/index",
    handler: indexHandler,
  )
  ..get(
    version: "v1",
    path: "/index/:studentId/grades/:id",
    handler: withParamsHandler,
  );

Future<dynamic> main(final context) => router.initialize(
      context,
      onMiddleware: (req, res, payload, log, error, redirect, next) async {
        final studentId = req.params["studentId"] as String?;
        final passwordQuery = req.query["password"] as String?;

        if (studentId == "123" && passwordQuery == "123") {
          return redirect('/v1/index');
        } else {
          return next();
        }
      },
      onError: (req, res, errorLog, error) {
        errorLog("$error");
        return res.send(
          jsonEncode(error.message),
          error.status,
          {
            "content-type": "application/json",
          },
        );
      },
    );
