<template>
  <div class="row justify-center">
    <div class="chatbox q-pa-xs">
      <q-chat-message
        v-for="message in messages"
        :key="message.id"
        :name="message.name"
        :text="[`${message.name}: ${message.text}`]"
        :sent="true"
        bg-color="white"
        class="chat-message"
        style="font-size: 1.5rem;"
        size="10"
      >
        <template v-slot:avatar>
          <q-avatar
            font-size="2.4rem"
            text-color="white"
            :color="message.source === 'tw' ? 'deep-purple-6' : 'red'"
            :icon="message.source === 'tw' ? 'mdi-twitch' : 'mdi-youtube'"
            class="q-message-avatar--sent"
          />
        </template>
      </q-chat-message>
      <div ref="chatboxend" />
    </div>
  </div>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted, ref, watch } from "vue";
import {api} from "boot/axios.js";

defineOptions({
  name: "TwitchChat",
});

// 2k screen resolution
const resX = 2160;
const resY = 1440;

const chatboxend = ref(null);
const scrollToBottom = () => {
  if (chatboxend.value) {
    console.log("Scrolling to bottom");
    chatboxend.value.scrollIntoView({ behavior: "smooth" });
  } else {
    console.log("No chatbox");
  }
};

const maxMessageLifetime = 1000 * 60 * 5; // 5 minutes

/**
 * @type {Ref<UnwrapRef<*[{
 *   id: string,
 *   source: "tw" | "yt",
 *   name: string,
 *   text: string,
 *   timestamp: number,
 * }]>>}
 */
const rawMessages = ref([]);
const currentTime = ref(Date.now());

const messages = computed(() => {
  return rawMessages.value.map((msg) => {
    return {
      ...msg,
      secondsAgo: Math.floor((currentTime.value - msg.timestamp) / 1000),
    };
  });
});

const updateMessaged = async () => {
  // Request new messages from the server and update the list
  const response = await api.get("chat/messages/all")
  if (response.status !== 200) {
    console.error("Error fetching messages", response.data);
  } else {
    // TODO: When retrieving only small portions
    // Apply the new messages to the list making sure to not add duplicates
    // let newMessages = response.data
    //   .filter((newMessage) => {
    //     const oldMessage = rawMessages.value.find((rawMessage) => rawMessage.id === newMessage.id);
    //     return !oldMessage;
    //   });
    // rawMessages.value = [...rawMessages.value, ...newMessages];

    rawMessages.value = response.data;
  }

  // Remove messages that are older than maxMessageLifetime
  rawMessages.value = rawMessages.value.filter(
    (msg) => currentTime.value - msg.timestamp <= maxMessageLifetime,
  );
  // Update the current time to refresh the messages timestamps
  currentTime.value = Date.now();
};

let interval;
onMounted(() => {
  interval = setInterval(updateMessaged, 1000);
});

onBeforeUnmount(() => {
  clearInterval(interval);
});

watch(
  () => messages,
  () => {
    scrollToBottom();
  },
  { deep: true },
);
</script>

<style lang="scss">
.chatbox {
  width: 100%;
  height: 100vh;
  overflow-y: auto;
}
</style>
