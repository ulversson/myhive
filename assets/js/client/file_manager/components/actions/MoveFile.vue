<template>
  <modal 
    :name="modalName"
    @before-open="beforeOpen"
    styles="font-size: 13px" :reset="true"
    :min-height="450"
    width="35%"  height="500">
    <div class='move-card card' style='min-height: 500px !important'>
      <div class='card-header'>
        <h4>Move file to other directory</h4>
      </div>
      <div class='card-body'>
        <i class="icmn-folder-open big-centered-icon"></i>
        <label class='form-label'>
          Please select directory
        </label>
        <treeselect
          name="moveFile"
          :multiple="false"
          :clearable="true"
          :searchable="true"
          :expanded="true"
          :open-on-click="true"
          :default-expand-level="1"
          :noChildrenText="'empty'"
          :open-on-focus="true"
          :always-open="true"
          :options="treeData"
          :show-count="true"
          :limit="3"
          v-model="moveTo">
            <label slot="option-label" slot-scope="{ node, shouldShowCount, count, labelClassName, countClassName }" 
              :class="labelClassName">
              <i class="fas fa-folder" v-if="node.isBranch" 
                :style="`color: ${textColor}`"></i>
              <i :class="`${node.icon}`" v-if="node.icon"></i>
                &nbsp;{{ node.label }}
              <span v-if="shouldShowCount" 
                :class="countClassName">({{ count }})</span>
            </label>
        </treeselect>
      </div>
       <div class='card-footer pull-right'>
        <a class='btn btn-sm btn-secondary pull-right mt-2 mr-2'
          style='float: right' @click="hideModal()">
          <i class="far fa-times-circle"></i>&nbsp;Close
        </a>
        <a class='btn btn-sm btn-primary pull-right mt-2 mr-2'
          style='float: right'
          @click="moveFile()">
          <i class="fas fa-save"></i>&nbsp;Save
        </a>
        &nbsp;
        </div>
    </div> 
  </modal>
</template>
<script>
import Treeselect from '@riophae/vue-treeselect'
import textColor from '../../mixins/settings'
import settings from '../../mixins/settings'
import currentFolder from '../../mixins/currentFolder'
export default {
  props: ['asset', 'currentFolder'],
  mixins: [settings, currentFolder],
  data() {
    return {
      treeData: [],
      moveTo: null
    }
  },
  components: { Treeselect },
  computed: {
    modalName() {
      return `move-modal-${this.asset.id}`
    }
  },
  methods: {
    hideModal() {
      return this.$modal.hide(this.modalName)
    },
    beforeOpen() {
      $.getJSON(`/api/v1/folders/move_tree/${this.asset.folder_id}`, 
        (jsonChildren) =>{
          this.treeData = [jsonChildren]
      })
    },
    moveFile() {
      $.ajax({
        type: "PATCH",
        url: `/api/v1/file_assets/${this.asset.id}/move`,
        data: {
          folder_id: this.moveTo,
          "_method" : "patch"
        }
      }).done((resp) => {
        this.refresh()
      })
    }
  }
}
</script>
<style scoped>
div.card.move-card {
  min-height: 500px !important;
  height: 500px !important;
}
.big-centered-icon {
  font-size: 124px;
  position: absolute;
  margin-top: 30px !important;
  bottom: 70px;
  left: 0;
  right: 0;
  opacity: 0.2 !important;
  display: flex; /* add */
  justify-content: center; /* add to align horizontal */
  align-items: center; /* add to align vertical */
}
</style>