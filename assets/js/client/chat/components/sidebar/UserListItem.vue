<template>
  <div class='user-item' @click="toggleSelectedUser"
    style="height: 48px">
    <div class="cui-apps-messaging-tab-avatar">
      <a class="cui-avatar cui-avatar-50" v-html="userAvatar" />
    </div>
    <div class="cui-apps-messaging-tab-content">
      <small class="cui-apps-messaging-tab-time">{{lastMessageDate}}</small>
        <div class="cui-apps-messaging-tab-name">
          {{ userName }}
          <span :class="isOnline ? 'online-status' : 'offline-status'"
            class='light-style fa fa-circle smaller-40 align-middle'>
          </span>
          <span 
            v-if="user.unread.length > 0"
            class='badge badge-outline badge-pill badge-primary unread-count' 
            :data-id="user.id">
            {{ user.unread.length }}
          </span> 
        </div>  
        <div class="cui-apps-messaging-tab-text">
          {{ lastMessage  }} 
        </div>
        <button class="userActionButton btn-floating btn-sml btn-secondary btn-rounded" type="button" id="dropdownMenu3" 
          data-toggle="dropdown" aria-expanded="false"
          :style="`background-color: ${textColor}`" aria-haspopup="true">
            <i class="fas fa-ellipsis-v"></i>
        </button>
        <div class="dropdown-menu dropdown-primary">
          <a data-placement="right"
            data-toggle="tooltp" 
            @click="videoCall()"
            :data-title="`Video call with ${userName}`"
            class="btn btn-icon btn-success btn-rounded mr-2 mb-2">
            <i class="fas fa-video" aria-hidden="true"></i>
          </a>
          <a data-placement="right"
            @click="audioCall()"
            :data-title="`Audio call with ${userName}`"
            data-toggle="tooltip"
            class="btn btn-icon btn-primary btn-rounded mr-2 mb-2">
            <i class="fas fa-phone"></i>
          </a>
          <a data-toggle="tooltip"
            data-placement="right"                      
            :data-title="`Invite ${userName} to join one of your chat rooms`" 
            class="btn btn-icon btn-secondary btn-rounded mr-2 mb-2">
            <i class="fas fa-share"></i>
          </a>
        </div>
    </div>
    <Call :user="user" 
      :isAudio.sync="isAudio" 
      :isVideo.sync="isVideo"
      :callerId="userId"
      :name='audioCallName'/>
    <Call :user="user" 
      :isVideo.sync="isVideo" 
      :isAudio.sync="isAudio"
      :callerId="userId"
      :name='videoCallName'/>
    <AnswerCall :userName="user.name" 
      :isAudio="true"
      :isVideo="false" 
      :name="`answer-${user.id}-audio-call`"
      :callerId="userId"
      :avatar="user.avatar128"
      :user="user" />
    <AnswerCall :userName="user.name" 
      :isAudio="true"
      :isVideo="true" 
      :name="`answer-${user.id}-video-call`"
      :callerId="userId"
      :avatar="user.avatar128"
      :user="user" />
  </div>
</template>
<script>
import moment from 'moment'
import Call from '../video/Call.vue'
import AnswerCall from '../video/AnswerCall.vue'
import chatUser from '../../mixins/chatUser'
import settings from '../../../file_manager/mixins/settings'
export default {
  props: ['user'],
  created() {
    UI.setup()
  },
  data() {
    return {
      ringTimeout: 10000,
      isAudio: true
    }
  },
  mixins: [settings, chatUser],
  components: { Call, AnswerCall },
  methods: {
    toggleSelectedUser() {
      this.$parent.$emit('user:select', this.user)
      this.readMessages(this.user)
    },
    setLastMessage(message) {
      this.user.last_message = message
    },
    readMessages() {
      this.user.unread.splice(0, this.user.unread.length)
      //$(`span.unread-count[data-id=${user.id}]`).remove()
    },
    setUnread(unreadItems) {
      this.user.unread = unreadItems
    },
    setVideoCall(value) {
      this.$store.commit('setVideoCall', value)
    },
    videoCall() {
      this.setVideoCall(true)
      this.$modal.show(this.videoCallName, {
        isVideo: this.isVideo,
        isAudio: this.isAudio
      })
      let ringTimeout = this.timeoutCalling()
    },
    timeoutCalling() {
      return setTimeout(() => {
        this.$modal.hide(this.videoCallName)
        this.$modal.hide(this.audioCallName)
        this.$swal("Info", "No response", "warning")
      }, this.ringTimeout)
    },
    audioCall() {
      this.setVideoCall(false)

      this.$modal.show(this.audioCallName, {
        isVideo: false,
        isAudio: this.isAudio
      })
      let ringTimeout = this.timeoutCalling()
    }
  },
  computed: {
    isVideo() {
      return this.$store.state.isVideoCall
    },
    videoCallName() {
      return `video-${this.user.id}-call`
    },
    audioCallName() {
      return `audio-${this.user.id}-call`
    },
    userAvatar() {
      if (!this.user.avatar) return ''
      return this.user.avatar
    },  
    lastMessage() {
      if (this.user.last_message) {
        return this.user.last_message.content
      } else {
        return ''
      }
    },
    userName() {
      return `${this.user.first_name} ${this.user.last_name}`
    },
    onlineIds() {
      return Users.onlineUsersIds().map(u => u.id)
    },
    isOnline() {
      return this.onlineIds.filter(id => id === this.user.id).length > 0
    },
    lastMessageDate() {
      if (!this.user.last_message) return {}
      if (Object.keys(this.user.last_message).length === 0) return ''
      return moment(this.user.last_message.inserted_at)
        .tz('Europe/London').fromNow();  
    }
  }
}
</script>