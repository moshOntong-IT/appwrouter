import { Client } from "node-appwrite";
import { MethodType } from "./type";

export type HandleRequestType = {
  req: any;
  res: any;
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
