<template>
  <div class='shared-files'>
    <h4>{{ownersUserName}}'s shared items</h4>
    <a class='btn btn-primary btn-sm mb-3' @click="showModal">
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
                &nbsp;Shared by you with others
              </a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="javascript: void(0);" 
              @click="tooltiptize"
              data-toggle="tab" data-target="#others" role="tab"  aria-selected="false">
                <i class='icmn-box-add'></i>
                &nbsp;Shared with you by others
              </a>
          </li>
        </ul>
        <div class="tab-content">
          <div class="tab-pane active" id="mine">
            <FoldersList :folders="foldersMine" type="mine"/>
          </div>
          <div class="tab-pane" id="others">
            <FoldersList :folders="foldersOthers" type="others"/>
          </div>
        </div>
        </div>
      </div>
    <add-shared-folder />
  </div>
</template>
<script>
  import { mapState } from 'vuex'
  import AddSharedFolder from './components/AddSharedFolder.vue'
  import FoldersList from './components/FoldersList.vue'
  import settings from '../file_manager/mixins/settings'
  export default {
    mixins: [settings],
    components: { FoldersList, AddSharedFolder },
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
        })
      },
      showModal() {
        this.$modal.show('new-shared-folder')
      }
    },
    computed: {
      ...mapState(['column', 'order']),
      ownersUserName() {
        return $("div.dropdown.cui-topbar-avatar-dropdown").data().username
      }
    }
  }
</script>