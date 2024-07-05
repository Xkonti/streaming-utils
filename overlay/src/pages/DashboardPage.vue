<template>
  <q-page padding class="q-gutter-sm">
    <TwitchStatusCard />
    <YoutubeStatusCard />
  </q-page>
</template>

<script setup>
import { ref, computed } from "vue";
import TwitchStatusCard from "components/TwitchStatusCard.vue";
import YoutubeStatusCard from "components/YoutubeStatusCard.vue";

defineOptions({
  name: "DashboardPage",
});
</script>
