export default {
  computed: {
    isInArchive() {
      let archiveMatch = window.location.pathname.match("/archive")
      return archiveMatch && archiveMatch.length > 0
    },
    isInShared() {
      let sharedMatch = window.location.pathname.match("/shared")
      return sharedMatch && sharedMatch.length > 0
    }
  }
}