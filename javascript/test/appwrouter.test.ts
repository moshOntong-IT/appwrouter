import { describe, test, expect, beforeEach } from "bun:test";
import Appwrouter from "../src/appwrouter";
import { RouteHandler } from "../src/type/routerType";

describe("Appwrouter", () => {
  let router: Appwrouter;

  beforeEach(() => {
    router = new Appwrouter();
  });

  test("should register a route", () => {
    const handler: RouteHandler = async () => {}; // Add async keyword and specify the return type as Promise<any>
    router.register("v1", "GET", "/test", handler);

    const route = router.matchRoute({
      version: "v1",
      method: "GET",
      path: "/test",
    });

    expect(route).not.toBeNull();
    expect(route?.handler).toEqual(handler);
  });

  test("should register a route with path parameters", () => {
    const handler: RouteHandler = async () => {}; // Add async keyword and specify the return type as Promise<any>
    router.register("v1", "GET", "/test/:id/hello/:someID", handler);

    const route = router.matchRoute({
      version: "v1",
      method: "GET",
      path: "/test/123/hello/456",
    });

    expect(route).not.toBeNull();
    expect(route?.handler).toEqual(handler);
    expect(route?.params).toEqual({ id: "123", someID: "456" });
  });

  test("should return null for an unregistered route", () => {
    const route = router.matchRoute({
      version: "v1",
      method: "GET",
      path: "/test",
    });

    expect(route).toBeNull();
  });
});
