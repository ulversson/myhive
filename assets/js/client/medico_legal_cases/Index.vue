<template>
  <div id='dashboard-cases'>
    <a class="btn btn btn-myhive mt-4" 
      v-if="isAdmin"
      title="Add new medico-legal case"
      data-toggle="tooltip"
      href='/medico_legal_cases/new'
      id='add-new-case'>
      <i class="fa fa-briefcase"></i>
      &nbsp;<span class='font-size-14 text'>Add new case</span>
    </a >
     <AnswerCall 
        :avatar="callingUser.avatar128"
        :userName="callingUser.userName"
        :callerId="callingUser.callerId"
        :isAudio="callingUser.isAudio"
        :isVideo="callingUser.isVideo"
        :user="callingUser.user"
        :name="callingUser.name"/>
    <tabs ref='tabs'/>
  </div>  
</template>
<script>
import Tabs from './components/Tabs.vue'
import shared from './mixins/shared'
import externalCall from '../chat/mixins/externalCall'
export default {
  mixins: [shared, externalCall],
  components: {
    Tabs
  }
}
</script>
<style>
.VueTables__heading {
  margin-right: 5px !important;
}
</style>