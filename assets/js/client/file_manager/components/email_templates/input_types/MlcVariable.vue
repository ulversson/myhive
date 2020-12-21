<template>
  <div class='form-group'
    :class="[
      isFullWidth ? 'col-12' : 'col-6',
      hasError ? 'has-danger' : ''
    ]">
    <label>
      {{variable.name}}
      <span class='required'>*</span>
    </label>
    <input type="text" :name="inputName" 
      :class="hasError ? 'has-error' : ''"
      class='form-control'
      v-model="itemValue"/>
    <span class='help-block' v-if="hasError">
      cannot be blank
    </span>
  </div>
</template>
<script>
import variable from '../mixins/variable'
export default {
  props: ['submit', 'medicoLegalCaseId'],
	mixins: [variable],
	created() {
		this.loadMedicoLegalCaseData()
	},
	computed: {
		codeName() {
			return this.variable.code.replaceAll('{{','').replaceAll('}}','')
		},
		accessKey() {
			let splitted = this.codeName.split('_')
			if (splitted.length === 3)  {
				return this.codeName.split("_").splice(0,2).join("_")
			} else {
				return splitted[0]
			}
		},
		accessValue() {
			let splitted = this.codeName.split('_')
			if (splitted.length === 3)  {
				return splitted[2]
			} else {
				return splitted[1]
			}
		},
		defaultValue() {
			let value = this.caseData[this.accessKey]
			if (value === null) return value
			return value[this.accessValue]
		}
	},
	methods: {
		loadMedicoLegalCaseData() {
			$.getJSON(`/api/v1/medico_legal_cases/${this.medicoLegalCaseId}`, (res) => {
				this.caseData = res.data
				this.itemValue = this.defaultValue
			})
		}
	}
}
</script>