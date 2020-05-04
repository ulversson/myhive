<template>
  <div class="dropdown cui-github-explore-sort-option">
      <button type="button"
        class="btn btn-sm dropdown-toggle"
        data-toggle="dropdown"
        aria-expanded="false">
        Bulk
      </button>
      <ul class="dropdown-menu" aria-labelledby="" role="menu">
        <a class="dropdown-item" href="javascript: void(0)">
          Mark as unread
        </a>
        <a class="dropdown-item" href="javascript: void(0)">
          Mark as read
        </a>
        <div class="dropdown-divider"></div>
        <a class="dropdown-item" href="javascript: void(0)" @click="removeSelectedItems()">
          <i class='fa fa-trash'></i>&nbsp;Remove selected
        </a>
      </ul>
  </div>
</template>
<script>
export default {
  methods: {
    removeSelectedItems() {
      
    }
  }
}
</script>