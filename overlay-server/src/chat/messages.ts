import { updateMessageSubscribers } from "./subscribers";

export interface Message {
  id: string;
  source: "tw" | "yt";
  name: string;
  text: string;
  timestamp: number;
}

/**
 * Internal list of messages
 */
let messages: Message[] = [
  {
    id: "",
    source: "tw",
    name: "Hardcoded 1",
    text: "Hello",
    timestamp: Date.now() - 4000,
  },
  {
    id: "",
    source: "yt",
    name: "Hardcoded 1",
    text: "Hello",
    timestamp: Date.now() - 4800,
  },
  {
    id: "",
    source: "tw",
    name: "Hardcoded 1",
    text: "Hello",
    timestamp: Date.now() - 3100,
  },
  {
    id: "",
    source: "tw",
    name: "Hardcoded 1",
    text: "Hello",
    timestamp: Date.now() - 2510,
  },
  {
    id: "",
    source: "yt",
    name: "Hardcoded 1",
    text: "Hello",
    timestamp: Date.now() - 4000,
  },
  {
    id: "",
    source: "yt",
    name: "Hardcoded 1",
    text: "Hello",
    timestamp: Date.now() - 4000,
  },
  {
    id: "",
    source: "tw",
    name: "Hardcoded 1",
    text: "Hello",
    timestamp: Date.now() - 4000,
  },
  {
    id: "",
    source: "tw",
    name: "Hardcoded 1",
    text: "Hello",
    timestamp: Date.now() - 4000,
  },
  {
    id: "",
    source: "yt",
    name: "Hardcoded 1",
    text: "Hello",
    timestamp: Date.now() - 4000,
  },
  {
    id: "",
    source: "tw",
    name: "Hardcoded 1",
    text: "Hello",
    timestamp: Date.now() - 4000,
  },
  {
    id: "",
    source: "tw",
    name: "Hardcoded 1",
    text: "Hello",
    timestamp: Date.now() - 4000,
  },
].map(m => addId(m as Message));
const maxMessageLifetime = 1000 * 60 * 5; // 5 minutes

export async function pushMessage(message: Message) {
  messages.push(message);

  // Keep only the last 100 messages
  messages = messages.slice(-50);

  // TODO: Remove expired messages
  
  // Notify subscribers
  await updateMessageSubscribers(message);
}

export function getAllMessages(): Message[] {
  return [...messages];
}

export function addId(message: Message): Message {
  message.id = `${message.source}:${message.name}:${message.timestamp}`;
  return message;
}