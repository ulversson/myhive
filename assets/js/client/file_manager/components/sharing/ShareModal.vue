<template>
  <modal 
    :name="modalName"
    :min-width="200" :min-height="550"
    :adaptive="true" :scrollable="true"
    styles="font-size: 13px" :reset="true"
    @opened="afterOpened" width="50%" height="60%">
    <form class='form-horizontal form-share'>
    <div class='card'>
      <div class='card-header'>
        <span class='cui-utils-title'>Share files</span>
      </div>
      <div class='card-body'>
        <div class='form-group'>
        <label class='form-label'>
          Please select files to share
        </label>
          <treeselect v-model="files" 
            :multiple="true"
            :options="treeRoot"
            :class="showFileFieldError ? 'has-danger':''"
            :flat="true"
            :load-options="loadOptions"
            :default-expand-level="0"
            ref="tree"
            :disable-branch-nodes="true"
            :sort-value-by="sortValueBy"
            placeholder="Add files">
            <label slot="option-label" slot-scope="{ node, shouldShowCount, count, labelClassName, countClassName }" 
              :class="labelClassName">
              <i class="fa fa-folder" v-if="node.isBranch" 
                :style="`color: ${textColor}`"></i>
              <i :class="`${node.icon}`" v-if="node.icon"></i>
              &nbsp;{{ node.label }}
              <span v-if="shouldShowCount" :class="countClassName">({{ count }})</span>
            </label>
          </treeselect>
          <span class='help-block' v-if="showFileFieldError">
            Please enter at least one file
          </span>
        </div>
        <label class='form-label'>
          Please enter first and last name
        </label>
        <div class='row col-12' style='padding: 0'>
          <div class='form-group col-6' style='margin-left: 0' >
            <input placeholder="First name" class='form-control mr-1' 
              v-model="firstName"
              :class="showFirstNameError ? 'has-danger':''">
            <span class='help-block' v-if="showFirstNameError">
              This field is mandatory (minimum of 3 characters)
            </span>
          </div>
          <div class='form-group col-6' style='margin-left: 0' >
            <input placeholder="Last name" class='form-control  mr-1' 
              :class="showLastNameError ? 'has-danger':''"
              v-model="lastName">
             <span class='help-block' v-if="showLastNameError">
              This field is mandatory (minimum of 3 characters)
            </span>
          </div>
        </div>
        <label class='form-label'>
          Please enter email address/es
        </label>
         <vue-tags-input
            v-model="tag"
            style="width: 100%"
            :tags="emails"
            :class="showEmailError ? 'has-danger' : ''"
            :allow-edit-tags="true"
            :avoid-adding-duplicates="true"
            :placeholder="'Add email address'"
            :add-from-paste="true"
            @tags-changed="newTags => emails = newTags" />
          <span class='help-block' v-if="showEmailError">
            {{ emailErrorMessage }}
          </span>
        <small class='text-muted' style='font-style: italic'>Remember to press TAB after each email address</small>
        <div class='form-group'>
          <label style="margin-top: 10px">
            Optional note to recipient
          </label>
          <textarea v-model="sharingNote"
            class='form-control' rows="2" style="max-height: 90px;">
          </textarea>
        </div>
        <div class='buttons' style='float: right'>
          <a class='btn btn-sm btn-primary pull-right mt-2'
            @click="shareFiles()"
            :style="submitDisabled ?'cursor: not-allowed': ''"
            :disabled="submitDisabled">
            <i class="fas fa-share-alt"></i>&nbsp;Share
          </a>
          <a class='btn btn-sm btn-secondary pull-right mt-2'
            @click="hideModal()">
            <i class="far fa-times-circle"></i>&nbsp;Close
          </a>
        </div>
      </div>
    </div>
    </form>
  </modal>
