import { Client } from "node-appwrite";
import {
  RouteMatchHandler,
  RouteHandler,
  version,
  VersionedRoutes,
} from "./type/routerType";
import {
  AppwrouterRequest,
  AppwrouterResponse,
  EventType,
  Initialize,
  MethodType,
  MiddlewarePayload,
  TriggeredType,
} from "./type/type";

import { eventTypeParse, getSpecificEventType } from "./type/util";
import { AppwrouterException } from "./type/appwrouter_exception";

class Appwrouter {
  private versions: { [version: version]: VersionedRoutes };
  constructor() {
    this.versions = {};
  }

  register(
    version: version,
    method: MethodType,
    path: string,
    handler: RouteHandler
  ) {
    if (!this.versions[version]) {
      this.versions[version] = {};
    }
    if (!this.versions[version][path]) {
      this.versions[version][path] = {};
    }
    this.versions[version][path][method.toUpperCase()] = handler;
  }

  private client?: Client;
  private req?: AppwrouterRequest;
  private res?: AppwrouterResponse;

  private log: any;
  private errorLog: any;

  get(version: version, path: string, handler: RouteHandler): void {
    this.register(version, "GET", path, handler);
  }

  post(version: version, path: string, handler: RouteHandler): void {
    this.register(version, "POST", path, handler);
  }

  delete(version: version, path: string, handler: RouteHandler): void {
    this.register(version, "DELETE", path, handler);
  }

  put(version: version, path: string, handler: RouteHandler): void {
    this.register(version, "PUT", path, handler);
  }

  patch(version: version, path: string, handler: RouteHandler): void {
    this.register(version, "PATCH", path, handler);
  }

  matchRoute(): RouteMatchHandler {
    const pathSegments = this.req!.path.split("/");
    if (pathSegments.length < 2) {
      throw new Error("Bad Request");
      // // return { code: 400, message: "Bad Request" };
      // error("Bad Request");
      // return res.send(
      //   JSON.stringify({
      //     message: "Bad Request",
      //   }),
      //   400,
      //   {
      //     "content-type": "application/json",
      //   }
      // );
    }

    const version = pathSegments[1];

    const method = this.req!.method.toUpperCase() as MethodType;
    const path = `/${pathSegments.slice(2).join("/")}`;

    const routes = this.versions[version];
    if (!routes) {
      this.errorLog("The version indicate does not exist on registration");
      throw new AppwrouterException(
        "The requested endpoint version could not be found. Please ensure that the specified version exists and is correctly configured in your application.",
        400
      );
    }
    var params: Record<string, any> = {};
    for (const route in routes) {
      params = {};
      if (routes[route][method]) {
        const routePattern = route.split("/").filter(Boolean);
        const pathSegments = path.split("/").filter(Boolean);

        if (routePattern.length !== pathSegments.length) continue;

        const params: { [key: string]: string } = {}; // Add index signature to params object
        const isMatch = routePattern.every((segment, i) => {
          if (segment.startsWith(":")) {
            params[segment.slice(1)] = pathSegments[i];
            return true;
          }
          return segment === pathSegments[i];
        });

        if (isMatch) {
          let newReq = { ...this.req!, params: params };
          this.req = newReq;
          return {
            path,
            version,
            method,
            handler: routes[route][method],
            params,
          };
        }
      }
    }
    return {
      path,
      version,
      method,

      params,
    };
  }

  async handleRequest({
    routeMatch,
  }: {
    routeMatch: RouteMatchHandler;
  }): Promise<any> {
    if (!routeMatch.handler) {
      this.errorLog(
        `No route found for ${routeMatch.path} with method ${routeMatch.method}`
      );

      return this.res!.send(
        JSON.stringify({
          message: `The requested endpoint ${routeMatch.path} was not found for API version ${routeMatch.version}.`,
        }),
        404,
        {
          "content-type": "application/json",
        }
      );
    }

    this.log(
      `Matched route: ${this.req!.path} with method ${this.req!.method}`
    );

    try {
      return await routeMatch.handler!({
        req: this.req!,
        res: this.res!,
        log: this.log,
        error: this.errorLog,
        client: this.client!,
        // req: { ...this.req!, params: matchedRoute.params },
        // res,
        // log,
        // error,
        // client,
      });
    } catch (e) {
      this.errorLog(`Handler execution failed: ${e}`);
      return this.res!.send(
        JSON.stringify({
          message: "Route handler failed",
          error: e,
        }),
        500,
        {
          "content-type": "application/json",
        }
      );
    }
  }

