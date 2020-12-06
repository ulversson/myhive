<template>
  <div class='email-modals'>
    <modal
    name="email-modal"
    width="40%"
    height="auto"
    :adaptive="true"
    :scrollable="true"
    @opened="afterOpen"
    styles="font-size: 13px"
    :reset="true">
    <div class="card-header">
      <h4>Send system email from template</h4>
    </div>
    <div class="card-body">
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
      <div class='form-group'>
          <label class='form-label'>
            Please select attachment
          </label>
            <treeselect v-model="files" 
              :multiple="true"
              :options="treeRoot"
              :flat="true"
              :load-options="loadOptions"
              :default-expand-level="0"
              ref="tree"
              :disable-branch-nodes="true"
              :sort-value-by="sortValueBy"
              placeholder="Select files">
              <label slot="option-label" slot-scope="{ node, shouldShowCount, count, labelClassName, countClassName }" 
                :class="labelClassName">
                <i class="fa fa-folder" v-if="node.isBranch" 
                  :style="`color: ${textColor}`"></i>
                <i :class="`${node.icon}`" v-if="node.icon"></i>
                &nbsp;{{ node.label }}
                <span v-if="shouldShowCount" :class="countClassName">({{ count }})</span>
              </label>
            </treeselect>
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
            :disabled="selectedTemplate === null || this.variables.length !== this.variablesValues.length"
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
  <Preview :email.sync="templateBody" />
  </div>
</template>
<script>
import { mapState } from 'vuex'
import VueTagsInput from '@johmun/vue-tags-input'
import Treeselect from '@riophae/vue-treeselect'
import TemplateVariable from './TemplateVariable.vue'
import Preview from './Preview.vue';
import folderTree from '../../mixins/folderTree'
export default {
  mixins: [folderTree],
  created() {
    this.loadTemplates()
    this.$root.$on('variable', (value) => {
      this.setVariable(value)
    })
    this.loadSignature()
  },
  watch: {
    selectedTemplate: function(selectedTemplate, oldItem) {
      if (selectedTemplate !== null) {
        this.reset()
        $.ajax({
          type: 'GET',
          url: `/api/v1/email_template/${selectedTemplate.id}`
        }).done((jsRes) => {
          this.variables.splice(0, this.variables.length)
          this.originalBody = this.templateBody = jsRes.template_body
          jsRes.data.forEach((variable, index) => {
          this.variables.push(variable)
        })
      })
      }
    }
  },
  data() {
    return {
      valueConsistsOf: 'LEAF_PRIORITY',
      sortValueBy: 'ORDER_SELECTED',
      files: [],
      templates: [],
      recipients: [],
      variables: [],
      variablesValues: [],
      emails: [],
      bccEmails: [],
      templateBody: '',
      originalBody: '',
      selectedTemplate: null,
      tag: '',
      bccTag: '',
      submit: false
    }
  },
  methods: {
    loadSignature() {
      $.ajax({
        url: `/user/signature`, 
        type: 'GET'
      }).done((signatureHtml) => {
        this.$store.commit('setSignatureHtml', signatureHtml)
      })
    },
    hideWindow() {
      this.$modal.hide('email-modal')
    },
    reset() {
      this.variablesValues.splice(0, this.variablesValues.length)
      this.submit = false
      this.emails.splice(0, this.emails.length)
      this.bccEmails.splice(0, this.bccEmails.length)
      this.templateBody = ''
    },
    parseBody() {
      this.templateBody = this.originalBody
      this.variablesValues.forEach((variable) => {
        for (const [key, value] of Object.entries(variable)) {
          if (key === 'date') {
            value = moment(value).format('DD/MM/YYYY')
          }
          this.templateBody = this.templateBody.replaceAll(`{{${key}}}`, value)
        }
      })
    },
    preview() {
      this.parseBody()
      this.$parent.$modal.show('generated-email',{
        email: this.templateBody
      })
    },
    save() {
      this.submit = true
      if (this.canSubmit) {
        $.ajax({
          url: '/api/v1/email_from_template',
          data: this.postData, 
          type: 'POST'
        }).done((res) => {
          this.submit = false
          this.hideWindow()
          this.$swal('Done', 'Email sent!', 'success')
        }).catch((err) => {
          this.submit = false
          this.$swal('Error', err.responseText, 'error')
        })
      }
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
    setVariable(value) {
      let key = Object.keys(value)[0]
      let idx = this.variablesValues.findIndex(i => {
        return Object.keys(i)[0] === key
      })
      if (idx === -1) {
        this.variablesValues.push(value)
      } else {
        this.variablesValues[idx] = value
      }
    },
    afterOpen() {
      this.reset()
    }
  },
  computed: {
    ...mapState(['signatureHtml']),
    canSubmit() {
      return this.variables.length === this.variablesValues.length && this.showEmailError === false
    },
    postData() {
      this.parseBody()
      return {
        email: {
          email_template_id: this.selectedTemplate.id,
          email_body: `${this.templateBody}${this.signatureHtml}`,
          medico_legal_case_id: window.localStorage.getItem('currentMedicoLegalCaseId'),
          recipients: this.emails.map(e => e.text).join(','),
          bcc_recipients: this.bccEmails.map(e => e.text).join(','),
          variables: this.variablesValues
        },
        files: this.files
      }
    },
    showEmailError() {
      return this.submit && this.emails.length === 0
    },
    emailErrorMessage() {
      return 'cannot be blank'
    }
  },
  components: { VueTagsInput, Treeselect, TemplateVariable, Preview }
};
</script>
