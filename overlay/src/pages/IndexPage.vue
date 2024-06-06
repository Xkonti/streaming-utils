<template>
  <div class="overlay-container">
    Hello
    <TwitchChat />
  </div>
</template>

<script setup>
import TwitchChat from "components/Chat.vue";

defineOptions({
  name: 'IndexPage'
});
</script>