  // TODO kani nalang sunda lang ang initialize implemented sa dart version
  initialize = async ({
    context,
    onMiddleware,
    onError,
  }: Initialize): Promise<any> => {
    let req: AppwrouterRequest = context.req;
    let res: AppwrouterResponse = context.res;
    let log = context.log;
    let error = context.error;

    try {
      this.clean();
      this.client = new Client();
      this.req = req;
      this.res = res;
      this.log = log;
      this.errorLog = error;

      log("Initializing Appwrouter...");
      let routeMatch = this.matchRoute();

      if (!onMiddleware) {
        return this.handleRequest({ routeMatch });
      } else {
        const triggeredType: TriggeredType = req.headers["x-appwrite-trigger"];

        let fullEventType: string | undefined;
        let eventType: EventType | undefined;
        let eventMap: { [key: string]: string } | undefined;

        if (triggeredType === "event") {
          fullEventType = req.headers["x-appwrite-event"];
          eventMap = eventTypeParse(fullEventType);
          eventType = getSpecificEventType(fullEventType!);
        }

        const middlewarePayload: MiddlewarePayload = {
          client: this.client,
          method: req.method,
          triggeredType,
          eventType,
          eventMap,
        };

        const onMiddleWareResponse = onMiddleware({
          req,
          res,
          payload: middlewarePayload,
          log,
          error: this.errorLog,
          redirect: this.redirect,
          next: this.next,
        });

        return onMiddleWareResponse;
      }
    } catch (e: unknown) {
      if (e instanceof AppwrouterException) {
        if (!onError) {
          error(e.message);
          return res.send(
            JSON.stringify({
              message: e.message,
            }),
            e.status,
            {
              "content-type": "application/json",
            }
          );
        } else {
          return onError({
            req,
            res,
            error,
            errorLog: e,
          });
        }
      } else {
        if (!onError) {
          error(e);
          return res.send(
            JSON.stringify({
              message: e,
            }),
            500,
            {
              "content-type": "application/json",
            }
          );
        } else {
          return onError({
            req,
            res,
            error,
            errorLog: e,
          });
        }
      }
      // try {
      //   const triggeredType = req.headers["x-appwrite-trigger"];
      //   let fullEventType: string | undefined;
      //   let eventType: EventType | undefined;
      //   let eventMap: { [key: string]: string } | undefined;
      //   if (triggeredType === "event") {
      //     fullEventType = req.headers["x-appwrite-event"];
      //     eventMap = eventTypeParse(fullEventType);
      //     eventType = getSpecificEventType(fullEventType!);
      //   }
      //   const client = await onMiddleware({
      //     req,
      //     res,
      //     log,
      //     error,
      //     method: req.method,
      //     triggeredType,
      //     eventType,
      //     eventMap,
      //     path: req.path,
      //   });
      //   return await onNext(req, res, client);
      // } catch (e: unknown) {
      //   return onError(e);
      // }
    }
  };

  private clean() {
    this.client = undefined;
    this.req = undefined;
    this.res = undefined;
    this.log = undefined;
    this.errorLog = undefined;
  }

  private redirect(path: string) {
    this.req = { ...this.req!, path };
    const routeMatch = this.matchRoute();
    return this.handleRequest({ routeMatch });
  }

  private next() {
    const routeMatch = this.matchRoute();
    return this.handleRequest({ routeMatch });
  }
}

export default Appwrouter;
