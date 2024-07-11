import { defineStore } from 'pinia'

export const useThemeStore = defineStore({
  id: 'themeStore',
  state: () => ({
    darkMode: false,
  }),
  actions: {},
  persist: true,
})
