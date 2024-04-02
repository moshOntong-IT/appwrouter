import { describe, test, expect, jest } from "bun:test";
import { initialize } from "../src/initialize";
import { Middleware } from "../src/type/type";

describe("initialize", () => {
  test("should call onNext with the result of onMiddleware", async () => {
    const mockReq = {
      headers: {
        "x-appwrite-event": "test-event",
        "x-appwrite-trigger": "test-trigger",
      },
      method: "GET",
      path: "/test",
    };
    const mockRes = {};
    const mockLog = () => {};
    const mockError = () => {};
    const mockOnMiddleware = jest.fn().mockResolvedValue("middleware-result");
    const mockOnNext = jest.fn();
    const mockOnError = jest.fn();

    const middleware: Middleware = {
      req: mockReq,
      res: mockRes,
      log: mockLog,
      error: mockError,
      onMiddleware: mockOnMiddleware,
      onNext: mockOnNext,
      onError: mockOnError,
    };

    await initialize(middleware);

    expect(mockOnMiddleware).toHaveBeenCalled();
    expect(mockOnNext).toHaveBeenCalledWith("middleware-result");
    expect(mockOnError).not.toHaveBeenCalled();
  });

  test("should call onError when an error is thrown", async () => {
    const mockReq = {
      headers: {
        "x-appwrite-event": "test-event",
        "x-appwrite-trigger": "test-trigger",
      },
      method: "GET",
      path: "/test",
    };
    const mockRes = {};
    const mockLog = () => {};
    const mockError = () => {};
    const mockOnMiddleware = jest
      .fn()
      .mockRejectedValue(new Error("test error"));
    const mockOnNext = jest.fn();
    const mockOnError = jest.fn();

    const middleware: Middleware = {
      req: mockReq,
      res: mockRes,
      log: mockLog,
      error: mockError,
      onMiddleware: mockOnMiddleware,
      onNext: mockOnNext,
      onError: mockOnError,
    };

    await initialize(middleware);

    expect(mockOnMiddleware).toHaveBeenCalled();
    expect(mockOnNext).not.toHaveBeenCalled();
    expect(mockOnError).toHaveBeenCalledWith(new Error("test error"));
  });
});
