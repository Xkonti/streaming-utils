import { initYoutube } from "../youtube";

export default defineEventHandler(async (event) => {
  console.log("Requested to start YouTube chat");
  try {
    const videoUrl = getQuery(event)?.videoUrl?.toString();
    if (videoUrl == null || videoUrl === "") {
      throw createError({
        statusCode: 400,
        message: "Missing videoId query parameter",
      });
    }
    await initYoutube(videoUrl);
  } catch (e) {
    throw createError({
      statusCode: 500,
      message: "Failed to initialize YouTube chat: " + e,
    });
  }
})