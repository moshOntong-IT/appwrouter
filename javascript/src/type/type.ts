import { Client } from "node-appwrite";

export type TriggeredType = "event" | "http" | "schedule ";
export type MethodType = "GET" | "POST" | "PUT" | "PATCH" | "DELETE";
export type EventType = "create" | "update" | "delete";

export interface OnMiddleware {
  req: AppwrouterRequest;
  res: AppwrouterResponse;
  log: any;
  error: any;
  method: MethodType;
  triggeredType: TriggeredType;
  eventType?: EventType;
  eventMap?: { [key: string]: string };
  path: string;
}
export interface Initialize {
  req: AppwrouterRequest;
  res: AppwrouterResponse;
  log: any;
  error: any;
  onMiddleware: (middleware: OnMiddleware) => Promise<Client> | Client;
  onNext: (
    req: AppwrouterRequest,
    res: AppwrouterResponse,
    client: Client
  ) => Promise<any> | any;
  onError: (error: unknown) => any;
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
