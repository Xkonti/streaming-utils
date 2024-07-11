import { initTwitch } from "../twitch";

export default defineEventHandler(async (event) => {
  console.log("Requested to start Twitch chat");
  try {
    const channelName = getQuery(event)?.channel?.toString();
    if (channelName == null || channelName === "") {
      throw createError({
        statusCode: 400,
        message: "Missing channel query parameter",
      });
    }
    await initTwitch(channelName);
  } catch (e) {
    console.log("Failed to initialize Twitch chat");
    throw createError({
      statusCode: 500,
      message: "Failed to initialize Twitch chat: " + e,
    })
  }
})