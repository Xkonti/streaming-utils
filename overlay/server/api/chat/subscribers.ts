import { Message, getAllMessages } from "./messages";

export interface Subscriber {
  onMessages: (messages: Message[]) => Promise<boolean>;
  onAutodelete?: () => Promise<boolean>;
}

let subscribers: Subscriber[] = [];

export async function subscribe(subscriber: Subscriber) {
  subscribers.push(subscriber);
  const result = await subscriber.onMessages(getAllMessages())
  if (!result) autodelete(subscriber)
}

export async function unsubscribe(subscriber: Subscriber) {
  subscribers = subscribers.filter(s => s !== subscriber)
}

/**
 * Autodelete is used automatically when a subscriber is no longer responding to the callbacks properly.
 * @param subscriber Subscriber to autodelete
 */
export async function autodelete(subscriber: Subscriber) {
  subscribers = subscribers.filter(s => s !== subscriber)
  if (subscriber.onAutodelete)
    await subscriber.onAutodelete()
}

export async function updateMessageSubscribers(message: Message) {
  for (const subscriber of subscribers) {
    const isAlive = await subscriber.onMessages([message])
    if (!isAlive) autodelete(subscriber)
  }
}
