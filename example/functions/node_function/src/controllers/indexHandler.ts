import { RouteHandler } from "appwrouter";
import { AppwriteException } from "node-appwrite";

export const indexHandler: RouteHandler = async ({
  req,
  res,
  log,
  error,
  client,
}) => {
  try {
    log("Hi Appwriters, this is a log message");
    return res.send(
      JSON.stringify({
        message: "Hello from Appwrouter!",
      }),
      201,
      {
        "content-type": "application/json",
      }
    );
  } catch (e) {
    error(` ${e.message}`);
    if (e instanceof AppwriteException) {
      return res.send(
        JSON.stringify({
          message: e.message,
        }),
        500,
        {
          "content-type": "application/json",
        }
      );
    } else {
      return res.send(
        JSON.stringify({
          message: "An error occurred",
        }),
        500,
        {
          "content-type": "application/json",
        }
      );
    }
  }
};
