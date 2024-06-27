import { Elysia } from "elysia";
import { initTwitch } from "./chat/twitch";
import {initYoutube} from "./chat/youtube";
import { addChatEndpoints } from "./chat/endpoints";
import { cors } from '@elysiajs/cors'

// Initialize API
const app = new Elysia()
    .use(cors())
    .get("/", () => "Oh, hi there!");
addChatEndpoints(app);
app.listen(3000);

// Initialize Twitch chat
try {
  await initTwitch();
} catch (e) {
  console.log("Failed to initialize Twitch chat");
}

// Initialize YouTube chat
try {
  await initYoutube('zm7C-U0G62U'); 
} catch (e) {
  console.log("Failed to initialize YouTube chat");
}


console.log(
  `Overlay server is running at ${app.server?.hostname}:${app.server?.port}`
);
