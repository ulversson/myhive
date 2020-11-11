<template>
  <form class='form-horizontal form-share'>
    <div class='card'>
      <div class='card-header'>
        <span class='cui-utils-title'>{{header}}</span>
      </div>
      <div class='card-body'>
        <label class='form-label'>
          Please enter shared folder name
          <span class='required'>*</span>
        </label>
        <div class='row col-12' style='padding: 0'>
          <div class='form-group col-12' style='margin-left: 0' >
            <input placeholder="Shared folder name" class='form-control mr-1'
              v-model="folderName"
              :class="showNameError || showTooLongNameError ? 'is-invalid' : ''">
            <span class='invalid-feedback' v-if="showNameError">
              Name cannot be blank
            </span>
            <span class='invalid-feedback' v-if="showTooLongNameError">
              Name cannot be longer than 45 characters
            </span>
          </div>
        </div>
        <label class='form-label'>
          Please select users to share this folder with
          <span class='required'>*</span>
        </label>
        <div class='row col-12'
          v-if="!selectAll"
          :class="showUserError ? 'is-invalid' : ''">
          <select class="form-control" 
            data-url='/api/v1/users/search'
            v-model="userIds" id="user-search"
            @change="clearSelect2Error"
            placeholder="Select user to share this folder with" />
            <span class='invalid-feedback' v-show="showUserError"
              :class="showUserError ? 'is-invalid' : ''">
              You need to select at least one user
            </span>
          <small class='help-block text-muted'>
            You can select as many users as you like. 
          </small>
        </div>
        <div class='form-group' v-if="isAdmin">
          <label class="cui-utils-control cui-utils-control-checkbox">
            Select and track all users
            <input type="checkbox" v-model="selectAll">
            <span class="cui-utils-control-indicator"></span>
          </label>
        </div>
        <div class='form-group'>
          <label style="margin-top: 10px">
            Optional description
          </label>
          <textarea v-model="description"
            class='form-control' rows="2" style="max-height: 90px;">
          </textarea>
        </div>
        <div class='buttons' style='float: right'>
          <a class='btn btn-sm btn-myhive pull-right mt-2'
            @click.prevent="saveSharedFolder()"
            :style="submitDisabled ?'cursor: not-allowed': ''"
            :disabled="submitDisabled"
            v-html="saveTextAndIcon">
          </a>
          <a class='btn btn-sm btn-secondary pull-right mt-2'
            @click="hideModal()">
            <i class="far fa-times-circle"></i>&nbsp;Close
          </a>
        </div>
      </div>
    </div>
  </form>
</template>
<script>
import '../../chat/mixins/roomManager'
import shared from '../../medico_legal_cases/mixins/shared'
export default {
  props: ['formType', 'folder'],
  mixins: [shared],
  watch: {
    selectAll: function(newVal, oldVal) {
      $('select#user-search').prop("disabled", newVal)
      if (!newVal) {
        setTimeout(() => {
          UI.autocompleteSearch('select#user-search', true)
          this.updateSelect2()
          $(this.selectName).trigger('change')
        }, 300)
      } else {
        this.userIds.splice(0, this.userIds.length)
      }
    }
  },
  data() {
    return {
      submitDisabled: false,
      userIds: [],
      folderName: '',
      description: '',
      submit: false,
      selectAll: false,
      selectName: 'select#user-search'
    }
  },
  mounted() {
    UI.autocompleteSearch('select#user-search', true)
    this.updateSelect2()
    if (this.folder !== undefined && this.formType === 'edit') {
      this.folderName = this.folder.name
      this.description = this.folder.description
      this.selectAll = this.folder.trackable
      this.updateSelect2WithOptions()
    } 
  },
  computed: {
    header() {
      if (this.formType === 'new') {
        return 'Add new shared folder'
      } else {
        return 'Edit shared folder'
      }
    },
    showTooLongNameError() {
      return this.submit && this.folderName !== '' && this.folderName.length >= 45
    },
    showNameError() {
      return this.submit  && this.folderName === ''
    },
    showUserError() {
      return this.submit && !this.selectAll && this.userIds.length === 0
    },
    formValid() {
      return (this.showNameError === false && this.showUserError === false && this.showTooLongNameError === false)
    },
    saveTextAndIcon() {
      if (this.formType === 'new') {
        return `<i class="icmn-plus"></i>&nbsp;Add`
      } else {
        return `<i class="fas fa-save"></i>&nbsp;Save`
      }
    },
    requestMehtod() {
      if (this.formType === 'edit') {
        return 'PATCH'
      } {
        return 'POST'
      }
    },
    requestUrl() {
      if (this.formType === 'new') {
        return '/api/v1/folders'
      } {
        return `/api/v1/folders/${this.folder.id}`
      }
    },
    formData() {
      let data = {
        folder: {
          name: this.folderName,
          description: this.description,
          folder_type: 'shared_folder',
          trackable: this.selectAll
        },
        user_ids: this.userIds
      }
      if (this.formType === 'edit') {
        data.folder.id = this.folder.id
      }
      return data
    }
  },
  methods: {
    updateSelect2WithOptions() {
      this.folder.shared_with.forEach((user) => {
        this.addOptionElement(user)
        this.userIds.push(user.id)
        $(this.selectName).trigger('change')
      })
    },
    addOptionElement(element) {
      let fullName = `${element.first_name} ${element.last_name}`
      let option = new Option(fullName, element.id, true, true)
      $(this.selectName).append(option)
    },
    hideModal() {
      if (this.formType === 'new') {
        this.$modal.hide('new-shared-folder')
      } {
        this.$modal.hide(`edit-shared-folder-${this.folder.id}`)
      }
    },
    updateSelect2() {
      $(this.selectName).on('select2:select', (val) => {
        let id = val.params.data.id 
        let idx = this.userIds.find(el => el === id)
        if (idx === undefined) this.userIds.push(id)
        if ($(this.selectName).val().length > 0) {
          this.clearSelect2Error()
        }
      })
       $(this.selectName).on('select2:unselect', (val) => {
        let id = parseInt(val.params.data.id) 
        let idx = this.userIds.findIndex(el => el === id)
        if (idx !== undefined) this.userIds.splice(idx, 1)
        if ($(this.selectName).val().length === 0) {
          this.addSelect2Error()
        }
      })
    },
    clearSelect2Error() {
      $(this.selectName).parent()
        .removeClass('has-danger')
        .removeClass('is-invalid')
      $(this.selectName).removeClass('is-invalid')
    },
    addSelect2Error() {
      $(this.selectName).parent()
        .addClass('has-danger')
        .addClass('is-invalid')
      $(this.selectName).addClass('is-invalid')
    },
    saveSharedFolder() {
      this.submit = true
      debugger
      if (this.formValid) {
        $.ajax({
          type: this.requestMehtod,
          data: this.formData,
          url:  this.requestUrl
        }).done((jsonRes) => {
          this.submit = false
          window.location.reload(true)
        })
      }
    }
  }
}
</script>
<style>
.select2.select2-container {
  width: 100% !important;
}
</style>