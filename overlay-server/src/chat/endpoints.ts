import { Elysia } from "elysia";
import { getAllMessages } from "./messages";

export function addChatEndpoints(app: Elysia) {
    app.get("/chat/messages/all", getAllMessagesHandler);
    app.get("/chat/messages/last", getLastMessagesHandler);
}

async function getAllMessagesHandler() {
    console.log("Requested all messages");
    return getAllMessages();
}

async function getLastMessagesHandler() {
    // TODO: Allow specifying number of seconds
    // TODO: Properly request last messages from the messages store
    return getAllMessages().slice(-10);
}