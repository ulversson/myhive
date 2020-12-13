<template>
  <modal 
    :name="modalName"
    :min-width="800" 
    :min-height="150"
    :adaptive="true" 
    :scrollable="true"
    styles="font-size: 13px"
    :width="'auto'"
    :reset="true"
    @opened="afterOpened" 
    height="auto">
    <div class='card'>
      <div class='card-header'>File Information</div>
      <div class='card-body'>
        <dl class="row">
          <dt class="col-xl-4">File icon</dt>
          <dd class="col-xl-8">
            <p class="cui-github-explore-nav-icon" 
                :style="`color: ${$parent.textColor} !important`">
              <i :class="fileAsset.icon" class='fa-2x'></i>
            </p>
          </dd>
          <dt class="col-xl-4">File name</dt>
          <dd class="col-xl-8">
            <span class='badge'
              :class='`badge-pill badge-alt badge-info`' 
              style='font-size: 12px'>{{fileAsset.name}}
            </span>
          </dd>
          <dt class="col-xl-4">File type</dt>
          <dd class="col-xl-8">
            <span class='text-bold'  
              style='font-size: 12px'>
              <strong>{{fileAsset.name.split(".")[1].toUpperCase()}}</strong>
            </span>
          </dd>  
          <dt class="col-xl-4">File size</dt>
          <dd class="col-xl-8">
            <span class='text-bold badge-pill badge-alt badge-secondary'  
              style='font-size: 12px'>
              {{fileSize()}}
            </span>
          </dd>  
          <dt class="col-xl-4">System ID</dt>
          <dd class="col-xl-8">
            <code>
              {{ fileAsset.id }}
            </code>
          </dd>  
        </dl>
      </div>
    </div>
      <a class="btn btn-sm btn-secondary pull-right mt-2 mr-2"
        style="float: right; !important;margin-bottom: 20px !important;"
        @click="hide()">
        <i class="far fa-times-circle"></i>&nbsp;Close
      </a>
  </modal>
</template>
<script>
export default {
  props: ['fileAsset'],
  created() {
    debugger
  },
  methods: {
    afterOpened() {
      debugger
    },
    fileSize() {
      return Fn.humanFileSize(parseInt(this.fileAsset.size))
    },
    hide() {
      this.$modal.hide(this.modalName)
    }
  },
  computed: {
    modalName() {
      return `file-info-${this.fileAsset.id}`
    }
  }
} 
</script>