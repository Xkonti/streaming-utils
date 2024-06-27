import type {NewMessage} from "./messages";

import ComfyJS from "comfy.js";
import { pushMessage } from "./messages";

const channelName = "XkontiTech";

ComfyJS.onChat = async (user, message, flags, self, extra) => {
  //console.log({ user, message, flags, self, extra });
  console.log(`Received message from ${user} on Twitch`);

  const newMessage: NewMessage = {
    source: "tw",
    name: user,
    text: message,
  };
  await pushMessage(newMessage); 
};

export function initTwitch() {
  ComfyJS.Init(channelName);
}
