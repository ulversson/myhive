export default {
  computed: {
    textColor() {
      return this.$store.state.settings.default_color
    },
    defaultTab() {
      return this.$store.state.settings.default_tab
    },
    newItems() {
      return false
    },
    notificationsOn() {
      return this.$store.state.settings.notifications
    }
  },
  methods: {
    loadSettings() {
      return $.getJSON(`/api/v1/settings`, (jsonSettings) => {
        this.$store.commit('setSettings', jsonSettings)
      })
    }
  }
}