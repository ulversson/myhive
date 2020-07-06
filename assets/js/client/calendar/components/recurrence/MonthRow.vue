<template>
   <div class="d-flex btn-group col-12 justify-content-left" 
    data-toggle="buttons">
    <label class="btn btn-primary styled" 
      style='max-width: 40px !importnt; width: 40px !important;'
      :class="!monthActive ? 'disabled': ''"
      v-for="month in collection" :key="month">
      <input type="checkbox" name='month' 
        :disabled="!monthActive"
        @change="toggleMonth(month)" >
        {{month}}
    </label>
  </div>
</template>
<script>
export default {
  props: ['collection', 'yearlyOptions'],
  methods: {
    toggleMonth(month) {
      this.$root.$emit('month', month)
    }
  },
  computed: {
    monthActive() {
      return this.yearlyOptions === 'multipleMonths'
    }
  }
}
</script>