<template>
  <div class='shared-files'>
    <a class='btn btn-primary btn mb-3' @click="showModal"
      title="Add new shared folder and share it with other system users"
      data-toggle="tooltip">
      <i class='icmn-plus'></i>&nbsp;
      Add shared folder
    </a>
    &nbsp;
    <div class="mb-5">
      <div class='nav-tabs-horizontal'>
        <ul class="nav nav-tabs mb-4" role="tablist">
          <li class="nav-item">
            <a class="nav-link active" href="javascript: void(0);" 
              data-toggle="tab" data-target="#mine" role="tab" 
              @click="tooltiptize"
              aria-selected="false">
                <i class='icmn-box-remove'></i>
                &nbsp;Shared <strong>by</strong> you
              </a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="javascript: void(0);" 
              @click="tooltiptize"
              data-toggle="tab" data-target="#others" role="tab"  aria-selected="false">
                <i class='icmn-box-add'></i>
                &nbsp;Shared <strong>with</strong> you
              </a>
          </li>
        </ul>
        <div class="tab-content">
          <div class="tab-pane active" id="mine">
            <FoldersList :folders="foldersMine" 
              :isAdmin="isAdmin"
              type="mine"/>
            <Alert :message="noFoldersMessage"
              v-if="foldersMine.length === 0 && window.location.pathname == '/shared'"/>
          </div>
          <div class="tab-pane" id="others">
            <FoldersList :folders="foldersOthers" 
              :isAdmin="isAdmin"
              type="others"/>
            <Alert :message="noFoldersMessage"
              v-if="foldersOthers.length === 0 
              && window.location.pathname == '/shared'"/>
          </div>
        </div>
        </div>
      </div>
    <add-shared-folder :isAdmin="isAdmin"/>
  </div>
</template>
<script>
  import { mapState } from 'vuex'
  import AddSharedFolder from './components/AddSharedFolder.vue'
  import FoldersList from './components/FoldersList.vue'
  import Alert from '../file_manager/components/Alert.vue'
  import settings from '../file_manager/mixins/settings'
  export default {
    mixins: [settings],
    components: { FoldersList, AddSharedFolder, Alert },
    data() {
      return {
        folders: [],
        foldersMine: [],
        foldersOthers: []
      }
    },
    mounted() {
      this.loadSharedFolders()
      this.loadSettings()
    },
    methods: {
      tooltiptize() {
        $("[data-toggle='tooltip']").tooltip()
      },
      loadSharedFolders() {
        $.getJSON(`/api/v1/shared?order=${this.order}&column=${this.column}`, (res) => {
          res.shared_by_me_folders.forEach((folder, index) => {
            this.foldersMine.push(folder)
          })
          res.shared_by_others_folders.forEach((folder, index) => {
            this.foldersOthers.push(folder)
          })
          this.$store.commit('setRole', res.role[0])
        })
      },
      showModal() {
        this.$modal.show('new-shared-folder')
      }
    },
    computed: {
      window() {
        return window
      },
      noFoldersMessage() {
        return "Currently there are no shared folders"
      },
      ...mapState(['column', 'order'])
    }
  }
</script>