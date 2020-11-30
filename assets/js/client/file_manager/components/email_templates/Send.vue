<template>
  <modal
    name="email-modal"
    width="40%"
    height="auto"
    :adaptive="true"
    :scrollable="true"
    styles="font-size: 13px"
    :reset="true"
    @opened="afterOpen">
    <div class="card-header">
      <h4>Send system email from template</h4>
    </div>
    <div class="card-body">
      <div class="form-group">
        <label>
          Please select email template
          <span class='required'>*</span>
        </label>
        <v-select label="name" :options="templates"
          v-model="selectedTemplate">
          <template v-slot:option="option">
          {{ option.name }}&nbsp;
          <span class='text-muted'>{{option.description}}</span>
          </template>
        </v-select>
      </div>
      <div class='form-group row'>
        <vue-tags-input
          v-model="tag"
          :tags="emails"
          :class="'col-6'"
          :allow-edit-tags="true"
          :avoid-adding-duplicates="true"
          :placeholder="'Add email address'"
          :add-from-paste="false"
          @tags-changed="newEmails => emails = newEmails" />
        <vue-tags-input
          v-model="bccTag"
          :tags="bccEmails"
          :class="'col-6'"
          :allow-edit-tags="true"
          :avoid-adding-duplicates="true"
          :placeholder="'Add BCC email address'"
          :add-from-paste="false"
          @tags-changed="newEmails => bccEmails = newEmails" />
      </div>
      <div class='variables row'>
        <TemplateVariable v-for="variable in variables" 
          :variable="variable"
          :key="variable.id" />
      </div>
    </div>
  </modal>
</template>
<script>
import VueTagsInput from '@johmun/vue-tags-input'
import TemplateVariable from './TemplateVariable.vue'
export default {
  created() {
    this.loadTemplates()
  },
  watch: {
    selectedTemplate: function(selectedTemplate, oldItem) {
      if (selectedTemplate !== null) {
        $.ajax({
            type: 'GET',
            url: `/api/v1/email_template/${selectedTemplate.id}`
        }).done((jsRes) => {
          this.variables.splice(0, this.variables.length)
          jsRes.data.forEach((variable, index) => {
          this.variables.push(variable)
        })
      })
      }
    }
  },
  data() {
    return {
      templates: [],
      recipients: [],
      variables: [],
      emails: [],
      bccEmails: [],
      selectedTemplate: null,
      tag: '',
      bccTag: ''
    }
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
    afterOpen() {

    }
  },
  components: { VueTagsInput, TemplateVariable }
};
</script>
