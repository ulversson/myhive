
import {Socket, Presence} from "phoenix"

let presences = {}

const renderOnlineUsers = function(presences) {
  let onlineUsers = Presence.list(presences, (_id, {metas: [user, ...rest]}) => {
    return {
      id: parseInt(_id),
      online_at: parseInt(user.online_at)
    }
  })
  console.log(onlineUsers)
  return onlineUsers
}

const setupPresence = (userId) => {
  let socket = new Socket("/socket", {
    params: {user_id: userId}
  })

  let channel = socket.channel("room:lobby", {})
  let presence = new Presence(channel)
  socket.connect()
  channel.join()

  presence.onSync(() => renderOnlineUsers(presences))

  channel.on("presence_state", state => {
    presences = Presence.syncState(presences, state)
    renderOnlineUsers(presences)
  })
  
  channel.on("presence_diff", diff => {
    presences = Presence.syncDiff(presences, diff)
    renderOnlineUsers(presences)
  })

}
export default {
  setupPresence, 
  renderOnlineUsers,
  presences
}