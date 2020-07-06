<template>
  <div class="d-flex btn-group col-12 justify-content-left" 
    data-toggle="buttons">
    <label class="btn btn-primary styled" 
      :class="monthDayMode !== 'byDay' ? 'disabled' : ''"
      style='max-width: 40px !importnt; width: 40px !important;'
      v-for="day in collection" :key="day">
      <input type="checkbox" name='week' 
        :disabled="monthDayMode !== 'byDay'"
        @change="toggleDay(day)" >
        {{day}}
    </label>
  </div>
</template>
<script>
export default {
  props: ['monthDayMode', 'collection'],
  methods: {
    toggleDay(day) {
      this.$parent.$emit('toggleDay', day)
    }
  }
}
</script>
<style>
label.styled {
  width: 40px !important;
}
</style>