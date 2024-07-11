import { stopTwitch } from "../twitch";

export default defineEventHandler(async (event) => {
  console.log("Requested to stop Twitch chat");
  try {
    await stopTwitch();
  } catch (e) {
    console.log("Failed to stop Twitch chat");
    throw createError({
      statusCode: 500,
      message: "Failed to stop Twitch chat: " + e,
    });
  }
});
