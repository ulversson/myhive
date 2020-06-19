import video from './video'
import conversation from './conversation'
import chatUser from './chatUser'
import AnswerCall from '../components/video/AnswerCall.vue'
export default {
  mixins: [video, conversation, chatUser],
  components: { AnswerCall },
  data() {
    return {
      callingUser: {}
    }
  },
  created() {
    this.connectToRoom('room:lobby', true)
    this.setupVideoChannel(this.socket)
  },
  methods: {
    callCallback(payload) {
      this.$set(this.callingUser,'avatar128', payload.user.avatar)
      this.$set(this.callingUser,'userName', payload.user.userName)
      this.$set(this.callingUser,'name', payload.user.name)
      this.$set(this.callingUser,'callerId', payload.user.userId)
      this.$set(this.callingUser,'isAudio', payload.user.isAudio)
      this.$set(this.callingUser,'isVideo', payload.user.isVideo)
      this.$set(this.callingUser, 'user', {})
      this.$set(this.callingUser.user, 'id', payload.user.callerId)
      this.$set(this.callingUser.user, 'first_name', payload.user.userName.split(' ')[0])
      this.$set(this.callingUser.user, 'last_name', payload.user.userName.split(' ')[1])
    }
  }
}