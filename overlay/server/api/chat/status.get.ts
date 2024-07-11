import { isConnectedToTwitch } from "./twitch";
import { isConnectedToYoutube, getConnectedVideoUrl } from "./youtube";

export default defineEventHandler(async (event) => {
  return {
    twitch: isConnectedToTwitch(),
    youtube: isConnectedToYoutube(),
    youtubeUrl: getConnectedVideoUrl(),
  };
})