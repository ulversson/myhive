<template>
  <div id='dashboard-cases'>
    <a class="btn btn-sm btn-primary ml-2" 
      v-if="isAdmin"
      href='/medico_legal_cases/new'
      id='add-new-user'>
      <i class="fa fa-briefcase fa-2x"></i>
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