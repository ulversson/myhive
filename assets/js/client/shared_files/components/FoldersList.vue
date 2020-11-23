<template>
  <div class='pl-0 pr-0  col-12 col-xs-3  align-content-start file-items d-flex d-flex flex-wrap'
    style="justify-content: space-between">
    <div class="file-box" 
      v-for="folder in folders" :key="folder.id">
      <FolderItem :folder="folder" :type="type" 
        :isAdmin="isAdmin" />
    </div>
  </div>
</template>
<script>
import settings from '../../file_manager/mixins/settings'
import FolderItem from './FolderItem.vue'
export default {
  mixins: [settings],
  props: ['folders', 'type', 'isAdmin'],
  components: {
    FolderItem
  }
}
</script>