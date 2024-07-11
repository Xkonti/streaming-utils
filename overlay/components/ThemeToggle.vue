<script setup lang="ts">
const themeStore = useThemeStore();
const { dark } = useQuasar();
dark.set(themeStore.darkMode);

const setDarkMode = (newValue: boolean) => {
  themeStore.darkMode = newValue;
  dark.set(newValue);
};
</script>

<template>
  <q-toggle
    :model-value="dark.isActive"
    color="grey-10"
    checked-icon="mdi-weather-night"
    unchecked-icon="mdi-weather-sunny"
    size="3rem"
    @update:model-value="(val) => setDarkMode(val)"
  />
</template>
