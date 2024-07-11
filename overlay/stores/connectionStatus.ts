import { defineStore } from 'pinia'

export const useConnectionStatusStore = defineStore('connectionStatus', {
  state: () => {
    return {
      isTwitchConnected: false,
      twitchChannel: "",
      isYoutubeConnected: false,
      youtubeVideoId: "",
    }
  },
  persist: true,
})