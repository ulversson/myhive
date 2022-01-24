<template>
  <modal :name="modalName"
    :min-width="200" :min-height="450"
    :adaptive="true" :scrollable="true"
    styles="font-size: 13px" :reset="true"
    @opened="afterOpened" width="50%" height="60%">
    <form class='form-horizontal form-share'>
      <div class='card'>
        <div class='card-header'>
          <span class='cui-utils-title'>Share files</span>
        </div>
        <div class='nav-tabs-horizontal reports'>
        <ul class="nav nav-tabs reports mb-4 mr-4" role="tablist" style="float: right; font-size: 15px;">
          <li class="nav-item reports">
            <a class="nav-link active reports" href="javascript: void(0);" 
              data-toggle="tab" data-target="#mine" role="tab" aria-selected="false">
                <i class='fal fa-share-alt'></i>
                Share files
              </a>
          </li>
          <li class="nav-item reports">
            <a class="nav-link reports" href="javascript: void(0);" 
              data-toggle="tab" data-target="#others" role="tab"  aria-selected="false">
                <i class='fal fa-history'></i>
                &nbsp;History
              </a>
          </li>
        </ul>
        <div class="tab-content" style="margin-top: -52px;width: 100%">
          <div class="tab-pane active" id="mine" style="padding-top: 55px !important;">
            <share-tab ref="share"/>
          </div>
          <div class="tab-pane" id="others" style="padding-top: 55px !important;">
            <history-tab />
          </div>
        </div>
      </div>
      </div>
    </form>
  </modal>
</template>
<script>
import ShareTab from './ShareTab.vue'
import HistoryTab from './HistoryTab.vue'
import settings from '../../mixins/settings'
import folderTree from '../../mixins/folderTree'
import autosize from "autosize";
import '@riophae/vue-treeselect/dist/vue-treeselect.css'
export default {
  mixins: [settings, folderTree],
  methods: {
    hideModal() {
      this.$modal.hide('share-modal')
    },
    afterOpened() {
      this.$refs.share.reset();
      this.$refs.share.updateTree();
      autosize(document.querySelectorAll("textarea"));
    }
  },
  components: {
    ShareTab,
    HistoryTab
  },
  computed: {
    modalName() {
    return 'share-modal'
    }
  }
} 
</script>