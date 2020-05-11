export default {
  methods: {
    filterExcludedChars(input) {
      return input.replace(/([^\x20-~]+)|([\\/:?"<>|]+)/g, "")
    },
    doesNotHaveDot(input) {
      return input.indexOf(".") === -1
    }
  }
}