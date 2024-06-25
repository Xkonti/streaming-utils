import { updateMessageSubscribers } from "./subscribers";

/**
 * A message without an any specific identifiers nor a source
 */
export interface BareMessage {
  source: "tw" | "yt";
  name: string;
  text: string;
}

/**
 * Message that is associated to a specific source
*/
export interface NewMessage extends BareMessage {
  source: "tw" | "yt";
}

/**
 * A full message with an identifier, timestapmp and source
 */
export interface Message extends NewMessage {
  id: string;
  timestamp: number;
}

export type MockMessageHandlerRequester = (onMockMessage: (mockMessage: BareMessage) => void) => void;

/**
 * Internal list of messages
 */
let messages: Message[] = [
  {
    source: "tw",
    name: "Hardcoded 1",
    text: "Hello",
  },
  {
    source: "yt",
    name: "Hardcoded 1",
    text: "Hello",
  },
  {
    source: "tw",
    name: "Hardcoded 1",
    text: "Hello",
  },
  {
    source: "tw",
    name: "Hardcoded 1",
    text: "Hello",
  },
  {
    source: "yt",
    name: "Hardcoded 1",
    text: "Hello",
  },
  {
    source: "yt",
    name: "Hardcoded 1",
    text: "Hello",
  },
  {
    source: "tw",
    name: "Hardcoded 1",
    text: "Hello",
  },
  {
    source: "tw",
    name: "Hardcoded 1",
    text: "Hello",
  },
  {
    source: "yt",
    name: "Hardcoded 1",
    text: "Hello",
  },
  {
    source: "tw",
    name: "Hardcoded 1",
    text: "Hello",
  },
  {
    source: "tw",
    name: "Hardcoded 1",
    text: "Hello",
  },
].map(m => completeMsg(m as NewMessage));

const maxMessageLifetime = 1000 * 60 * 5; // 5 minutes

export async function pushMessage(newMessage: NewMessage) {
  let message = completeMsg(newMessage);
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

export function completeMsg(message: NewMessage): Message {
  let fullMessage = message as Message;
  fullMessage.timestamp = Date.now();
  fullMessage.id = `${fullMessage.source}:${fullMessage.name}:${fullMessage.timestamp}`;
  return fullMessage;
}