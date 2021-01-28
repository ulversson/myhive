<template>
  <div class="cui-github-explore mb-3" style='border-bottom: 1px solid #e4e9f0'>
    <div class='card-body pt-0 pb-0'>
			<Consultations :currentFolder="currentFolder" ref="consultationList" />
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
            class="cui-github-explore-sort-option btn text-white btn-radiology same-width"
            v-if="isRadiologyVisible"
            :title="radiologyTitle"
            data-toggle="tooltip"
            data-placement="top"
            @click="showRadiology()">
            <i class='fal fa-x-ray'></i>&nbsp;
            Radiology
          </a>
        <a class="cui-github-explore-sort-option btn text-white btn-cons same-width"
          title="Add consultation entries for this patient"
          data-toggle="tooltip"
          ref="consultations"
          @click="showConsultations()">
          <i class='fal fa-user-md'></i>&nbsp;
          Consultations
        </a>
        <CaseActions :currentFolder="currentFolder" 
          ref="caseActions"
          :isAdmin="isAdmin"
          :textColor="textColor"
          :currentFolderId="currentFolderId"
          :assets="assets" />
				<TimelineActions v-if="showTimeline"/>
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
  </div>
</template>
<script>
import RightPanelActions from './RightPanelActions.vue'
import currentFolder from '../mixins/currentFolder'
import NewFolder from './actions/NewFolder.vue'
import Radiology from './radiology/Radiology.vue'
import CaseActions from './actions/CaseActions.vue'
import Consultations from './consultations/Consultations.vue'
import settings from '../mixins/settings'
import externalCall from '../../chat/mixins/externalCall'
import TimelineActions from '../components/actions/TimelineActions.vue'
export default {
  props: ['currentFolderId', 'currentFolder', 'assets', 'isAdmin', 'showTimeline'],
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
        return 'btn-radiology'
    }
  },
  updated() { $("a.btn-tooltip, a.cui-github-explore-sort-option").tooltip() },
  components: {
		TimelineActions, RightPanelActions, NewFolder, CaseActions, Consultations, Radiology 
	},
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