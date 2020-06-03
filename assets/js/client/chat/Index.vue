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
export default {
  mixins: [settings],
  created() {
    this.loadSettings()
  },
  components: {
    Sidebar, Messages, Toolbar
  }
}
</script>