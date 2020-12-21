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
	props: ['resetForm', 'variables', 'templateBody', 'originalBody'],
	created() {
		this.loadTemplates()
	},
  data() {
    return {
			selectedTemplate: null,
			templates: []
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
    selectedTemplate(selectedTemplate, oldItem) {
      if (selectedTemplate !== null) {
        this.resetForm()
        $.ajax({
          type: "GET",
          url: `/api/v1/email_template/${selectedTemplate.id}`,
        }).done((jsRes) => {
					debugger
          this.variables.splice(0, this.variables.length)
          this.originalBody = this.templateBody = jsRes.template_body
          jsRes.data.forEach((variable, index) => {
            this.variables.push(variable)
          });
        });
      }
    },
  },
};
</script>