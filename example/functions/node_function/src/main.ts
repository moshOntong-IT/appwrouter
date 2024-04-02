import { Appwrouter, initialize, redirect } from "appwrouter";
import { Client } from "node-appwrite";
import { indexHandler } from "./controllers/indexHandler";
import { withParamsHandler } from "./controllers/withParamsHandler";

const router = new Appwrouter();

// Define routes for v1
router.get("v1", "/index", indexHandler);

// with path params
router.get("v1", "/index/:studentId/grades/:id", withParamsHandler);

router;
export default async ({ req, res, log, error }) => {
  log("Initializing function");
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
      log("Initializing Appwrite client");
      const client = new Client();

      if (
        !Bun.env.APPWRITE_FUNCTION_ENDPOINT ||
        !Bun.env.APPWRITE_FUNCTION_API_KEY
      ) {
        throw new Error(
          "Environment variables are not set. Function cannot use Appwrite SDK."
        );
      }

      client
        .setEndpoint(Bun.env.APPWRITE_FUNCTION_ENDPOINT)
        .setProject(Bun.env.APPWRITE_FUNCTION_PROJECT_ID);

      log("Setting API key for Appwrite client");
      client.setKey(Bun.env.APPWRITE_FUNCTION_API_KEY);

      if (triggeredType === "event" && path === "/" && method === "POST") {
        if (eventType === "update") {
          log(`Event map: ${JSON.stringify(eventMap)}`);

          if (
            eventMap["collections"] === "<COLLECTION_ID>" &&
            eventMap["documents"]
          ) {
            log('Redirecting to "/v1/some/other/path"');
            redirect(req, "/v1/some/other/path");
          }
        } else if (eventType === "create") {
          if (eventMap["users"]) {
            log('Redirecting to micro service "/v2/micro/users"');
            redirect(req, "/v2/micro/users");
          }
        }
      }

      return client;
    },
    onNext: async (client) => {
      return await router.handleRequest({ req, res, log, error, client });
    },
    onError: (e) => {
      error(`Initialization failed: ${e}`);
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
};
