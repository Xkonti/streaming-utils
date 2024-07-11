import { getMessagesAfterId } from "../messages";

export default defineEventHandler(async (event) => {
  const query = getQuery(event)
  const lastId = (query.lastId || query.lastid)?.toString();
  if (lastId == null) return [];
  return getMessagesAfterId(lastId);
})