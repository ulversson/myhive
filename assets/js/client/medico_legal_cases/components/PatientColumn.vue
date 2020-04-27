<template>
  <div class="media align-items-center case-folder" style="cursor: pointer">
    <i class="d-block ui-w-40 rounded-circle fas fa-folder-open fa-2x" :class='folderColor'></i>
      <div class="media-body flex-basis-auto pl-3" style='font-size: 14px'>
      <div class="name">{{$attrs.data.patient}}</div>
      <div class="text-muted small">
        <span class="note">  
          {{$attrs.data.note}}
        </span>
      </div>
    </div>
  </div>
</template>
<script>
import activeTab from '../mixins/activeTab'

export default {
  mixins: [activeTab],
  created() {
    console.log(this.row)
  },
  props: ['row']
}
</script>