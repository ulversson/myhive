<template>
  <div class='file-items'>
    <div class="file-box"
      v-for="folder in folders" :key="folder.id">
      <FolderItem :folder="folder" :type="type" />
    </div>
  </div>
</template>
<script>
import settings from '../../file_manager/mixins/settings'
import FolderItem from './FolderItem.vue'
export default {
  mixins: [settings],
  props: ['folders', 'type'],
  components: {
    FolderItem
  }
}
</script>