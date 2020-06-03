const reportError = where => error => {
  console.error(where, error)
}

function log() {
  console.log(...arguments)
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
      localVideo: this.$refs.localStream
    }
  },
  methods: {
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
        if (this.userId == payload.user.userId) {
          this.$modal.show(payload.user.name)
        }
      })
      this.videoChannel.on('hangup', payload => {
        let id = payload.name
          .replace("answer-","")
          .replace("-call","")
        this.$modal.hide(`video-${id}-call`)
        this.$modal.hide(`audio-${id}-call`)
        this.$modal.hide(payload.name)
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
            let candidate = new RTCIceCandidate(message.content);
            this.peerConnection.addIceCandidate(candidate).catch(reportError);
            log('candidate: ', message.content);
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
        this.pushPeerMessage('ice-candidate', event.candidate);
      }
    },
    createPeerConnection(stream) {
      let pc = new RTCPeerConnection({
        iceServers: [
          // Information about ICE servers - Use your own!
          {
            urls: 'stun:stun.services.mozilla.com',
          },
        ],
      });
      pc.ontrack = this.handleOnTrack
      pc.onicecandidate = this.handleOnIceCandidate
      stream.getTracks().forEach(track => pc.addTrack(track))
      return pc
    },
    receiveRemote(offer) {
      let remoteDescription = new RTCSessionDescription(offer)
      this.peerConnection.setRemoteDescription(remoteDescription)
    },
    
    handleOnTrack(event) {
      this.remoteStream.addTrack(event.track);
    },
    async answerCall(offer) {
      this.connect().then(() => {
        this.$modal.show(`conversation-${this.$parent.senderId}-call`)
        this.showRemoteDesc(offer)
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
      this.setVideoStream(this.$refs.remoteStream, this.remoteStream)
      this.peerConnection.close()
      this.peerConnection = null
      this.pushPeerMessage('disconnect', {})
    },
    callUserWithModal() {
      this.videoChannel.push('incoming-call', {
        user: {
          userId: this.user.id,
          userName: this.userName,
          name: `answer-${this.userId}-call`,
          avatar: this.avatar,
          callerId: this.callerId
        }
      })
    },
    hangup(userId) {
      this.videoChannel.push('hangup', {
        name: `answer-${userId}-call`
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
    async connect() {
     await navigator.mediaDevices.getUserMedia({
        audio: true,
        video: true,
      }).then((stream) => {
        this.localStream = stream
        this.setVideoStream(this.$refs.localStream, stream)
        //this.localStream = new MediaStream()
        this.$store.commit('setLocalStream', this.localStream)
        this.$store.commit('setPeerConn', this.createPeerConnection(this.localStream))
        this.setVideoStream(this.$refs.remoteStream, new MediaStream())
      }).catch((err) =>{
        this.$swal("No device", "No video or audio device found to make this call", "error")
        this.$modal.hide('conversation')
      })
    },
  }
}