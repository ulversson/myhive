<template>
  <toggle-button 
    @click.native.prevent="onChangeEventHandler($attrs.data, $event)"
    :font-size="15"
    :labels="{checked: 'YES',
     unchecked: 'NO'}"
     ref="toggle"
    :width="55"
    :sync="true"
    :value='Boolean($attrs.data.note_issued)'
    :color="{checked: '#02BC77', 
      unchecked: '#d9534f', 
      disabled: '#CCCCCC'
    }"
    :height='20'/>
</template>
<script>
import timeSheetUpdate from '../mixins/timeSheetUpdate'
export default {
  mixins: [timeSheetUpdate],
  methods: {
   onChangeEventHandler(row, event) {
      let isChecked = !this.$refs.toggle.toggled

      row.note_issued = isChecked
      this.saveUpdatedRow(row, 'note_issued') 
      this.$refs.toggle.toggle()
    }
  }
}
</script>