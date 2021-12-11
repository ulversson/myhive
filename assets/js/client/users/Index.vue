<template>
   <modal 
    :name="modalName"
    :min-width="200" :min-height="250"
    :adaptive="true" :scrollable="true"
    styles="font-size: 13px" :reset="true"
    @opened="afterOpened" width="45%" height="40%">
    <div class='card'>
      <div class='card-header'>
        <span class='cui-utils-title'>Share CV via email</span>
      </div>
      <div class='card-body'>
        <div class='form-group'>
          <label class='form-label'>
            Please enter email addresses and press ENTER after each one
            <span class='required'>*</span>
          </label>
            <vue-tags-input
              v-model="tag"
              style="width: 100%"
              :tags="emails"
              :allow-edit-tags="true"
              :avoid-adding-duplicates="true"
              :placeholder="'Add email address'"
              :add-from-paste="false"
              @tags-changed="newTags => emails = newTags" />
        </div>
        <div class='buttons' style='float: right'>
          <a class='btn btn-sm btn-primary pull-right mt-2'
            @click="shareFiles()">
            <i class="fas fa-share-alt"></i>&nbsp;Share
          </a>
          <a class='btn btn-sm btn-secondary pull-right mt-2'
            @click="hideModal()">
            <i class="far fa-times-circle"></i>&nbsp;Close
          </a>
        </div>
      </div>
    </div>
   </modal>
</template>
<script>
import VueTagsInput from '@johmun/vue-tags-input'
export default {
  components : { VueTagsInput },
  data() {
    return {
      emails: [],
      tag: ""
    }
  },
  methods: {
    afterOpened() {},
    openModal() {
      this.$modal.show(this.modalName)
    },
    hideModal() {
      this.$modal.hide(this.modalName)
    },
    shareFiles() {
      if (this.emails.length === 0) {
        this.$swal('Error', 'You must provide at least one email address', 'error')
      } else {
        $.post(`/api/v1/user/${this.userId}/share_cv`, this.shareData)
          .done((res) => {
            if (res) {
              this.$swal('Shared', 'Email with experts CV has been sent', 'success')
              this.$modal.hide(this.modalName)
            }
          })
      }
    }
  },
  computed: {
    userId() {
      return window.location.pathname.split("/")[3]
    },
    shareData() {
      return {
        emails: this.emails.map(e => e.text).join(','),
        id: this.userId
      }
    },
    modalName() {
      return 'share-cv-modal'
    }
  }
}
</script>