export default {
  computed: {
    senderId() {
      return this.userId
    },
    userName() {
      return $('.cui-topbar-avatar-dropdown').data('username')
    },
    avatar() {
      return Fn.decodeHtml($('.cui-topbar-avatar-dropdown')
        .data('avatar'))
        .replace(/\\"/g, '"')
    }
  },
  data() {
    return {
      userId: $('.cui-topbar-avatar-dropdown').data('user-id')
    }
  }
}