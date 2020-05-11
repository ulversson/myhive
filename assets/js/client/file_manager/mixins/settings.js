export default {
  computed: {
    textColor() {
      return this.$store.state.settings.default_color
    },
    defaultTab() {
      return this.$store.state.settings.default_tab
    },
    newItems() {
      return this.$store.state.settings.new_items
    },
    notificationsOn() {
      return this.$store.state.settings.notifications
    }

  }
}