import { getAllMessages } from "../messages";

export default defineEventHandler(async (event) => {
  return getAllMessages();
})