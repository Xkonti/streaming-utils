import { Elysia, Context } from "elysia";
import { getAllMessages, getMessagesAfterId } from "./messages";
import { initTwitch, stopTwitch, isConnectedToTwitch } from "./twitch";
import {
  initYoutube,
  stopYoutube,
  isConnectedToYoutube,
  getConnectedVideoUrl,
} from "./youtube";

export function addChatEndpoints(app: Elysia) {
  app.get("/chat/messages/all", getAllMessagesHandler);
  app.get("/chat/messages/last", getLastMessagesHandler);
  app.get("/chat/status", getStatusHandler);
  app.post("/chat/twitch/start", startTwitchHandler);
  app.post("/chat/twitch/stop", stopTwitchHandler);
  app.post("/chat/youtube/start", startYoutubeHandler);
  app.post("/chat/youtube/stop", stopYoutubeHandler);
}

async function getAllMessagesHandler() {
  //console.log("Requested all messages");
  return getAllMessages();
}

async function getLastMessagesHandler(context: Context) {
  const { query } = context;
  const lastId = query.lastId;
  return getMessagesAfterId(lastId);
}

async function getStatusHandler(context: Context) {
  console.log("Requested status");
  return {
    twitch: isConnectedToTwitch(),
    youtube: isConnectedToYoutube(),
    youtubeUrl: getConnectedVideoUrl(),
  };
}

async function startTwitchHandler(context: Context) {
  const { error, set } = context;
  console.log("Requested to start Twitch chat");
  try {
    await initTwitch();
    set.status = 200;
  } catch (e) {
    console.log("Failed to initialize Twitch chat");
    error(500, "Failed to initialize Twitch chat: " + e);
  }
}

async function stopTwitchHandler(context: Context) {
  const { error, set } = context;
  console.log("Requested to stop Twitch chat");
  try {
    await stopTwitch();
    set.status = 200;
  } catch (e) {
    console.log("Failed to stop Twitch chat");
    error(500, "Failed to stop Twitch chat: " + e);
  }
}

async function startYoutubeHandler(context: Context) {
  const { error, query, set } = context;
  console.log("Requested to start YouTube chat");
  try {
    const videoUrl = query.videoUrl;
    if (videoUrl == null || videoUrl === "") {
      error(400, "Missing videoId query parameter");
      return;
    }
    await initYoutube(videoUrl);
    set.status = 200;
  } catch (e) {
    console.log("Failed to initialize YouTube chat");
    error(500, "Failed to initialize YouTube chat: " + e);
  }
}

async function stopYoutubeHandler(context: Context) {
  const { error, set } = context;
  console.log("Requested to stop YouTube chat");
  try {
    await stopYoutube();
    set.status = 200;
  } catch (e) {
    console.log("Failed to stop YouTube chat");
    error(500, "Failed to stop YouTube chat: " + e);
  }
}
