<template>
  <div class="bin-content col-12">
    <BulkActions />
    <div class="nav-tabs-horizontal">
      <ul class="nav nav-tabs" 
        role="tablist" style="font-size: 16px; float: right">
        <li class="nav-item">
          <a class="nav-link"
            href="javascript: void(0);"
            data-toggle="tab"
            data-target="files"
            :class="tab === 'files' ? 'active': ''"
            @click="makeActive('files')"
            role="tab">
            <i class="icmn-copy"></i>
            Files
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link"
            href="javascript: void(0);"
            data-toggle="tab"
            data-target="#folders"
            :class="tab === 'folders' ? 'active': ''"
            @click="makeActive('folders')"
            role="tab">
            <i class="icmn-folder-open"></i>
            Folders
          </a>
        </li>
      </ul>
      <div class="tab-content pt-5">
        <div class="tab-pane mt-5" id="files"
          :class="tab === 'files' ? 'active': ''">
          <div class="nav-tabs-vertical">
            <Alert message="No deleted files" v-if="groupedFiles.length == 0" />
            <DayTabs :groupedItems="groupedFiles" />
            <TabContent :groupedItems="groupedFiles" itemType="file"/>
          </div>
        </div>
        <div class="tab-pane pt-5" id="folders"
          :class="tab === 'folders' ? 'active': ''">
           <div class="nav-tabs-vertical">
            <Alert message="No deleted folders" v-if="groupedFolders.length == 0" />
            <DayTabs :groupedItems="groupedFolders" />
            <TabContent :groupedItems="groupedFolders" itemType="folder" />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import settings from "../file_manager/mixins/settings"
import BulkActions from './components//BulkActions.vue'
import DayTabs from "./components/DayTabs.vue"
import TabContent from "./components/TabContent.vue"
import Alert from '../file_manager/components/Alert.vue'
export default {
  components: { BulkActions, DayTabs, TabContent, Alert },
  mixins: [settings],
  data() {
    return {
      groupedFiles: () => {},
      groupedFolders: () => {},
      tab: 'files'
    };
  },
  created() {
    this.loadBinContent();
    this.loadSettings();
  },
  methods: {
    makeActive(tab) {
      this.tab = tab
    },
    loadBinContent() {
      $.ajax({
        type: "GET",
        url: `/api/v1/recycle_bin`,
        contentType: "application/json",
      }).done((jsonRes) => {
        console.log(jsonRes)
          let grouped = Fn.groupArrayByDate(jsonRes.files, "deleted_at");
          let groupedFolders = Fn.groupArrayByDate(jsonRes.folders, 'deleted_at')
          this.$set(this, "groupedFiles", grouped);
          this.$set(this, "groupedFolders", groupedFolders)
        })
        .catch((err) => {
          this.$swal('Error', 'Unable to load bin content', 'error')
        });
    },
  },
};
</script>
