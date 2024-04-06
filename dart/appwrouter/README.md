# Appwrouter

> Example of a simple router for Appwrite Cloud Functions with support for middlewares and error handling. [Click Me](https://github.com/moshOntong-IT/appwrouter/tree/master/example/functions/dart_function)

## Table of Contents

- [Introduction](#introduction)
  - [What is Appwrouter?](#what-is-appwrouter)
  - [Why Appwrouter?](#why-appwrouter)
  - [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Appwrouter Instance](#appwrouter-instance)
  - [get](#get)
  - [post](#post)
  - [put](#put)
  - [patch](#patch)
  - [delete](#delete)
  - [handleRequest](#handlerequest)
  - [Versioning Routes](#versioning-routes)
- [Initialization of Appwrouter](#initialization-of-appwrouter)
  - [onMiddleware](#onmiddleware)
    - [OnMiddleware Passed Parameters](#onmiddleware-passed-parameters)
  - [onNext](#onnext)
  - [onError](#onerror)
- [Redirects](#redirects)
- [Path Parameters](#path-parameters)

## Introduction

#### What is Appwrouter?

Appwrouter is a simple router for Appwrite Cloud Functions. It will help you to create a simple routing system, with support for middlewares and error handling.

#### Why Appwrouter?

Appwrite Cloud Functions does not have a built-in routing system. Appwrouter will help you to create a simple routing system for your Appwrite Cloud Functions. With Appwrouter, you can easily encapsulate your function logic and route it to the appropriate path. Lastly Appwrite Cloud function does not handle for path parameters (e.g. `/user/:id`), Appwrouter will help you to handle path parameters.

#### Features

- Robust routing system
- Middleware support
- Error handling
- Easy to use
- Path parameters
- Redirects
- Versioning Routes

## Installation

```bash
dart pub add appwrouter
```

## Usage

1. First, create a new instance of Appwrouter. Then register your routes using the `get`, `post`, `put`, `patch` and `delete` methods.

```dart
import 'package:appwrouter/appwrouter.dart';

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
```

2. Initialize the Approuter in the main method of Appwrite Cloud Function.

```dart

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
             ///  In Middleware, you can do some operation for handling the redirect path, or you can do some operation before it proceed to `onNext` function. But after handling the middle make sure to return the `Client` object from Appwrite SDK.
             //  ...

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

```

## Appwrouter Instance

#### get

```dart
Appwrouter.instance..get(
    version: "v1",
    path: "/",
    handler: (handleRequest) async {
      handleRequest.res.send("Hello World");
    },
  )
```

#### post

```dart
Appwrouter.instance..post(
    version: "v1",
    path: "/",
    handler: (handleRequest) async {
      handleRequest.res.send("Hello World");
    },
  )
```

#### put

```dart
Appwrouter.instance..put(
    version: "v1",
    path: "/",
    handler: (handleRequest) async {
      handleRequest.res.send("Hello World");
    },
  )
```

#### patch

```dart
Appwrouter.instance..patch(
    version: "v1",
    path: "/",
    handler: (handleRequest) async {
      handleRequest.res.send("Hello World");
    },
  )
```

#### delete

```dart
Appwrouter.instance..delete(
    version: "v1",
    path: "/",
    handler: (handleRequest) async {
      handleRequest.res.send("Hello World");
    },
  )
```

#### handleRequest

The third parameter of route handler is an function which will be called when the route is matched. The function will receive an object with the following properties:

- `req`: The AppwrouterRequest that mimic the request object in the Appwrite SDK.
- `res`: The AppwrouterResponse that mimic the response object in the Appwrite SDK.
- `log`: The log object.
- `error`: The error object.
- `client`: The Appwrite SDK client object.

```dart
Appwrouter.instance..get(
    version: "v1",
    path: "/",
    handler: (handleRequest) async {
      handleRequest.res.send("Hello World");
    },
  )
```

It recommend to encapsulate the route handler logic in a separate function and pass it as a parameter to the route handler.

```dart

Future<dynamic> handler(HandleRequest handler) async {
  handler.res.send("Hello World");
}
Appwrouter.instance
  ..get(
    version: "v1",
    path: "/",
    handler: handler,
  )
```

> Please be informed that the `handleRequest` function should be returned as same how Appwrite cloud function returning a response. For resources on how to return a response in Appwrite cloud function, please refer to the [Appwrite Cloud Function Response documentation](https://appwrite.io/docs/products/functions/development#response).

#### Versioning Routes

In Appwrouter, you can indicate the version of the route by passing the version as the first parameter of the route handler.

```dart
Appwrouter.instance
  ..get(
    version: "v1",
    path: "/",
    handler: handler,
  )
```

> Why versioning routes? Versioning routes is a good practice to maintain backward compatibility. By versioning your routes, you can easily maintain multiple versions of the same route.

## Initialization of Appwrouter

#### `onMiddleware`

In `onMiddleware` function, you can do some operation for handling the redirect path, or you can do some operation before it proceed to `onNext` function. But after handling the middle make sure to return the `Client` object from Appwrite SDK.

```dart
onMiddleware:  (payload) {
  final OnMiddleware(
            :log,
            :req,
            :triggeredType,
            :path,
            :method,
            :eventType,
            :eventMap,
  ) = payload;
  //  In Middleware, you can do some operation for handling the redirect path, or you can do some operation before it proceed to `onNext` function. But after handling the middle make sure to return the `Client` object from Appwrite SDK.
  //  ...
  return client;
},
```

##### OnMiddleware Passed Parameters

The `onMiddleware` function have the following parameters:

- `req`: AppwrouterRequest object that mimic the request object in the Appwrite SDK.
- `res`: AppwrouterResponse object that mimic the response object in the Appwrite SDK.
- `log`: The log object.
- `error`: The error object.
- `method`: The HTTP method of the request. For example, `GET`, `POST`, `PUT`, `PATCH`, `DELETE`.
- `triggeredType` : The type of the trigger. For example, `http`, `schedule`, `event`.
- `eventType` : The type of the event. For example, `create`, `update`, `delete`. This parameter is only available when the `triggeredType` is `event`. It means that this could be a `undefined` value.
- eventMap : The event map object. This parameter is only available when the `triggeredType` is `event`. It means that this could be a `undefined` value. In the `x-appwrite-event` header, it contains a string, for example, `databases.[id].collections.[id].documents.[id].create`. This string will be converted to an object. For example, `eventMap` will be

```dart
{
  'databases': '[id]',
  'collections': '[id]',
  'documents': '[id]'
}
```

#### `onNext`

In `onNext` function, you can call the `handleRequest` function from the Appwrouter instance.

```dart
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
```

#### `onError`

This function will be called when an error occurs in the Appwrite Cloud Function.

```dart
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
```

## Redirects

In Appwrouter, can handle redirects by using the `redirect` method from Appwrouter package. If you want a redirect or manipulating the default path that given by Appwrite Cloud Function, then handle the redirect path in `onMiddleware` function.

```dart
redirect(req, path: "/v1/some/other/path");
```

In Example usage:

```dart
onMiddleware:  (payload) {
  final OnMiddleware(
            :log,
            :req,
            :triggeredType,
            :path,
            :method,
            :eventType,
            :eventMap,
  ) = payload;


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

                // Here you can handle the redirect path
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
```

## Path Parameters

In Appwrite Cloud Function, it already gives you how to get the query parameters by using `req.query` object. But it does not handle the path parameters. In Appwrouter, you can handle the path parameters by using the `req.params` object.

```dart
Appwrouter.instance..get(
    version: "/user/:id,
    path: "/",
    handler: (handleRequest) async {
      final HandleRequest(
        :req,
        :res,
        :error,
        :log,
      ) = handler;
      final params = req.params;
      res.send("User ID: ${params["id"]}");
    },
  )
```

## License

MIT

```

```

```

```

```

```

```

```
