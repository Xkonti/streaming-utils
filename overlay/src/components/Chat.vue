<template>
  <div class="row justify-center">
    <div class="chatbox q-pa-xs q-pt-md">
      <transition
        v-for="message in messages"
        :key="message.id"
        :appear="message.secondsAgo < 10"
        enter-active-class="animated slideInRight"
        leave-active-class="animated slideOutRight"
      >
        <q-chat-message
          :text="[
            `${message.name} (${message.secondsAgo} seconds ago):\n\n${message.text}`,
          ]"
          :sent="true"
          bg-color="white"
          class="chat-message"
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
          <div>
            <div class="row justify-between">
              <span class="msg-author">@{{ message.name }}:</span>
              <span class="msg-timestamp"
                >{{ message.secondsAgo }} seconds ago</span
              >
            </div>
            <div class="msg-content">{{ message.text }}</div>
          </div>
        </q-chat-message>
      </transition>
      <div ref="chatboxend" />
    </div>
  </div>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted, ref, watch } from "vue";
import { api } from "boot/axios.js";

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

const maxMessageLifetime = 1000 * 60 * 2; // 5 minutes

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

// The current time in milliseconds
// This is kept here to avoid recalculating the `messages` computed property too often.
// This needs to trigger that recalculation as we want the `seconds ago` to be updated on a proper interval.
const currentTime = ref(Date.now());

const messages = computed(() => {
  return rawMessages.value.map((msg) => {
    return {
      ...msg,
      secondsAgo: Math.floor((currentTime.value - msg.timestamp) / 1000),
    };
  });
});

const lastMessage = computed(() => {
  if (messages.value.length === 0) return null;
  return messages.value[messages.value.length - 1];
});

function optimizeRawMessages() {
  // Remove too old messages
  rawMessages.value = rawMessages.value.filter(
    (msg) => currentTime.value - msg.timestamp <= maxMessageLifetime,
  );

  // Update the current time to refresh the messages timestamps
  currentTime.value = Date.now();
}

const fetchNewMessages = async () => {
  // Request new messages from the server and update the list
  const response = await api.get(
    `chat/messages/last?lastId=${lastMessage.value?.id}`,
  );
  if (response.status !== 200) {
    console.error("Error fetching messages", response.data);
    return;
  }

  // Add new messages to the list, no need to make sure they are not duplicates
  const newMessages = response.data;
  rawMessages.value = [...rawMessages.value, ...newMessages];
  optimizeRawMessages();
};

let interval;
onMounted(async () => {
  // Load all messages from the server
  const response = await api.get("chat/messages/all");
  if (response.status !== 200) {
    rawMessages.value = [
      {
        id: "0000",
        source: "fe",
        name: "Frontend",
        text: "Failed to load messages from the server",
        timestamp: Date.now(),
      },
    ];
    console.error("Error fetching messages", response.data);
    return;
  }
  rawMessages.value = response.data;
  optimizeRawMessages();
  interval = setInterval(fetchNewMessages, 1000);
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

.msg-author {
  font-size: 1.5rem;
  font-weight: bold;
}

.msg-timestamp {
  font-size: 1.2rem;
  color: grey;
}

.msg-content {
  font-size: 1.5rem;
}
</style>
