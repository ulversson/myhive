import variable from './variable'
import { Datetime } from "vue-datetime"
export default {
    components: { Datetime },
    mixins: [variable],
    watch: {
        selectedDate: function(newVal, oldVal) {
            var variable = {}
            variable[this.inputName] = newVal
            this.$root.$emit('variable', variable)
        }
    },
    computed: {
        hasDateError() {
            return !(this.selectedDate) && this.submit
        },
        computedClass() {
            if (this.hasDateError) {
                return this.withErrorClass
            } else {
                return this.withoutErrorClass
            }
        },
        withErrorClass() {
            if (this.isFullWidth) {
                return 'form-group has-danger col-12'
            } else {
                return 'form-group has-danger col-6'
            }
        },
        withoutErrorClass() {
            if (this.isFullWidth) {
                return 'col-12'
            } else {
                return 'col-6'
            }
        }
    },
    data() {
        return {
            selectedDate: null
        }
    }
}