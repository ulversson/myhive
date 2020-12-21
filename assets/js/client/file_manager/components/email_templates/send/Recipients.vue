<template>
  <div class="recipients col-12 row p-0 m-0 mb-3">
    <div class="form-group col-12 p-0 m-0 mb-3">
      <label>
        Email address
        <span class="required">*</span>
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
        @tags-changed="(newEmails) => (emails = newEmails)"
      />
      <span class="help-block" v-if="showEmailError">
        {{ emailErrorMessage }}
      </span>
    </div>
    <div class="form-group col-12 p-0 m-0">
      <label> BCC Email address </label>
      <vue-tags-input
        v-model="bccTag"
        :tags="bccEmails"
        :allow-edit-tags="true"
        :style="'padding-left: 0px'"
        :avoid-adding-duplicates="true"
        :placeholder="'Add BCC email address'"
        :add-from-paste="false"
        @tags-changed="(newEmails) => (bccEmails = newEmails)"
      />
    </div>
  </div>
</template>
<script>
import VueTagsInput from '@johmun/vue-tags-input'
import FolderActionsVue from '../../actions/FolderActions.vue'
export default {
	data() {
		return {
			emails: [],
			bccEmails: [],
			tag: '',
			bccTag: '',
			submit: false
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
	components: {
		VueTagsInput
	}
}
</script>