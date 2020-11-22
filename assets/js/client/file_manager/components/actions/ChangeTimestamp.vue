<template>
  <modal 
    :name="modalName"
    styles="font-size: 13px" 
    :reset="true"
    :min-height="250"
    width="20%"  height="250">
    <div class='card'>
      <div class='card-header'>
        {{ `Change ${itemType} timestamp` }}
      </div>
      <div class="card-body">
        <datetime type="datetime"
          :input-class="'form-control'"
           v-model="startDate">
            <label for="startDate" slot="before">Timestamp</label>
            <span class="description help-block text-muted" slot="after">
              Please click to select time
            </span>
            <template slot="button-cancel">
              <i class='fas fa-ban'></i>
              Cancel
            </template>
            <template slot="button-confirm">
              <i class='fas fa-check'></i>
              Confirm
            </template>
        </datetime>
      </div>  
      <div class='card-footer'>
        <div class='buttons' style='float: right'>
          <a class='btn btn-sm btn-secondary pull-right mt-2'
            @click="hideModal()">
            <i class="far fa-times-circle"></i>&nbsp;Close
          </a>
          <a class='btn btn-sm btn-primary pull-right mt-2'
            @click="updateTimeStamp()">
            <i class="fas fa-save"></i>&nbsp;Save
          </a>
        </div>
      </div>
    </div>
  </modal>

</template>
<script>
import { Datetime } from 'vue-datetime'
import currentFolder from '../../mixins/currentFolder'
export default {
  mixins: [currentFolder],
  methods: {
    updateTimeStamp() {
      $.ajax({
        type: "PATCH",
        data: this.updateData,
        url: `api/v1/timestamp`
      }).done((r) => {
        if (this.itemType === 'file') {
          this.$parent.refresh()
        } else {
          this.$modal.hide(this.modalName)
          this.$parent.managerComponent.setCurrentFolder(this.item.parent_id)
        }
      })//
    },
    hideModal() {
      this.$modal.hide(this.modalName)
    }
  },
  computed: {
    modalName() {
      return `change-timestamp-${this.item.id}`;
    },
    updateData() {
      return {
        id: this.item.id,
        type: this.itemType,
        date: this.startDate
      }
    }
  },
  components: { Datetime },
  props: ['item', 'itemType', 'startDate']
}
</script>