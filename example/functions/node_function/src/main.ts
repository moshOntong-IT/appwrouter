import { Appwrouter, redirect } from "appwrouter";
import { Client } from "node-appwrite";
import { indexHandler } from "./controllers/indexHandler";
import { withParamsHandler } from "./controllers/withParamsHandler";

const router = new Appwrouter();

// Define routes for v1
router.get("v1", "/index", indexHandler);

// with path params
router.get("v1", "/index/:studentId/grades/:id", withParamsHandler);

router;
export default async (context: any) => {
  return router.initialize({
    context,
    onMiddleware: async ({ req, res, log, error, redirect, next }) => {
      let studentId = req.params.studentId;
      let passwordQuery = req.query.password;

      if (studentId === "123" && passwordQuery === "password") {
        return redirect("/v1/index");
      } else {
        return next();
      }
    },

    onError: ({ req, res, errorLog, error }) => {
      errorLog(error.message);

      return res.send(
        JSON.stringify({
          message: "An error occurred",
        }),
        500,
        {
          "content-type": "application/json",
        }
      );
    },
  });
};
