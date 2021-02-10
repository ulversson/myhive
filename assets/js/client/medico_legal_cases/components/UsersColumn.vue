<template>
  <div class='users-mlc' style='font-size: 16px'>
    <a class='badge badge-pill text-white' 
      :class="badgeClass(user)"
      v-for='user in allCaseUsers' 
      :key='user'>
      &nbsp;{{user}}&nbsp;
    </a>
  </div>
</template>
<script>
export default {
  methods: {
    badgeClass(user) {
      if (user === this.$attrs.data.owner) {
        return 'badge-myhive'
      } else {
        return 'badge-secondary'
      }
    },
  },
  computed: {
    allCaseUsers() {
      let merged = [this.$attrs.data.owner].concat(this.$attrs.data.users)
      return [...new Set(merged)]
    }
  },
  props: ['row']
}
</script>
<style scoped>
.badge-myhive {
  background-color: #364c63	!important;
  color: white !important;
}
</style>