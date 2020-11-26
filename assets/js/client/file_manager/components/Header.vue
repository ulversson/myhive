<template>
  <div class="cui-github-explore">
    <Consultations :currentFolder="currentFolder" />
    <Radiology ref='radiology'/>
    <div class='DashboardContainer'></div>
    <div class="cui-github-explore-sort clearfix">
      <div class="cui-github-explore-sort-left">
        <div class='DashboardContainer'></div>
        <button class="cui-github-explore-sort-option btn btn icon-btn btn-outline-success" 
          @click="loadParent()" v-if="hasParent">
          <i class='icmn-arrow-left'></i>&nbsp;
        </button>
        <a :class="radiologyButtonClass"
            class="cui-github-explore-sort-option btn text-white"
            v-if="isRadiologyVisible"
            :title="radiologyTitle"
            data-toggle="tooltip"
            data-placement="top"
            @click="showRadiology()">
            <i class='fas fa-x-ray'></i>&nbsp;
            Radiology
          </a>
        <a class="cui-github-explore-sort-option btn text-white cons"
          title="Add consultation entries for this patient"
          data-toggle="tooltip"
          @click="showConsultations()">
          <i class='fas fa-user-md'></i>&nbsp;
          Consultations
        </a>
        <CaseActions :currentFolder="currentFolder" 
          ref="caseActions"
          :currentFolderId="currentFolderId"
          :assets="assets" />
        <NewFolder :currentFolder="currentFolder" 
          v-if="showNewFolder" />
      </div>
      <right-panel-actions :currentFolderId="currentFolderId"
        ref="rightPanel"
        :currentFolder="currentFolder" />
      <AnswerCall 
        :avatar="callingUser.avatar128"
        :userName="callingUser.userName"
        :callerId="callingUser.callerId"
        :isAudio="callingUser.isAudio"
        :isVideo="callingUser.isVideo"
        :user="callingUser.user"
        :name="callingUser.name"/>
    </div>  
  </div>
</template>
<script>
import RightPanelActions from './RightPanelActions.vue'
import currentFolder from '../mixins/currentFolder'
import ShareModal from './sharing/ShareModal.vue'
import NewFolder from './actions/NewFolder.vue'
import Radiology from './radiology/Radiology.vue'
import CaseActions from './actions/CaseActions.vue'
import Consultations from './consultations/Consultations.vue'
import settings from '../mixins/settings'
import externalCall from '../../chat/mixins/externalCall'
export default {
  props: ['currentFolderId', 'currentFolder', 'assets'],
  mixins: [currentFolder, settings, externalCall],
  computed: {
    appModules() {
      return this.$store.state.appModules.map((f) => {
        return f.code
      })
    }, 
    isRadiologyVisible() {
      return this.appModules.includes("radiology")
    },
    isRadiologyButtonEnabled() {
      return true
    },
    radiologyTitle() {
      if (this.isRadiologyButtonEnabled === false) 
        return 'No radiology supplied by instructing solicitors; please notify the team if you need sight of any radiology'  
      else 
        return 'Browse Radiology'
    },
    radiologyButtonClass() {
      if (this.isRadiologyButtonEnabled === false) 
        return  'btn-default' 
      else 
        return 'btn-warning'
    }
  },
  updated() { $("a.btn-tooltip, a.cui-github-explore-sort-option").tooltip() },
  components: { RightPanelActions, NewFolder, CaseActions, Consultations, Radiology },
  created() {
    if (window.location.pathname.includes('archive') || window.location.pathname.includes('shared')) {
      this.showNewFolder = true
    } 
  },
  methods: {
    showRadiology() {
      if (this.isRadiologyButtonEnabled) {
        this.$modal.show('radiology')
      } else 
        return
    },
    showConsultations() {
      this.$modal.show('consultations-modal')
    }
  },
  data() {
    return {
      showNewFolder: false
    }
  }
}
</script>
<style>
a.cons  {
  color: #fff !important;
  background: #03a58a; 
  border: 1px solid #069e1f
}
a.cons:hover {
  color: #fff !important;
  background: #03a58a; 
  border: 1px solid #069e1f
}
a.cons a:active {
  color: #fff !important;
  border: 1px solid #199924
}
</style>