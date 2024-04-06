import {
  HandleRequestType,
  MatchRouteType,
  RouteHandler,
  version,
  VersionedRoutes,
} from "./type/routerType";
import { MethodType } from "./type/type";

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

  matchRoute({
    version,
    method,
    path,
  }: MatchRouteType): { handler: RouteHandler; params: any } | null {
    const routes = this.versions[version];
    if (!routes) return null;

    for (const route in routes) {
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
          return { handler: routes[route][method], params };
        }
      }
    }
    return null;
  }

  async handleRequest({
    req,
    res,
    log,
    error,
    client,
  }: HandleRequestType): Promise<any> {
    const pathSegments = req.path.split("/");
    if (pathSegments.length < 2) {
      // return { code: 400, message: "Bad Request" };
      error("Bad Request");
      return res.send(
        JSON.stringify({
          message: "Bad Request",
        }),
        400,
        {
          "content-type": "application/json",
        }
      );
    }

    const version = pathSegments[1];
    const method = req.method.toUpperCase();
    const path = `/${pathSegments.slice(2).join("/")}`;

    const matchedRoute = this.matchRoute({ version, method, path });

    if (!matchedRoute) {
      error(`No route found for ${path} with method ${method}`);
      return res.send(
        JSON.stringify({
          message: `The requested endpoint ${path} was not found for API version ${version}.`,
        }),
        404,
        {
          "content-type": "application/json",
        }
      );
    }

    log(`Matched route: ${path} with method ${method}`);

    try {
      return await matchedRoute.handler({
        req: { ...req, params: matchedRoute.params },
        res,
        log,
        error,
        client,
      });
    } catch (e) {
      error(`Handler execution failed: ${e}`);
      return res.send(
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
}

export default Appwrouter;
