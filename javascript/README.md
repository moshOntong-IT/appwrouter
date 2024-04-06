# Appwrouter

> Example of a simple router for Appwrite Cloud Functions with support for middlewares and error handling. [Click Me](https://github.com/moshOntong-IT/appwrouter/tree/master/example/functions/node_function)

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
npm install appwrouter
```

for yarn users:

```bash
yarn add appwrouter
```

for pnpm users:

```bash
pnpm add appwrouter
```

for bun users:

```bash
bun add appwrouter
```

## Usage

1. First, create a new instance of Appwrouter. Then register your routes using the `get`, `post`, `put`, `patch` and `delete` methods.

```typescript
import { Appwrouter } from "appwrouter";

const router = new Appwrouter();

router.get("v1", "/", async ({ req, res, log, error, client }) => {
  res.send("Hello World");
});
```

2. Initialize the Approuter in the main method of Appwrite Cloud Function.

```typescript

export default async ({req,res,log,error})={
    return await initialize({
    req,
    res,
    log,
    error,
    onMiddleware: async ({
      req,
      res,
      log,
      error,
      path,
      eventMap,
      eventType,
      method,
      triggeredType,
    }) => {
     ///  In Middleware, you can do some operation for handling the redirect path, or you can do some operation before it proceed to `onNext` function. But after handling the middle make sure to return the `Client` object from Appwrite SDK.
    //  ...
     return client
    },
    onNext: async (req,res,client) => {
      return await router.handleRequest({ req, res, log, error, client });
    },
    onError: (e) => {

      return res.send(
        JSON.stringify({
          message: "Internal server error",
          error: e,
        }),
        500,
        {
          "content-type": "application/json",
        }
      );
    },
  });
}
```

## Appwrouter Instance

#### get

```typescript
router.get("v1", "/", async ({ req, res, log, error, client }) => {
  res.send("Hello World");
});
```

#### post

```typescript
router.post("v1", "/", async ({ req, res, log, error, client }) => {
  res.send("Hello World");
});
```

#### put

```typescript
router.put("v1", "/", async ({ req, res, log, error, client }) => {
  res.send("Hello World");
});
```

#### patch

```typescript
router.patch("v1", "/", async ({ req, res, log, error, client }) => {
  res.send("Hello World");
});
```

#### delete

```typescript
router.delete("v1", "/", async ({ req, res, log, error, client }) => {
  res.send("Hello World");
});
```

#### handleRequest

The third parameter of route handler is an function which will be called when the route is matched. The function will receive an object with the following properties:

- `req`: The request object.
- `res`: The response object.
- `log`: The log object.
- `error`: The error object.
- `client`: The Appwrite SDK client object.

```typescript
router.get("v1", "/", async ({ req, res, log, error, client }) => {
  res.send("Hello World");
});
```

It recommend to encapsulate the route handler logic in a separate function and pass it as a parameter to the route handler.

```typescript
import { RouteHandler } from "appwrouter";

const handler: RouteHandler = async ({ req, res, log, error, client }) => {
  res.send("Hello World");
};

router.get("v1", "/", handler);
```

> Please be informed that the `handleRequest` function should be returned as same how Appwrite cloud function returning a response. For resources on how to return a response in Appwrite cloud function, please refer to the [Appwrite Cloud Function Response documentation](https://appwrite.io/docs/products/functions/development#response).

#### Versioning Routes

In Appwrouter, you can indicate the version of the route by passing the version as the first parameter of the route handler.

```typescript
router.get("v1", "/", async ({ req, res, log, error, client }) => {
  res.send("Hello World");
});
```

> Why versioning routes? Versioning routes is a good practice to maintain backward compatibility. By versioning your routes, you can easily maintain multiple versions of the same route.

## Initialization of Appwrouter

#### `onMiddleware`

In `onMiddleware` function, you can do some operation for handling the redirect path, or you can do some operation before it proceed to `onNext` function. But after handling the middle make sure to return the `Client` object from Appwrite SDK.

```typescript
onMiddleware: async ({
  req,
  res,
  log,
  error,
  path,
  eventMap,
  eventType,
  method,
  triggeredType,
}) => {
  //  In Middleware, you can do some operation for handling the redirect path, or you can do some operation before it proceed to `onNext` function. But after handling the middle make sure to return the `Client` object from Appwrite SDK.
  //  ...
  return client;
},
```

##### OnMiddleware Passed Parameters

The `onMiddleware` function have the following parameters:

- `req`: The request object.
- `res`: The response object.
- `log`: The log object.
- `error`: The error object.
- `method`: The HTTP method of the request. For example, `GET`, `POST`, `PUT`, `PATCH`, `DELETE`.
- `triggeredType` : The type of the trigger. For example, `http`, `schedule`, `event`.
- `eventType` : The type of the event. For example, `create`, `update`, `delete`. This parameter is only available when the `triggeredType` is `event`. It means that this could be a `undefined` value.
- eventMap : The event map object. This parameter is only available when the `triggeredType` is `event`. It means that this could be a `undefined` value. In the `x-appwrite-event` header, it contains a string, for example, `databases.[id].collections.[id].documents.[id].create`. This string will be converted to an object. For example, `eventMap` will be

```typescript
{
  'databases': '[id]',
  'collections': '[id]',
  'documents': '[id]'
}
```

#### `onNext`

In `onNext` function, you can call the `handleRequest` function from the Appwrouter instance.

```typescript
onNext: async (req,res,client) => {
  return await router.handleRequest({ req, res, log, error, client });
},
```

#### `onError`

This function will be called when an error occurs in the Appwrite Cloud Function.

```typescript
onError: (e) => {
  return res.send(
    JSON.stringify({
      message: "Internal server error",
      error: e,
    }),
    500,
    {
      "content-type": "application/json",
    }
  );
},
```

## Redirects

In Appwrouter, can handle redirects by using the `redirect` method from Appwrouter package. If you want a redirect or manipulating the default path that given by Appwrite Cloud Function, then handle the redirect path in `onMiddleware` function.

```typescript
redirect(req, "/v1/some/other/path");
```

In Example usage:

```typescript
onMiddleware: async ({
     req,
      res,
      log,
      error,
      path,
      eventMap,
      eventType,
      method,
      triggeredType,}) => {
        if (triggeredType === "event" && path === "/" && method === "POST") {
        if (eventType === "update") {
          log(`Event map: ${JSON.stringify(eventMap)}`);

          if (
            eventMap["collections"] === "<COLLECTION_ID>" &&
            eventMap["documents"]
          ) {
            log('Redirecting to "/v1/some/other/path"');

            // Here we are redirecting to another path
            redirect(req, "/v1/some/other/path");
          }
        } else if (eventType === "create") {
          if (eventMap["users"]) {
            log('Redirecting to micro service "/v2/micro/users"');

            /// Here we are redirecting to another path
            redirect(req, "/v2/micro/users");
          }
        }
      }
  }
  return client;
},
```

## Path Parameters

In Appwrite Cloud Function, it already gives you how to get the query parameters by using `req.query` object. But it does not handle the path parameters. In Appwrouter, you can handle the path parameters by using the `req.params` object.

```typescript
router.get("v1", "/user/:id", async ({ req, res, log, error, client }) => {
  const { id } = req.params;
  res.send(`User ID: ${id}`);
});
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
