import { Client } from "node-appwrite";
import { AppwrouterException } from "./appwrouter_exception";

export type TriggeredType = "event" | "http" | "schedule ";
export type MethodType = "GET" | "POST" | "PUT" | "PATCH" | "DELETE";
export type EventType = "create" | "update" | "delete";
export type Redirect = (path: string) => Promise<any>;
export type Next = () => Promise<any>;
export interface OnMiddleware {
  req: AppwrouterRequest;
  res: AppwrouterResponse;
  payload: MiddlewarePayload;
  log: any;
  error: any;
  redirect: Redirect;
  next: Next;
}

export interface OnError {
  req: AppwrouterRequest;
  res: AppwrouterResponse;
  errorLog: any;
  error: AppwrouterException;
}

export interface MiddlewarePayload {
  client: Client;
  method: MethodType;
  triggeredType: TriggeredType;
  eventType?: EventType;
  eventMap?: Record<string, any>;
}
export interface Initialize {
  context: any;
  onMiddleware?: (middleware: OnMiddleware) => Promise<any>;
  onError?: (error: OnError) => Promise<any>;
}

export interface AppwrouterRequest {
  bodyRaw: string;
  body: any;
  headers: { [key: string]: any };
  scheme: any;
  method: MethodType;
  url: string;
  host: string;
  port: number;
  path: string;
  queryString: string;
  query: { [key: string]: any };
  params?: { [key: string]: any };
}

export interface AppwrouterResponse {
  empty: any;
  json: any;
  redirect: any;
  send: any;
}
