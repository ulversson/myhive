export default {
  props: ['submit'],
  data() {
    return {
      itemValue: null
    }
  },
  computed: {
    hasError() {
      return this.submit && this.itemValue === null
    },
    inputName() {
      return this.variable.code.replace('{{','').replace('}}','')
    },
    variable() {
      return this.$parent.$attrs.variable
    },
    allParentVariables() {
      return this.$parent.$parent.$parent.variables
    },
    isFullWidth() {
      return this.allParentVariables.length === 1 || this.isOdd
    },
    isOdd() {
      return this.allParentVariables.length % 2 !== 0
    }
  }
}