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
        log(req.params);
        return redirect('/v1/index');
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
