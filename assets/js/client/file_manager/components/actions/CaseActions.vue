<template>
  <div class="dropdown cui-github-explore-sort-option case-actions">
      <Radiology ref='radiology'/>
      <ShareModal />
      <Consultations :currentFolder="currentFolder" />
      <NewFolder :currentFolder="currentFolder" v-show="false" ref="newFolder"/>
      <button type="button"
        class="btn dropdown-toggle btn-info"
        style="height: 39.84px;"
        data-toggle="dropdown"
        aria-expanded="false">
        Case actions
      </button>
      <ul class="dropdown-menu" aria-labelledby="" role="menu">
        <li style="line-height: 35px">
          <a class="dropdown-item"
            data-toggle="tooltip"
            data-placement="top"
            @click="addNewFolder()">
            <i class='fas fa-folder-plus'></i>&nbsp;
            Add new folder...
          </a>
        </li>
        <li style="line-height: 35px" class='rad'>
          <a class="dropdown-item"
            v-if="isRadiologyVisible"
            :title="radiologyTitle"
            data-toggle="tooltip"
            data-placement="top"
            @click="showRadiology()">
            <i class='fas fa-x-ray'></i>&nbsp;
            Radiology...
          </a>
        </li>
        <li style="line-height: 35px">
        <a class="dropdown-item"
          title="Share files from this case via email"
          data-toggle="tooltip"
          @click="share()">
          <i class='fas fa-share-alt'></i>&nbsp;
          Share...
        </a>
        </li>
        <li style="line-height: 35px" class='cons'>
        <a class="dropdown-item"
          title="Share files from this case via email"
          data-toggle="tooltip"
          @click="showConsultations()">
          <i class='fas fa-user-md'></i>&nbsp;
          Consultations...
        </a>
        </li>
      </ul>
  </div>
</template>
<script>
import settings from '../../mixins/settings'
import currentFolder from '../../mixins/currentFolder'
import Radiology from '../radiology/Radiology.vue'
import ShareModal from '../sharing/ShareModal.vue'
import Consultations from '../consultations/Consultations.vue'
import NewFolder from '../actions/NewFolder.vue'
export default {
  props: ['currentFolderId', 'currentFolder'],
  mixins: [currentFolder, settings],
  updated() { $("a.btn-tooltip, a.cui-github-explore-sort-option").tooltip() },
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
  methods: {
    share() {
      this.$modal.show('share-modal')
    },
    showRadiology() {
      if (this.isRadiologyButtonEnabled) {
        this.$modal.show('radiology')
      } else 
        return
    },
    showConsultations() {
      this.$modal.show('consultations-modal')
    },
    addNewFolder() {
      this.$refs.newFolder.promptNewFolder('Add new folder')
    }
  },
  components: {
    Radiology, ShareModal,Consultations, NewFolder
  }
}
</script>
<style scoped>

.case-actions .dropdown-menu a:hover {
  color: #fff !important;
  background: #ba04ba; 
  border: 1px solid #ba04ba
}
.case-actions .dropdown-menu a:active {
  color: #fff !important;
  border: 1px solid #ba04ba
}
.case-actions .dropdown-menu li:first-child a:hover {
  color: #fff !important;
  background-color: #fb434a;
  border-color: #fb434a;
}
.case-actions .dropdown-menu li:first-child a:active {
  color: #fff !important;
  background-color: #fb434a;
  border-color: #fb434a;
}
.case-actions .dropdown-menu li.cons a:hover {
  color: #fff !important;
  background: #03a58a; 
  border: 1px solid #069e1f
}
.case-actions.dropdown-menu li.cons a:active {
  color: #fff !important;
  border: 1px solid #199924
}

.case-actions .dropdown-menu li.rad a:active {
  color: #fff !important;
  border: 1px solid #ba8904

}

.case-actions .dropdown-menu li.rad a:hover {
  color: #fff !important;
  background: #e0a500; 
  border: 1px solid #ddbc04
}

</style>