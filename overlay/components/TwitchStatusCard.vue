<script setup>
const connectionStatusStore = useConnectionStatusStore();

const isTwitchStateChanging = ref(true);
const isConnectedToTwitch = computed({
  get: () => connectionStatusStore.isTwitchConnected,
  set: (value) => {
    connectionStatusStore.isTwitchConnected = value;
  },
});
const twitchChannel = computed({
  get: () => connectionStatusStore.twitchChannel,
  set: (value) => {
    connectionStatusStore.twitchChannel = value;
  },
});

onMounted(async () => {
  // TODO: Request status from the server
  nextTick(async () => {
    const { data, status } = await useFetch("/api/chat/status");
    if (status.value !== "success" || data.value == null) {
      console.error("Error fetching Twitch status", data.value);
      // TODO: Display errror in some way
      isTwitchStateChanging.value = false;
      return;
    }

    const twitchStatus = data.value.twitch;
    if (twitchStatus == null) {
      console.error("Error fetching Twitch status", data.value);
      // TODO: Display errror in some way
      return;
    }
    isConnectedToTwitch.value = twitchStatus;
    const channel = data.value.twitchChannel;
    if (channel != null && channel != "") twitchChannel.value = channel;
    isTwitchStateChanging.value = false;
  });
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

const canConnectToTwitch = computed(() => {
  // If it's already connected, the buttin will display "Disconnect", so we should allow it
  if (isConnectedToTwitch.value) return true;
  return twitchChannel.value && twitchChannel.value.length >= 1;
});

const toggleTwitch = async () => {
  if (isTwitchStateChanging.value) return;

  if (isConnectedToTwitch.value) disconnectTwitch();
  else connectTwitch();
};

async function connectTwitch() {
  isTwitchStateChanging.value = true;
  try {
    await $fetch(`/api/chat/twitch/start?channel=${twitchChannel.value}`, {
      method: "POST",
    });
    isConnectedToTwitch.value = true;
    isTwitchStateChanging.value = false;
    console.log("Connected to Twitch");
  } catch (e) {
    console.error("Failed to connect to Twitch", e);
    isTwitchStateChanging.value = false;
  }
}

async function disconnectTwitch() {
  isTwitchStateChanging.value = true;
  try {
    await $fetch("/api/chat/twitch/stop", {
      method: "POST",
    });
    isConnectedToTwitch.value = false;
    isTwitchStateChanging.value = false;
    console.log("Disconnected from Twitch");
  } catch (e) {
    console.error("Failed to disconnect from Twitch", e);
    isTwitchStateChanging.value = false;
  }
}
</script>

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

    <q-card-section>
      <q-input
        v-model="twitchChannel"
        :disable="isTwitchStateChanging || isConnectedToTwitch"
        type="text"
        label="Twitch channel name"
      />
    </q-card-section>

    <q-card-actions>
      <q-btn
        :loading="isTwitchStateChanging"
        :color="isConnectedToTwitch ? 'positive' : 'negative'"
        :disable="!canConnectToTwitch"
        flat
        :label="twitchConnectBtnLabel"
        :icon="isConnectedToTwitch ? 'mdi-broadcast' : 'mdi-broadcast-off'"
        @click="toggleTwitch"
      />
    </q-card-actions>
  </q-card>
</template>
