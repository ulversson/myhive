<template>
  <component :is="compName" 
		:submit.sync="submit" 
		:medicoLegalCaseId="medicoLegalCaseId">
  </component>
</template>
<script>
import TextVariable from './input_types/TextVariable.vue'
import NumberVariable from './input_types/NumberVariable.vue'
import SelectVariable from './input_types/SelectVariable.vue'
import TextareaVariable from './input_types/TextareaVariable.vue'
import DatepickerVariable from './input_types/DatepickerVariable.vue'
import MlcVariable from './input_types/MlcVariable.vue'
import TimeVariable from './input_types/TimeVariable.vue'
export default {
  props: ['submit'],
  components: {
    TextVariable, DatepickerVariable, NumberVariable, 
    SelectVariable, TextareaVariable, MlcVariable, TimeVariable
  },
  computed: {
		medicoLegalCaseId() {
			return window.localStorage.getItem('currentMedicoLegalCaseId')
		},
    compName() {
      return `${this.$attrs.variable.input_type}Variable`
    }
  }
}
</script>