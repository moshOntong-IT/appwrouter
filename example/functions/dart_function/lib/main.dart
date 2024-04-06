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
      onMiddleware: (req, res, payload, client, redirect, next) async {
        return await next();
      },
      onError: (req, res, errorLog, error) {
        errorLog("$error");
        return res.send(
          jsonEncode(
            error.toString(),
          ),
          error is AppwrouterException ? error.status : 500,
          {
            "content-type": "application/json",
          },
        );
      },
    );
