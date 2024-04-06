import { Client } from "node-appwrite";
import { AppwrouterRequest, AppwrouterResponse, MethodType } from "./type";

export type version = string;
export type HandleRequestType = {
  req: AppwrouterRequest;
  res: AppwrouterResponse;
  log: any;
  error: any;
  client: Client;
};

export type MatchRouteType = {
  version: string;
  method: MethodType;
  path: string;
};

export type RouteHandler = (handler: HandleRequestType) => Promise<any>;

export interface Route {
  [method: string]: RouteHandler;
}
export interface VersionedRoutes {
  [path: string]: Route;
}
