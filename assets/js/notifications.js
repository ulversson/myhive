import { Socket } from "phoenix"

let notifications = []

const getSocketUrl = function() {
  let protocol = window.location.protocol == "https:" ? "wss://" : "ws://";
  if (protocol === "ws://") 
    return protocol + window.location.hostname + ":4000/socket"
  else if (protocol === "wss://" ) {
    return protocol + window.location.hostname + "/socket"
  }
}
const setupChannelForUser = (userId) => {
  const token = 'randomtoken'
  const socket = new Socket(getSocketUrl(), { 
      params: { token: token } 
  })

  socket.connect()
  let channel = socket
    .channel(`notifications:${userId}`, {}) 

  channel.join()
   .receive("ok",     
      resp => { console.log("Joined successfully", resp) })
   .receive("error", 
      resp => { console.log("Unable to join", resp) })


  channel.on('new_notification', payload => {
    debugger  
  })
}

export default {
  setupChannelForUser
}