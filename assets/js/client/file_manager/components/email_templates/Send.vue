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
      <div class='recipients col-12 row p-0 m-0 mb-3' >
        <div class='form-group col-12 p-0 m-0 mb-3'>
          <label>
            Email address
          <span class='required'>*</span>
        </label>
          <vue-tags-input
            v-model="tag"
            :tags="emails"
            :style="'padding: 0px; margin: 0px'"
            :class="showEmailError ? 'has-danger' : ''"
            :allow-edit-tags="true"
            :avoid-adding-duplicates="true"
            :placeholder="'Add email address'"
            :add-from-paste="false"
            @tags-changed="newEmails => emails = newEmails" />
          <span class='help-block' v-if="showEmailError">
            {{ emailErrorMessage }}
          </span>
        </div>
      <div class='form-group col-12 p-0 m-0'>
        <label>
          BCC Email address
        </label>
        <vue-tags-input
          v-model="bccTag"
          :tags="bccEmails"
          :allow-edit-tags="true"
          :style="'padding-left: 0px'"
          :avoid-adding-duplicates="true"
          :placeholder="'Add BCC email address'"
          :add-from-paste="false"
          @tags-changed="newEmails => bccEmails = newEmails" />
      </div>
      </div>  
      <div class='variables row'>
        <TemplateVariable v-for="variable in variables" 
          :variable="variable"
          :submit.sync="submit"
          :ref="`variables[${variable.code
            .replace('}}','')
            .replace('{{','')}]`"
          :key="variable.id" />
      </div>
      <div class='card-footer pr-0'>
        <div class='buttons'>
          <a class="btn btn-sm btn-secondary pull-right mt-2 mr-2"
            style="float: right; margin-right: 0px !important;margin-bottom: 20px !important;"
            @click="hideWindow()">
            <i class="far fa-times-circle"></i>&nbsp;Close
          </a>
          <button class="btn btn-sm btn-warning pull-right mt-2 mr-2"
            style="float: right; margin-bottom: 20px !important;"
            :disabled="selectedTemplate === null"
            @click="preview()">
            <i class="fas fa-eye"></i>&nbsp;Preview
          </button>
          <button class="btn btn-sm btn-primary pull-right mt-2 mr-2"
            style="float: right; margin-bottom: 20px !important;"
            :disabled="selectedTemplate === null"
            @click="save()">
            <i class="fas fa-save"></i>&nbsp;Save
          </button>
        </div>
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
      bccTag: '',
      submit: false
    }
  },
  methods: {
    hideWindow() {
      this.$modal.hide('email-modal')
    },
    preview() {

    },
    save() {
      this.submit = true

    },
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
  computed: {
    showEmailError() {
      return this.submit && this.emails.length === 0
    },
    emailErrorMessage() {
      return 'cannot be blank'
    }
  },
  components: { VueTagsInput, TemplateVariable }
};
</script>
