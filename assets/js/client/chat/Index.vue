<template>
  <section id="card cui-utils-card-with-sidebar 
    cui-utils-card-with-sidebar-large">
    <Sidebar ref="sidebar" />
    <Toolbar ref="toolbar" />
    <Messages ref="messages" />
  </section>
</template>
<script>
import Sidebar from './components/sidebar/Sidebar.vue'
import Messages from './components/messages/Messages.vue'
import Toolbar from './components/toolbar/Toolbar.vue'
import settings from '../file_manager/mixins/settings'
import conversation from '../chat/mixins/conversation'
export default {
  mixins: [settings, conversation],
  created() {
    this.loadSettings()
    Notifications.setupChannelForUser(this.senderId)
  },
  components: {
    Sidebar, Messages, Toolbar
  }
}
</script>