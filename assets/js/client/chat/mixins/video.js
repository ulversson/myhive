const reportError = where => error => {
  console.error(where, error)
}

function log() {
  console.log(...arguments)
}

const ringAudio = () => {
  let audio  = new Audio("/audio/call.mp3")
  audio.loop = true
  return audio
}
export default {
  computed:{
    peerConnection() {
      return this.$store.state.peerConnection
    },
    videoChannel() {
      return this.$store.state.videoChannel
    }
  },
  data() {
    return {
      remoteStream: new MediaStream(),
      remoteVideo: this.$refs.remoteStream,
      localVideo: this.$refs.localStream,
      ringTimeout: 20000
    }
  },
  methods: {
    clearTimeout() {
      let timeout = parseInt(window.localStorage.getItem('timeout'))
      if (timeout) clearTimeout(timeout)
      window.localStorage.removeItem('timeout')
    },
    ring() {
      return ringAudio().play()
    },
    stopRinging() {
      ringAudio().pause()
      ringAudio().currentTime = 0
    },
    setupVideoChannel(socket) {
      this.$store.commit('setVideoChannel', socket.channel('video:peer2peer', {}))

      this.videoChannel
        .join()
        .receive('ok', resp => {
          console.log('Joined successfully', resp);
        })
        .receive('error', resp => {
          console.error('Unable to join', resp);
        })
      this.videoChannel.on('incoming-call', payload => {
        let timeout = setTimeout(() => {
          this.$modal.hide(payload.user.name)
        }, this.ringTimeout)
        if (this.userId == payload.user.userId) {
          if (typeof this.callCallback === 'function') {
            this.callCallback(payload)
          }
          this.$nextTick(() => {
            this.$modal.show(payload.user.name, {
              isAudio: payload.user.isAudio,
              isVideo: payload.user.isVideo,
              timeoutToClear: timeout
            })
          });
          //this.ring()
        }
      })
      this.videoChannel.on('hangup', payload => {
        let id = payload.name
          .replace("answer-","")
          .replace("-call","")
        this.$modal.hide(`video-${id}-call`)
        this.$modal.hide(`audio-${id}-call`)
        this.$modal.hide(payload.name)
        this.stopRinging()
      })
      this.videoChannel.on('peer-message', payload => {
        const message = JSON.parse(payload.body)
        switch (message.type) {
          case 'video-offer':
            log('offered: ', message.content)
            this.answerCall(message.content)
            break
          case 'video-answer':
            log('answered: ', message.content)
            this.receiveRemote(message.content)
            break
          case 'ice-candidate':
            
            this.clearTimeout()
            let candidate = new RTCIceCandidate(message.content)
            this.peerConnection.addIceCandidate(candidate).catch(reportError)
            log('candidate: ', message.content)
            break;
          case 'disconnect':
            this.disconnect()
            break;
          default:
            reportError('unhandled message type')(message.type);
        }
      })
    },
    setRemoteStream() {
      this.setVideoStream(this.$refs.remoteStream, this.remoteStream)
    },
    setVideoStream(videoElement, stream) {
      videoElement.srcObject = stream
    },
    handleIceCandidate(event) {
      log(event)
      if (!!event.candidate) {
        this.pushPeerMessage('ice-candidate', event.candidate)
      }
    },
    createPeerConnection(stream) {
      let pc = new RTCPeerConnection({
        iceServers: [
        ],
      })
      pc.ontrack = this.handleOnTrack
      pc.onicecandidate = this.handleIceCandidate
      stream.getTracks().forEach(track => pc.addTrack(track))
      return pc
    },
    receiveRemote(offer) {
      let remoteDescription = new RTCSessionDescription(offer)
      this.peerConnection.setRemoteDescription(remoteDescription)
    },
    
    handleOnTrack(event) {
      this.remoteStream.addTrack(event.track)
    },
    async answerCall(offer) {
      this.$modal.show(`conversation-${this.$parent.senderId}-call`, {
        offer: offer,
        isVideo: this.isVideo,
        isAudio: this.isAudio,
        timeoutToClear: this.timeoutToClear
      })      
    },
    async showRemoteDesc(offer) {
      let remoteDescription = new RTCSessionDescription(offer)
      this.peerConnection.setRemoteDescription(remoteDescription)
      let answer = await this.peerConnection.createAnswer()
      this.peerConnection
        .setLocalDescription(answer)
        .then(() =>
          this.pushPeerMessage('video-answer', this.peerConnection.localDescription)
        )
    },
    disconnect() {
      this.unsetVideoStream(this.$refs.localStream)
      this.remoteStream = new MediaStream()
      this.unsetVideoStream(this.$refs.remoteStream)
      if (this.peerConnection) this.peerConnection.close()
      this.$store.commit('setPeerConn', null)
      this.$modal.hide(this.name)
      $('[data-dismiss="modal"]').click()
      this._data.remoteStream.getTracks().forEach(function (track) {
        return track.stop()
      })
      window.location.reload(true)
    },
    endConversation() {
      window.location.reload(true)
      this.pushPeerMessage('disconnect', {})
    },
    getAnsweredCallName(userId) {
      if (this.isVideo)
        return `answer-${userId}-video-call`
      else
        return `answer-${userId}-audio-call`
    },
    callUserWithModal(timeout) {     
      this.timeoutToClear = timeout 
      this.videoChannel.push('incoming-call', {
        user: {
          userId: this.user.id,
          userName: this.userName,
          isAudio: this.isAudio,
          isVideo: this.isVideo,
          name: this.getAnsweredCallName(this.userId),
          avatar: this.avatar,
          avatar128: this.avatar128,
          callerId: this.callerId
        }
      })
    },
    hangup(userId) {
      this.videoChannel.push('hangup', {
        name: this.getAnsweredCallName(userId)
      })
    },
    async call() {
      let offer = await this.peerConnection.createOffer()
      this.peerConnection.setLocalDescription(offer)
      this.videoChannel.push('peer-message', {
        body: JSON.stringify({
          'type': 'video-offer',
          'content': offer,
          caller_id: this.callerId
        }),
      })
      this.pushPeerMessage('video-offer', offer)
    },
    pushPeerMessage(type, content) {
      this.videoChannel.push('peer-message', {
        body: JSON.stringify({
          type,
          content,
          caller_id: this.callerId
        })
      })
    },
    unsetVideoStream(videoElement) {
      if (videoElement === undefined) return
      if (videoElement.srcObject) {
        videoElement.srcObject.getTracks().forEach(track => track.stop())
      }
      videoElement.removeAttribute('src')
      videoElement.removeAttribute('srcObject')
    },
    async connect(isVideo) {
     await navigator.mediaDevices.getUserMedia({
        audio: this.isAudio,
        video: (isVideo ? isVideo : this.isVideo),
      }).then((stream) => {
        this.localStream = stream
        this.localAudioStream = stream
        this.setVideoStream(this.$refs.localStream, stream)
        this.$store.commit('setLocalStream', this.localStream)
        this.$store.commit('setPeerConn', this.createPeerConnection(this.localStream))
      }).catch((err) =>{
        this.$swal("No device", "No video or audio device found to make this call", "error")
        this.$modal.hide('conversation')
      })
    },
  }
}