// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: "2024-04-03",
  devtools: { enabled: true },
  css: ["@/assets/custom.scss"],
  modules: [
    "@nuxt/eslint",
    "@pinia/nuxt",
    "@pinia-plugin-persistedstate/nuxt",
    "nuxt-quasar-ui",
  ],

  quasar: {
    plugins: [
      "Dialog",
      "Loading",
      "LoadingBar",
      "Notify",
      "Dark",
    ],
    extras: {
      font: "roboto-font",
      fontIcons: ['material-icons'],
      animations: 'all',
    },
    iconSet: "mdi-v7", // https://pictogrammers.com/library/mdi/
  },

  routeRules: {
    "/": { redirect: "/dashboard" },
  },
});
