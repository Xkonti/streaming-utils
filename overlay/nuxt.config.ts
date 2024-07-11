// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: "2024-04-03",
  devtools: { enabled: true },
  css: ["@/assets/custom.scss"],
  modules: [
    "@nuxt/eslint",
    "@pinia/nuxt",
    "nuxt-quasar-ui",
  ],

  quasar: {
    plugins: [
      "BottomSheet",
      "Dialog",
      "Loading",
      "LoadingBar",
      "Notify",
      "Dark",
    ],
    extras: {
      font: "roboto-font",
    },
    iconSet: "mdi-v7",
  },
});
