import { Client } from "node-appwrite";

export type TriggeredType = "event" | "http" | "schedule ";
export type MethodType = "GET" | "POST" | "PUT" | "PATCH" | "DELETE";
export type EventType = "create" | "update" | "delete";

export interface OnMiddleware {
  req: any;
  res: any;
  log: any;
  error: any;
  method: MethodType;
  triggeredType: TriggeredType;
  eventType?: EventType;
  eventMap?: { [key: string]: string };
  path: string;
}
export interface Middleware {
  req: any;
  res: any;
  log: any;
  error: any;
  onMiddleware: (middleware: OnMiddleware) => Promise<Client> | Client;
  onNext: (client: Client) => Promise<any> | any;
  onError: (error: unknown) => any;
}
