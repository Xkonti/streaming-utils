import ComfyJS from "comfy.js";
import type { Message } from "./messages";
import { pushMessage } from "./messages";

const channelName = "XkontiTech";

ComfyJS.onChat = async (user, message, flags, self, extra) => {
  console.log({ user, message, flags, self, extra });

  // Convert the timestamp from a string to a number
  const timestamp = Number(extra.timestamp);

  const newMessage: Message = {
    source: "tw",
    name: user,
    authorId: `twitch:${user}`,
    text: message,
    timestamp: timestamp,
  };
  await pushMessage(newMessage);
};

export function initTwitch() {
  ComfyJS.Init(channelName);
}
