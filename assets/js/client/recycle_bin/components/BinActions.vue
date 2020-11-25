<template>
    <td class='text-default' style="max-width: 40px; width: 40px; cursor: pointer"> 
    <button class="btn-menu btn-floating btn-sml text-default btn-rounded" type="button" id="dropdownMenu3" data-toggle="dropdown"
      style='cursor: pointer; border-radius: 25px; outline: none' aria-haspopup="true" aria-expanded="false">
      <i class="fas fa-ellipsis-h"></i>
    </button>
    <div class="dropdown-menu dropdown-primary">
      <a :href="downloadLink" class="dropdown-item">
        <i class="icmn-download"></i>
        &nbsp;Download
      </a>
      <a class="dropdown-item" href="#">
        <i class="fas fa-redo"></i>
        &nbsp;Restore
      </a>
      <a class="dropdown-item" href="#">
        <i class="fas fa-trash"></i>
        &nbsp;Remove forever
      </a>
    </div>
  </td>
</template>
<script>
export default {
  props: ['downloadLink']
}
</script>