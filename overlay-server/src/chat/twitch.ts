import type {NewMessage} from "./messages";

import ComfyJS from "comfy.js";
import { pushMessage } from "./messages";

const channelName = "XkontiTech";
let isConnected = false;

export function isConnectedToTwitch() {
  return isConnected;
}

export function initTwitch() {
  if (isConnected) throw new Error("Twitch chat is already connected");

  // Setup events
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

  // Start connection
  ComfyJS.Init(channelName);
  isConnected = true;
}

export function stopTwitch() {
  if (!isConnected) throw new Error("Twitch chat is already disconnected");

  // Disconnect
  ComfyJS.Disconnect();

  // Reset events
  ComfyJS.onChat = () => {};

  isConnected = false;
}
