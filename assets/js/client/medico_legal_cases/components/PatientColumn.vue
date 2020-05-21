<template>
  <div class="media align-items-center case-folder" style="cursor: pointer" 
    @click='loadFileManager($attrs.data)'>
    <i class="d-block ui-w-40 rounded-circle fas fa-folder-open fa-2x" :class='folderColor'></i>
      <div class="media-body flex-basis-auto pl-3" style='font-size: 14px'>
      <div class="name">
        {{$attrs.data.patient}}
        <i class="fas fa-cross text-default" v-if='$attrs.data.deceased'></i>
      </div>
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
  methods: {
    loadFileManager(data) {
      window.localStorage.setItem('caseFolder', data.folder_id)
      window.localStorage.setItem('currentMedicoLegalCaseId', data.id)
      window.localStorage.setItem('currentAccount', data.account_id)
      window.location.href=`/folders`
    }
  },
  props: ['row']
}
</script>