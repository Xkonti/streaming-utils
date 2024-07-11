import { isConnectedToTwitch, getTwitchChannel } from "./twitch";
import { isConnectedToYoutube, getConnectedVideoUrl } from "./youtube";

export default defineEventHandler(async (event) => {
  return {
    twitch: isConnectedToTwitch(),
    twitchChannel: getTwitchChannel(),
    youtube: isConnectedToYoutube(),
    youtubeUrl: getConnectedVideoUrl(),
  };
})