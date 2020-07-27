<template>
  <a href="#">
    <div class="file">
      <span class="corner">
        <i class='fas fa-elipsis-v'></i>&nbsp;
      </span>
      <div class="icon" data-toggle="tooltip" 
          data-html="true"
          :data-title="`Shared with: ${sharedWith.join(', ')}`"
          data-placement="top">
        <i :class="folderIcon"           
          :style="`color: ${textColor} !important`"></i>
      </div>
        <div class="file-name">
          {{ folder.name }}
        <br>
        <div class='desc'>
          {{ folderDesc }}
        </div>
        <small>{{folderDate}}</small>
        <br/>
        <span class='badge badge-secondary badge-pill'>
          {{owner}}
        </span>
      </div>
    </div>
  </a>
</template>
<script>
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
  computed: {
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
    folderDate() {
      return moment(this.folder.updated)
        .format("DD/MM/YYYY HH:MM")
    },
    folderIcon() {
      return 'icmn-folder-open'
    },
    owner() {
      return `${this.folder.user.first_name} ${this.folder.user.last_name}` 
    }
  }
}
</script>