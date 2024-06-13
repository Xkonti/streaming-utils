import { updateMessageSubscribers } from "./subscribers";

export interface Message {
  source: "tw" | "yt";
  authorId: string;
  name: string;
  text: string;
  timestamp: number;
}

/**
 * Internal list of messages
 */
let messages: Message[] = [];
const maxMessageLifetime = 1000 * 60 * 5; // 5 minutes

export async function pushMessage(message: Message) {
  messages.push(message);
  // TODO: Remoce expired messages
  
  // Notify subscribers
  await updateMessageSubscribers(message);
}

export function getAllMessages(): Message[] {
  return [...messages];
}
