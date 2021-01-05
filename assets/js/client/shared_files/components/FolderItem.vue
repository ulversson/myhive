<template>
  <div class='folder-item'>
    <edit-shared-folder :folder="folder" :isAdmin="isAdmin" />
    <div class="file">
      <span class="corner">
      </span>
      <div class="icon" data-toggle="tooltip" 
        @click="navigateToFolder()"      
        style="cursor: pointer !important" 
        data-html="true"
        :data-title="`Shared with ${sharedWithTooltip}`"
        data-placement="top">
        <i :class="folderIcon"    
          :style="iconStyle"></i>
        <i class='fas fa-users' 
          v-if="folder.trackable"
          :style="`color: ${textColor};float: right;font-size: 16px;`"></i>
      </div>
      <div class="file-name">
        {{ folder.name }}
      <br>
      <div class='desc' style="overflow: scroll; height: 45px">
        {{ folderDesc }}
      </div>
      <small>{{folderDate}}</small>
      <br/>
      <span class='badge badge-secondary badge-pill'>
        {{owner}}
      </span>
      <div class='buttons' style='float: right'>
        <button class="btn btn-icon btn-xs btn-rounded btn-outline-warning mt-2 ml-2 pull-right"
          @click="editSharedFolder()"
          v-if="isOwner"
          data-toggle='tooltip' data-title='Edit shared folder settings'>
          <i class="fas fa-edit"></i>
        </button>
        <button class="btn btn-icon btn-xs btn-rounded btn-outline-danger mt-2 ml-2 pull-right"
          data-toggle='tooltip' 
          v-if="isOwner"
          @click="removeSharedFolder()"
          data-title='Remove shared folder and all its content'>
          <i class="fas fa-trash-alt"></i>
        </button>
      </div>
    </div>
  </div>
</div>
</template>
<script>
// @ts-nocheck
import EditSharedFolder from './EditSharedFolder.vue'
import settings from '../../file_manager/mixins/settings'
export default {
  created() {
    $("[data-toggle='tooltip']").tooltip()
  },
  updated() {
    $("[data-toggle='tooltip']").tooltip()
  },
  props: ['folder', 'type'],
  mixins: [settings],
  components: { EditSharedFolder },
  methods: {
    navigateToFolder() {
      window.location.href=`/shared/view/internal/${this.folder.id}`
    },
    editSharedFolder() {
      this.$modal.show(this.modalName)
    },
    removeSharedFolder() {
      UI.runConfirmedAction(
        'fas fa-trash-alt', 
        'DELETE',
        'Remove this shared folder',
        'All folder contents (files, subdirectories) will be irreversibly deleted',
        `/api/v1/folders/${this.folder.id}`, () => {
          window.location.reload(true)
        }
      )
    }
  },
  computed: {
    iconStyle() {
      let basicStyle = `color: ${this.textColor} !important;`
      if (this.folder.trackable)
        return `${basicStyle} margin-left: 30px;`
      else {
        return basicStyle;
      }
    },
    sharedWithTooltip() {
      if (this.folder.trackable) {
        return 'all system users'
      } else {
        return this.sharedWith.join(', ')
      }
    },
    sharedColor() {
      if (this.folder.trackable) {
        return '#F7DC5F'
      } else {
        return this.textColor
      }
    },
    sharedWith() {
      return this.folder.shared_with.map(u => `${u.first_name}&nbsp;${u.last_name}`)
    },
    folderDesc() {
      if (this.folder.description !== '' && this.folder.description !== null) {
        return this.folder.description
      } else {
        return 'No description'
      }
    },  
    modalName() {
      return `edit-shared-folder-${this.folder.id}`
    },
    folderDate() {
      return moment.utc(this.folder.updated)
        .tz('Europe/London')
        .format('DD/MM/YYYY HH:mm')
    },
    folderIcon() {
      return 'icmn-folder-open'
    },
    isOwner() {
      return this.folder.user.id === $("div.cui-topbar-avatar-dropdown").data().userId
    },
    owner() {
      return `${this.folder.user.first_name} ${this.folder.user.last_name}` 
    }
  }
}
</script>