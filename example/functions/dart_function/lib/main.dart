import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:appwrouter/appwrouter.dart';
import 'package:dart_appwrite/dart_appwrite.dart';
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

Future<dynamic> main(final context) async {
  context.log("Initializing Appwrouter");
  return await initialize(
    Initialize(
        req: context.req,
        res: context.res,
        log: context.log,
        error: context.error,
        onMiddleware: (payload) async {
          final OnMiddleware(
            :log,
            :req,
            :triggeredType,
            :path,
            :method,
            :eventType,
            :eventMap,
          ) = payload;
          final client = Client();

          if (Platform.environment['APPWRITE_FUNCTION_ENDPOINT'] == null ||
              Platform.environment['APPWRITE_FUNCTION_API_KEY'] == null) {
            throw Exception(
                "APPWRITE_FUNCTION_ENDPOINT and APPWRITE_FUNCTION_API_KEY are required");
          }

          client
              .setEndpoint(Platform.environment['APPWRITE_FUNCTION_ENDPOINT']!)
              .setKey(Platform.environment['APPWRITE_FUNCTION_API_KEY']!);
          if (triggeredType == TriggeredType.event &&
              path == "/" &&
              method == MethodType.post) {
            if (eventType == EventType.update) {
              log('Event map: $eventMap');

              if (eventMap!["collections"] == "<COLLECTION_ID>" &&
                  eventMap["documents"]) {
                log('Redirecting to "/v1/some/other/path"');
                redirect(req, path: "/v1/some/other/path");
              }
            } else if (eventType == EventType.create) {
              if (eventMap!["users"]) {
                log('Redirecting to micro service "/v2/micro/users"');
                redirect(req, path: "/v2/micro/users");
              }
            }
          }

          return client;
        },
        onNext: (req, res, client) async {
          return await router.handleRequest(
            handlerequest: HandleRequest(
              req: req,
              res: res,
              log: context.log,
              error: context.error,
              client: client,
            ),
          );
        },
        onError: (e) {
          context.error(e.toString());
          return context.res.send(
            jsonEncode({
              "message": "Internal Server Error",
            }),
            500,
            {
              "content-type": "application/json",
            },
          );
        }),
  );
}
