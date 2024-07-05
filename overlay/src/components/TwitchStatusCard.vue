<template>
  <q-card>
    <q-card-section>
      <div class="text-h6">Twitch</div>
      <div
        class="text-subtitle2"
        :class="isConnectedToTwitch ? 'text-positive' : 'text-negative'"
      >
        {{ twitchStatusLabel }}
      </div>
    </q-card-section>

    <q-card-actions>
      <q-btn
        :loading="isTwitchStateChanging"
        :color="isConnectedToTwitch ? 'positive' : 'negative'"
        flat
        :label="twitchConnectBtnLabel"
        :icon="isConnectedToTwitch ? 'mdi-broadcast' : 'mdi-broadcast-off'"
        @click="toggleTwitch"
      />
    </q-card-actions>
  </q-card>
</template>

<script setup>
import { ref, computed, onMounted } from "vue";
import { api } from "boot/axios.js";

defineOptions({
  name: "TwitchStatusCard",
});

const isTwitchStateChanging = ref(true);
const isConnectedToTwitch = ref(false);

onMounted(async () => {
  // TODO: Request status from the server
  const response = await api.get("chat/status");
  if (response.status !== 200) {
    console.error("Error fetching Twitch status", response.data);
    // TODO: Display errror in some way
    return;
  }

  const twitchStatus = response.data.twitch;
  if (twitchStatus == null) {
    console.error("Error fetching Twitch status", response.data);
    // TODO: Display errror in some way
    return;
  }
  isConnectedToTwitch.value = twitchStatus;
  isTwitchStateChanging.value = false;
});

const twitchStatusLabel = computed(() => {
  if (isTwitchStateChanging.value) {
    if (isConnectedToTwitch.value) {
      return "Disconnecting...";
    } else {
      return "Connecting...";
    }
  }

  if (isConnectedToTwitch.value) {
    return "Connected";
  }

  return "Not connected";
});

const twitchConnectBtnLabel = computed(() => {
  if (isConnectedToTwitch.value) {
    return "Disconnect";
  } else {
    return "Connect";
  }
});

const toggleTwitch = async () => {
  if (isTwitchStateChanging.value) return;

  if (isConnectedToTwitch.value) disconnectTwitch();
  else connectTwitch();
};

async function connectTwitch() {
  isTwitchStateChanging.value = true;
  try {
    const response = await api.post("chat/twitch/start");
    if (response.status === 200) {
      isConnectedToTwitch.value = true;
      isTwitchStateChanging.value = false;
      console.log("Connected to Twitch");
      return;
    }

    throw new Error("Failed to connect to Twitch");
    isTwitchStateChanging.value = false;
  } catch (e) {
    console.error("Failed to connect to Twitch", e);
    isTwitchStateChanging.value = false;
  }
}

async function disconnectTwitch() {
  isTwitchStateChanging.value = true;
  try {
    const response = await api.post("chat/twitch/stop");
    if (response.status === 200) {
      isConnectedToTwitch.value = false;
      isTwitchStateChanging.value = false;
      console.log("Disconnected from Twitch");
      return;
    }

    throw new Error("Failed to disconnect from Twitch");
    isTwitchStateChanging.value = false;
  } catch (e) {
    console.error("Failed to disconnect from Twitch", e);
    isTwitchStateChanging.value = false;
  }
}
</script>
