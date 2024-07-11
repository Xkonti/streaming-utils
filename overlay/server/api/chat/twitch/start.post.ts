import { initTwitch } from "../twitch";

export default defineEventHandler(async (event) => {
  console.log("Requested to start Twitch chat");
  try {
    await initTwitch();
  } catch (e) {
    console.log("Failed to initialize Twitch chat");
    throw createError({
      statusCode: 500,
      message: "Failed to initialize Twitch chat: " + e,
    })
  }
})