<template>
  <div class='email-modals'>
    <modal
    name="email-modal"
    width="40%"
    height="auto"
    :adaptive="true"
    :scrollable="true"
    @opened="resetForm"
    styles="font-size: 13px"
    :reset="true">
    <div class="card-header">
      <h4>Send system email from template</h4>
    </div>
		<div class="card-body">
			<TemplateSelect ref="templates" :resetForm="resetForm" 
				:variables.sync="variables" 
				:templateBody.sync="templateBody"
				:originalBody="originalBody"/>
			<OutgoingEmailStorage :textColor="$parent.textColor" 
				ref="storage"/>
			<Recipients ref="rcpt" :submit.sync="submit"/>
      <Attachment :textColor="$parent.textColor" ref="attachment" />
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
            :disabled="this.variables.length !== this.variablesValues.length || this.selectedTemplate === null"
            @click="preview()">
            <i class="fas fa-eye"></i>&nbsp;Preview
          </button>
          <button class="btn btn-sm btn-primary pull-right mt-2 mr-2"
            style="float: right; margin-bottom: 20px !important;"
						:disabled="this.selectedTemplate === null"
            @click="save()">
            <i class="fas fa-paper-plane"></i>&nbsp;SEND
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
import TemplateSelect from './send/TemplateSelect.vue'
import TemplateVariable from './TemplateVariable.vue'
import Preview from './Preview.vue';
import Recipients from './send/Recipients.vue'
import Attachment from './send/Attachment.vue'
import OutgoingEmailStorage from './send/OutgoingEmailStorage.vue'
export default {
  created() {
    this.$root.$on('variable', (value) => {
      this.setVariable(value)
    })
		this.loadSignature()
		this.onVariablesLoad()
  },
  data() {
    return {
      recipients: [],
			variables: [],
			selectedTemplate: null,
      variablesValues: [],
      templateBody: '',
      originalBody: '',
      submit: false
    }
  },
  methods: {
		onVariablesLoad() {
			this.$root.$on('variablesLoad', (data) => {
				this.variables = data.vars
				this.originalBody = this.templateBody = data.template 
				this.selectedTemplate = data.selectedTemplate
			})
		},
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
    resetForm() {
      this.variablesValues.splice(0, this.variablesValues.length)
      this.submit = false
      this.$refs.rcpt.emails.splice(0, this.$refs.rcpt.emails.length)
      this.$refs.rcpt.bccEmails.splice(0, this.$refs.rcpt.bccEmails.length)
      this.templateBody = ''
    },
    parseBody() {
      this.templateBody = this.originalBody
      this.variablesValues.forEach((variable) => {
        for (const [key, value] of Object.entries(variable)) {
          if (key === 'date') {
            value = moment(value).format('DD/MM/YYYY')
					}
					if (key == 'time') {
						value = moment(value).format('HH:mm')
					}
          this.templateBody = this.templateBody
            .replaceAll(`{{${key}}}`, value)
            .replaceAll(`<p>&nbsp;</p>`,'')
            .replaceAll('<p><br/></p>','')
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
    }
  },
  computed: {
		...mapState(['signatureHtml']),
    canSubmit() {
      return this.variables.length === this.variablesValues.length && this.$refs.rcpt.showEmailError === false
    },
    postData() {
      this.parseBody()
      return {
        email: {
          email_template_id: this.selectedTemplate.id,
          email_body: `${this.templateBody}${this.signatureHtml.replaceAll(`<p>&nbsp;</p>`,'')
            .replaceAll('<p><br/></p>','')
					}`,
					folder_id: this.$refs.storage.selectedValue,
          medico_legal_case_id: window.localStorage.getItem('currentMedicoLegalCaseId'),
          recipients: this.$refs.rcpt.emails.map(e => e.text).join(','),
          bcc_recipients: this.$refs.rcpt.bccEmails.map(e => e.text).join(','),
          variables: this.variablesValues
        },
        files: this.$refs.attachment.files
      }
    }
  },
  components: { 
		TemplateSelect, TemplateVariable, Preview, 
		Recipients, Attachment, OutgoingEmailStorage 
	}
}
</script>
