import { Elysia } from "elysia";
import { initTwitch } from "./chat/twitch";
import {initYoutube} from "./chat/youtube";
import { addChatEndpoints } from "./chat/endpoints";
import { cors } from '@elysiajs/cors'

const app = new Elysia()
    .use(cors())
    .get("/", () => "Oh, hi there!");
addChatEndpoints(app);
app.listen(3000);

initTwitch();
await initYoutube();

console.log(
  `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`
);
