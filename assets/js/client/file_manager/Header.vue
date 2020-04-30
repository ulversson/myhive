<template>
  <div class="cui-github-explore">
    <div class="cui-github-explore-sort clearfix">
      <div class="cui-github-explore-sort-left">
        <button class="cui-github-explore-sort-option btn btn-primary btn-sm">
          <i class='icmn-upload'></i>&nbsp;
          Upload
        </button>
        <button class="cui-github-explore-sort-option btn btn-default btn-sm">
          <i class='icmn-download'></i>&nbsp;
          Download
        </button>
      </div>
      <right-panel-actions />
    </div>  
  </div>
</template>
<script>
import RightPanelActions from './RightPanelActions.vue'
export default {
  components: { RightPanelActions }
}
</script>