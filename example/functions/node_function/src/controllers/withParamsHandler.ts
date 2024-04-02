import { RouteHandler } from "appwrouter";
import { AppwriteException } from "node-appwrite";

export const withParamsHandler: RouteHandler = async ({
  req,
  res,
  log,
  error,
  client,
}) => {
  try {
    const { studentId, id } = req.params;
    log("Hi Appwriters, this is a log message");
    log(JSON.stringify(req.params));
    return res.send(
      JSON.stringify({
        message: "Hello from Appwrouter!",
        data: {
          studentId,
          id,
        },
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
