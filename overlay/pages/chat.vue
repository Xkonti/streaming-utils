<script setup>
definePageMeta({
  layout: "empty",
});
</script>

<template>
  <div class="overlay-container">
    <div></div>

    <TwitchChat />
  </div>
</template>

<style scoped>
.overlay-container {
  display: grid;
  height: 100vh;
  grid-template-columns: auto 500px;
}
</style>
