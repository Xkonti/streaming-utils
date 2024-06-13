import ComfyJS from "comfy.js";
import {addId, Message} from "./messages";
import { pushMessage } from "./messages";

const channelName = "XkontiTech";

ComfyJS.onChat = async (user, message, flags, self, extra) => {
  //console.log({ user, message, flags, self, extra });
  console.log(`Received message from ${user} on Twitch`);

  const newMessage: Message = {
    id: "",
    source: "tw",
    name: user,
    text: message,
    timestamp: Date.now(),
  };
  await pushMessage(addId(newMessage));
};

export function initTwitch() {
  ComfyJS.Init(channelName);
}
