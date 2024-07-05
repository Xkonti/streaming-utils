import { Elysia } from "elysia";
import { addChatEndpoints } from "./chat/endpoints";
import { cors } from '@elysiajs/cors'

// Initialize API
const app = new Elysia()
    .use(cors())
    .get("/", () => "Oh, hi there!");
addChatEndpoints(app);
app.listen(3000);

console.log(
  `Overlay server is running at ${app.server?.hostname}:${app.server?.port}`
);
