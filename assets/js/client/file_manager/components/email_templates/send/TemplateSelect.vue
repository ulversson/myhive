<template>
  <div class="form-group">
    <label>
      Please select email template
      <span class='required'>*</span>
    </label>
    <v-select label="name" 
      :options="templates"
      v-model="selectedTemplate">
      <template v-slot:option="option">
      	{{ option.name }}&nbsp;
      	<span class='text-muted'>{{option.description}}</span>
      </template>
    </v-select>
  </div>
</template>
<script>
export default {
	props: ['resetForm', 'variables'],
	created() {
		this.loadTemplates()
		this.templateBody = this.$attrs.templateBody
		this.originalBody = this.$attrs.originalBody
	},
  data() {
    return {
			selectedTemplate: null,
			templates: [],
			templateBody: '',
			originalBody: ''
    };
	},
	methods: {
		loadTemplates() {
      $.ajax({
        type: "GET", 
        url: '/api/v1/email_templates/all'
      }).done((jsRes) => {
        this.templates.splice(0, this.templates.length)
        jsRes.data.forEach((temp, index) => {
          this.templates.push(temp)
        })
      })
    },
	},
  watch: {
    selectedTemplate: function(selectedTemplate, oldItem) {
      if (selectedTemplate !== null) {
        this.resetForm()
        $.ajax({
          type: "GET",
          url: `/api/v1/email_template/${selectedTemplate.id}`,
        }).done((jsRes) => {
          this.variables.splice(0, this.variables.length)
          jsRes.data.forEach((variable, index) => {
            this.variables.push(variable)
					})
					this.selectedTemplate = selectedTemplate
					this.$root.$emit('variablesLoad', {
						vars: this.variables, 
						template: jsRes.template_body,
						selectedTemplate: selectedTemplate
					})
        })
      }
    }
  }
}
</script>