</template>
<script>
import settings from '../../mixins/settings'
import Treeselect from '@riophae/vue-treeselect'
import { LOAD_CHILDREN_OPTIONS } from '@riophae/vue-treeselect'
import VueTagsInput from '@johmun/vue-tags-input'
import autosize from 'autosize'
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
export default {
  components: { Treeselect, VueTagsInput },
  mixins: [settings],
  methods: {
    emailsValid() {
      return this.emails.map((email) => {
        if (email.text) email = email.text
        return {
          email: email, 
          valid: /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)
        }
      })
    },
    shareFiles() {
      this.submit = true
      $.post(`/api/v1/shareable`, this.postFormData).
        done((r) => {
          this.$modal.hide('share-modal')
          this.$swal('Done!','Files has been shared', 'success')
        }).
        catch(e => {
          this.$swal('Error', 'Unable to share files. Try again later.', 'error')
        })
    },
    addNodesFromResponse(jsonResponse, parentNode) {
      jsonResponse.children.forEach(element => {
        parentNode.children.push({
          label: element.name,
          id: element.id,
          isBranch: true,
          children: null
        })
      })
      jsonResponse.assets.forEach(asset => {
        parentNode.children.push({
          isBranch: false,
          label: asset.name,
          id: asset.id,
          icon: asset.icon
        })
      })
    },
    hideModal() {
      this.$modal.hide('share-modal')
    },
    reset() {
      this.files = []
      this.emails = []
      this.firstName = ''
      this.lastName = ''
      this.sharingNote = ''
      this.submit = false
    },
    afterOpened() {
      this.reset()
      this.updateTree()
      autosize(document.querySelectorAll('textarea'))
    },
    folderRequestUrl(folderId) {
      return `/api/v1/folders/show_tree/${folderId}?order=${this.$store.state.order}&column=${this.$store.state.column}`
    },
    updateTree() {
      if (this.$refs.tree)
        this.$refs.tree.initialize(this.treeRoot) 
    },
    loadOptions({ action, parentNode, callback }) {
      this.updateTree()
      if (action === LOAD_CHILDREN_OPTIONS) {
        if (!parentNode.children) parentNode.children = []
        $.getJSON(this.folderRequestUrl(parentNode.id))
          .done((jsonResponse) => {
            this.addNodesFromResponse(jsonResponse, parentNode)
            callback()  
            this.updateTree()    
        })
      }
    }
  },
  data() {
    return {
      valueConsistsOf: 'LEAF_PRIORITY',
      sortValueBy: 'ORDER_SELECTED',
      emails: [],
      files: [],
      submit: false,
      firstName: '',
      lastName: '',
      sharingNote: '',
      tag: ''
    }
  },
  computed: {
     postFormData() {
      return {
        directory: {
          files: this.files,
          medico_legal_case_id: this.$store.state.currentMedicoLegalCaseId,
          saas_account_id: this.$store.state.currentAccount,
          first_name: this.firstName,
          last_name: this.lastName,
          emails: this.emails.map((e) => e.text).join(','),
          note: this.sharingNote
        }
      }
    },
    invalidEmails() {
      return this.emailsValid().filter((mp) => {
        return mp.valid == false
      })
    },
    submitDisabled() {
      return this.showFileFieldError || this.showEmailError || this.showSharingNoteError
    },
    modalName() {
      return 'share-modal'
    },
    showFileFieldError() {
      return this.submit && this.files.length === 0 
    },
    showEmailError() {
      return this.submit && (this.emails.length === 0 || this.invalidEmails.length > 0)
    },
    showLastNameError() {
      return this.submit && (this.lastName === '' || this.lastName.length <= 2)
    },
    showFirstNameError() {
      return this.submit && (this.firstName === '' || this.firstName.length <= 2)
    },
    showSharingNoteError() {
      if (this.submit && this.sharingNote.length < 3) {
        return true
      } else {
        return false
      }
    },
    emailErrorMessage() {
      if (this.emails.length === 0 && this.submit) {
        return "Please enter at least one valid email address"
      } else if (this.submit && this.invalidEmails.length > 0) {
        let value = 'Value', is = 'is', address = 'address'
        if (this.invalidEmails.length > 1) {
          value = 'Values: '
          is = 'are'
          address = 'addresses'
        }
        return `${value} ${this.invalidEmails.map((e) => e.email).join(', ')} ${is} not valid email ${address}`
      }
    },
    treeRoot() {
      let children = this.$parent.managerComponent.rootChildren
      return children.map((child, index) => {
        return {
          id: child.id,
          label: child.name,
          isBranch: true,
          children: null
        }
      })
    }
  },
  updated(){
    this.updateTree()
  }
} 
</script>