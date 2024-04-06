import 'dart:async';

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
        return next();
      },
      onError: (req, res, error) {
        return res.send(
          error.toString(),
          500,
          {
            "content-type": "application/json",
          },
        );
      },
    );
