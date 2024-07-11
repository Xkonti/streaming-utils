<script setup>
const connectionStatusStore = useConnectionStatusStore();

const isYoutubeStateChanging = ref(true);
const isConnectedToYoutube = computed({
  get: () => connectionStatusStore.isYoutubeConnected,
  set: (value) => {
    connectionStatusStore.isYoutubeConnected = value;
  },
});
const youtubeVideoLink = computed({
  get: () => connectionStatusStore.youtubeVideoId,
  set: (value) => {
    connectionStatusStore.youtubeVideoId = value;
  },
});

onMounted(async () => {
  nextTick(async () => {
    const { data, status } = await useFetch("/api/chat/status");
    if (status.value !== "success" || data.value == null) {
      console.error("Error fetching YouTube status", data.value);
      // TODO: Display errror in some way
      isTwitchStateChanging.value = false;
      return;
    }

    const youtubeStatus = data.value.youtube;
    if (youtubeStatus == null) {
      console.error("Error fetching YouTube status", data.value);
      // TODO: Display errror in some way
      return;
    }
    isConnectedToYoutube.value = youtubeStatus;
    const url = data.value.youtubeUrl;
    if (url != null && url != "") youtubeVideoLink.value = url;
    isYoutubeStateChanging.value = false;
  });
});

const youtubeStatusLabel = computed(() => {
  if (isYoutubeStateChanging.value) {
    if (isConnectedToYoutube.value) {
      return "Disconnecting...";
    } else {
      return "Connecting...";
    }
  }

  if (isConnectedToYoutube.value) {
    return "Connected";
  }

  return "Not connected";
});

const youtubeConnectBtnLabel = computed(() => {
  if (isConnectedToYoutube.value) {
    return "Disconnect";
  } else {
    return "Connect";
  }
});

const videoId = computed(() => {
  if (!youtubeVideoLink.value) return "";
  const liveParts = youtubeVideoLink.value.split("/live/");
  if (liveParts.length !== 2) return "";
  const queryParts = liveParts[1].split("?");
  return queryParts[0];
});

const canConnectToYoutube = computed(() => {
  // If it's already connected, the buttin will display "Disconnect", so we should allow it
  if (isConnectedToYoutube.value) return true;
  return videoId.value && videoId.value.length >= 5;
});

const toggleYoutube = async () => {
  if (isYoutubeStateChanging.value) return;

  if (isConnectedToYoutube.value) disconnectYoutube();
  else connectYoutube();
};

async function connectYoutube() {
  isYoutubeStateChanging.value = true;
  try {
    await $fetch(`/api/chat/youtube/start?videoUrl=${youtubeVideoLink.value}`, {
      method: "POST",
    });
    isConnectedToYoutube.value = true;
    isYoutubeStateChanging.value = false;
    console.log("Connected to YouTube");
    return;
  } catch (e) {
    console.error("Failed to connect to YouTube", e);
    isYoutubeStateChanging.value = false;
  }
}

async function disconnectYoutube() {
  isYoutubeStateChanging.value = true;
  try {
    await $fetch("/api/chat/youtube/stop", {
      method: "POST",
    });
    isConnectedToYoutube.value = false;
    isYoutubeStateChanging.value = false;
    console.log("Disconnected from YouTube");
    return;
  } catch (e) {
    console.error("Failed to disconnect from YouTube", e);
    isYoutubeStateChanging.value = false;
  }
}
</script>

<template>
  <q-card>
    <q-card-section>
      <div class="text-h6">YouTube</div>
      <div
        class="text-subtitle2"
        :class="isConnectedToYoutube ? 'text-positive' : 'text-negative'"
      >
        {{ youtubeStatusLabel }}
      </div>
    </q-card-section>

    <q-card-section>
      <q-input
        v-model="youtubeVideoLink"
        :disable="isYoutubeStateChanging || isConnectedToYoutube"
        :suffix="videoId"
        type="url"
        label="YouTube video link"
      />
    </q-card-section>

    <q-card-actions>
      <q-btn
        :loading="isYoutubeStateChanging"
        :color="isConnectedToYoutube ? 'positive' : 'negative'"
        :disable="!canConnectToYoutube"
        flat
        :label="youtubeConnectBtnLabel"
        :icon="isConnectedToYoutube ? 'mdi-broadcast' : 'mdi-broadcast-off'"
        @click="toggleYoutube"
      />
    </q-card-actions>
  </q-card>
</template>
