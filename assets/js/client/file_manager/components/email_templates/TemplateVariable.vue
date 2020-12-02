<template>
  <component :is="compName" :submit.sync="submit">
  </component>
</template>
<script>
import TextVariable from './input_types/TextVariable.vue'
import NumberVariable from './input_types/NumberVariable.vue'
import SelectVariable from './input_types/SelectVariable.vue'
import TextareaVariable from './input_types/TextareaVariable.vue'
import DatepickerVariable from './input_types/DatepickerVariable.vue'
export default {
  props: ['submit'],
  components: {
    TextVariable, DatepickerVariable, NumberVariable, 
    SelectVariable, TextareaVariable
  },
  computed: {
    compName() {
      return `${this.$attrs.variable.input_type}Variable`
    }
  }
}
</script>