import { EventType } from "./type";

export const eventTypeParse = (eventType?: string) => {
  if (!eventType) {
    return {};
  }
  const parts = eventType.split(".");
  const map: { [key: string]: string } = {};

  for (let i = 0; i < parts.length; i += 2) {
    map[parts[i]] = parts[i + 1];
  }

  return map;
};

/**
 * Function to get the specific event type from a string
 * @param eventType - The event type string
 * @returns The specific event type
 */
export const getSpecificEventType = (eventType: string): EventType => {
  const segments = eventType.split(".");
  const lastSegment = segments[segments.length - 1];

  return lastSegment as EventType;
};

export const redirect = (req: any, path: string) => {
  req.path = path;
};
