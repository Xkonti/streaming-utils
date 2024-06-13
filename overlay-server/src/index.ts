import { Elysia } from "elysia";
import { initTwitch } from "./chat/twitch";
import { Subscriber, subscribe } from "./chat/subscribers";
import { Message } from "./chat/messages";

const app = new Elysia()
  .get("/", async () => {
    let messages: Message[] = []
    const subscriber: Subscriber = {
      onMessages: async (msgs: Message[]) => {
        messages = msgs
        return true;
      },
    }
    await subscribe(subscriber)
    return messages;
  })
  .listen(3000);

initTwitch();

console.log(
  `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`
);
