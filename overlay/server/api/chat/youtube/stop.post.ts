import { stopYoutube } from "../youtube";

export default defineEventHandler(async (event) => {
  console.log("Requested to stop YouTube chat");
  try {
    await stopYoutube();
  } catch (e) {
    console.log("Failed to stop YouTube chat");
    throw createError({
      statusCode: 500,
      message: "Failed to stop YouTube chat: " + e,
    });
  }
});
