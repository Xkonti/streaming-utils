<template>
  <div class="row justify-center">
    <div class="chatbox q-pa-xs">
      <q-chat-message
        v-for="message in messages"
        :key="`${message.name} - ${message.timestamp}`"
        :name="message.name"
        avatar="https://cdn.quasar.dev/img/avatar1.jpg"
        :text="[message.text]"
        :stamp="`${message.secondsAgo} seconds ago`"
        :sent="!message.onRight"
        bg-color="amber-7"
        class="chat-message"
      >
        <template v-slot:avatar>
          <q-icon name="mdi-twitch" size="2.4rem" />
        </template>
      </q-chat-message>
      <div ref="chatboxend" />
    </div>
  </div>
</template>

<script setup>
import {computed, onBeforeUnmount, onMounted, ref, watch} from "vue";

defineOptions({
  name: 'TwitchChat'
})

import ComfyJS from 'comfy.js'

// 2k screen resolution
const resX = 2160
const resY = 1440

const chatboxend = ref(null);
const scrollToBottom = () => {
  if (chatboxend.value) {
    console.log( "Scrolling to bottom" )
    chatboxend.value.scrollIntoView({ behavior: "smooth" });
  } else {
    console.log( "No chatbox" )
  }
};


const maxMessageLifetime = 1000 * 60 * 5 // 5 minutes

/**
 * @type {Ref<UnwrapRef<*[{
 *   name: string,
 *   text: string,
 *   timestamp: number,
 *   date: string,
 *   onRight: boolean,
 * }]>>}
 */
const rawMessages = ref([
  {
    name: "Hardcoded 1",
    text: "Hello",
    timestamp: Date.now() - 4000,
    correctedTime: Date.now() - 4000,
  },
  {
    name: "Hardcoded 1",
    text: "Hello",
    timestamp: Date.now() - 4000,
    correctedTime: Date.now() - 4000,
  },
  {
    name: "Hardcoded 1",
    text: "Hello",
    timestamp: Date.now() - 4000,
    correctedTime: Date.now() - 4000,
  },
  {
    name: "Hardcoded 1",
    text: "Hello",
    timestamp: Date.now() - 4000,
    correctedTime: Date.now() - 4000,
  },
  {
    name: "Hardcoded 1",
    text: "Hello",
    timestamp: Date.now() - 4000,
    correctedTime: Date.now() - 4000,
  },
  {
    name: "Hardcoded 1",
    text: "Hello",
    timestamp: Date.now() - 4000,
    correctedTime: Date.now() - 4000,
  },
  {
    name: "Hardcoded 1",
    text: "Hello",
    timestamp: Date.now() - 4000,
    correctedTime: Date.now() - 4000,
  },
  {
    name: "Hardcoded 1",
    text: "Hello",
    timestamp: Date.now() - 4000,
    correctedTime: Date.now() - 4000,
  },
  {
    name: "Hardcoded 1",
    text: "Hello",
    timestamp: Date.now() - 4000,
    correctedTime: Date.now() - 4000,
  },
  {
    name: "Hardcoded 1",
    text: "Hello",
    timestamp: Date.now() - 4000,
    correctedTime: Date.now() - 4000,
  },
  {
    name: "Hardcoded 1",
    text: "Hello",
    timestamp: Date.now() - 4000,
    correctedTime: Date.now() - 4000,
  },
])
const currentTime = ref(Date.now());

const messages = computed(() => {
  return rawMessages.value.map((msg) => {
    return {
      ...msg,
      secondsAgo: Math.floor((currentTime.value - msg.correctedTime) / 1000)
    }
  })
})

const refreshMessages = () => {
  // Remove messages that are older than maxMessageLifetime
  rawMessages.value = rawMessages.value.filter((msg) =>
    currentTime.value - msg.correctedTime <= maxMessageLifetime
  )
  // Update the current time to refresh the messages timestamps
  currentTime.value = Date.now();
};

let interval;
onMounted(() => {
  interval = setInterval(refreshMessages, 500);
});

onBeforeUnmount(() => {
  clearInterval(interval);
});

watch(
  () => messages,
  () => {
    scrollToBottom();
  },
  { deep: true }
);


ComfyJS.onChat = ( user, message, flags, self, extra ) => {
  console.log( { user, message, flags, self, extra } )

  // Convert the timestamp from a string to a number
  const timestamp = Number( extra.timestamp )

  // Get the last message
  const lastMessage = messages.value[messages.value.length - 1]
  let onRight = lastMessage ? lastMessage.onRight : true
  if (lastMessage && lastMessage.name !== user) {
    onRight = !onRight
  }

  rawMessages.value.push({
    name: user,
    text: message,
    timestamp: timestamp,
    correctedTime: currentTime.value,
    onRight,
  })
}

ComfyJS.Init("XkontiTech")

</script>

<style lang="scss">
.chatbox {
  width: 100%;
  height: 100vh;
  overflow-y: auto;
}
</style>
