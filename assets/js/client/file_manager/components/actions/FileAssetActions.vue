<template>
  <td class='text-default' style="max-width: 40px; width: 40px; cursor: pointer"> 
    <a class="btn-floating btn-sml text-default" type="button" id="dropdownMenu3" data-toggle="dropdown"
      style='cursor: pointer' aria-haspopup="true" aria-expanded="false">
      <i class="fas fa-ellipsis-v"></i>
    </a>
    <div class="dropdown-menu dropdown-primary">
      <a :href="downloadUrl" class="dropdown-item">
        <i class="icmn-download"></i>
        &nbsp;Download
      </a>
      <a class="dropdown-item" href="#">
        <i class="fas fa-pen"></i>
        &nbsp;Rename
      </a>
      <a class="dropdown-item" href="#">
        <i class="fas fa-trash"></i>
        &nbsp;Remove
      </a>
    </div>
  </td>
</template>
<script>
export default {
  computed: {
    downloadUrl() {
      return `downloads/${this.fileAsset.id}`
    }
  },
  props: ['fileAsset']
}
</script>