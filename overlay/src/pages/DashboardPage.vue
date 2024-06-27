<template>
  <q-page padding class="q-gutter-sm">
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
          type="url"
          label="YouTube video link"
        />
      </q-card-section>

      <q-card-actions>
        <q-btn
          :loading="isYoutubeStateChanging"
          :color="isConnectedToYoutube ? 'positive' : 'negative'"
          flat
          :label="youtubeConnectBtnLabel"
          :icon="isConnectedToYoutube ? 'mdi-broadcast' : 'mdi-broadcast-off'"
          @click="toggleYoutube"
        />
      </q-card-actions>
    </q-card>
  </q-page>
</template>

<script setup>
import { ref, computed } from "vue";

defineOptions({
  name: "DashboardPage",
});

// TWITCH

const isTwitchStateChanging = ref(false);
const isConnectedToTwitch = ref(false);

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
  await new Promise((resolve) => setTimeout(resolve, 1000));
  isConnectedToTwitch.value = true;
  isTwitchStateChanging.value = false;
}

async function disconnectTwitch() {
  isTwitchStateChanging.value = true;
  await new Promise((resolve) => setTimeout(resolve, 500));
  isConnectedToTwitch.value = false;
  isTwitchStateChanging.value = false;
}

// YOUTUBE

const isYoutubeStateChanging = ref(false);
const isConnectedToYoutube = ref(false);
const youtubeVideoLink = ref("");

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

const toggleYoutube = async () => {
  if (isYoutubeStateChanging.value) return;

  if (isConnectedToYoutube.value) disconnectYoutube();
  else connectYoutube();
};

async function connectYoutube() {
  isYoutubeStateChanging.value = true;
  await new Promise((resolve) => setTimeout(resolve, 1000));
  isConnectedToYoutube.value = true;
  isYoutubeStateChanging.value = false;
}

async function disconnectYoutube() {
  isYoutubeStateChanging.value = true;
  await new Promise((resolve) => setTimeout(resolve, 500));
  isConnectedToYoutube.value = false;
  isYoutubeStateChanging.value = false;
}
</script>
