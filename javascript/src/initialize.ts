import { EventType, Initialize } from "./type/type";
import { eventTypeParse, getSpecificEventType } from "./type/util";

export const initialize = async ({
  req,
  res,
  log,
  error,
  onMiddleware,
  onNext,
  onError,
}: Initialize): Promise<any> => {
  try {
    const triggeredType = req.headers["x-appwrite-trigger"];
    let fullEventType: string | undefined;
    let eventType: EventType | undefined;
    let eventMap: { [key: string]: string } | undefined;
    if (triggeredType === "event") {
      fullEventType = req.headers["x-appwrite-event"];
      eventMap = eventTypeParse(fullEventType);
      eventType = getSpecificEventType(fullEventType!);
    }
    const client = await onMiddleware({
      req,
      res,
      log,
      error,
      method: req.method,
      triggeredType,
      eventType,
      eventMap,
      path: req.path,
    });

    return await onNext(req, res, client);
  } catch (e: unknown) {
    return onError(e);
  }
};
