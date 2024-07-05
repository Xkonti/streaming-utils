import { updateMessageSubscribers } from "./subscribers";

/**
 * A message without an any specific identifiers nor a source
 */
export interface BareMessage {
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
    source: "yt",
    name: "Chat Server",
    text: "Chat server is up and running!",
  },
].map(m => completeMsg(m as NewMessage));

const maxMessageLifetime = 1000 * 60 * 60; // 60 minutes

export async function pushMessage(newMessage: NewMessage) {
  let message = completeMsg(newMessage);
  messages.push(message);
  purgeOldMessages();
  await updateMessageSubscribers(message);
}

export function getAllMessages(): Message[] {
  return messages;
}

export function getMessagesAfterId(lastId?: string): Message[] {
  // If no lastId is provided, return all messages
  // as the frontend might not know the lastId if
  // there were no messages during the initial load
  if (lastId == null) {
    return messages;
  }

  // Walk backwards through the messages array to find the message with the lastId
  for (let i = messages.length - 1; i >= 0; i--) {
    if (messages[i].id === lastId) {
      // Return all messages after the found message
      return messages.slice(i + 1);
    }
  }

  // If the lastId is not found, return an all messages
  return messages;
}

export function completeMsg(message: NewMessage): Message {
  let fullMessage = message as Message;
  fullMessage.timestamp = Date.now();
  fullMessage.id = `${fullMessage.source}:${fullMessage.name}:${fullMessage.timestamp}`;
  return fullMessage;
}

export function purgeOldMessages() {
  const currentTime = Date.now();
  const cutoffTime = currentTime - maxMessageLifetime;
  
  // Find the index of the first message that should be kept
  let indexToKeep = 0;
  while (indexToKeep < messages.length && messages[indexToKeep].timestamp < cutoffTime) {
    indexToKeep++;
  }
  
  // If we found messages to remove
  if (indexToKeep > 0) {
    // Remove old messages in a single operation
    messages = messages.slice(indexToKeep);
  }
  
  // If indexToKeep is 0, it means no messages were old enough to be removed,
  // so we don't need to do anything.
}