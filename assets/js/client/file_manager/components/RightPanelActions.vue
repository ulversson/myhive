<template>
  <div class="cui-github-explore-sort-right">
    <div class="cui-github-explore-sort-option">
      <div class='btn-group'>
        <Search :currentFolder="currentFolder" ref="search"/>
        <Ordering :currentFolderId="currentFolderId"/>
      </div>
    </div>
    <BulkOperations :currentFolder="currentFolder" />
  </div>
</template>
<script>

import Search from './actions/Serach.vue'
import Ordering from './actions/Ordering.vue'
import BulkOperations from './actions/BulkOperations.vue'
export default {
  props: ['currentFolderId', 'currentFolder'],
  components: {
    Search, Ordering, BulkOperations
  }
}
</script>