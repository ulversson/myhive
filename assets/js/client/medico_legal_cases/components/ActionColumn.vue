<template>
  <div class='actions-mlc' style='font-size: 11px'>
    <a class="btn btn-icon btn-xs btn-outline-primary mr-2 mb-2 btn-rounded" 
      @click='loadCaseDetails($attrs.data.id)'
      data-toggle='tooltip' 
      data-title='Details'>
      <i class="far fa-eye"></i>
    </a>
    <a class="btn btn-icon btn-xs btn-outline-warning mr-2 mb-2 btn-rounded" 
      data-toggle='tooltip' 
      v-if="isAdmin"
      :href="`/medico_legal_cases/${$attrs.data.id}/edit`"
      data-title='Edit'>
      <i class="far fa-edit"></i>
    </a>
    <a class="btn btn-icon btn-xs btn-outline-danger mr-2 mb-2 btn-rounded" 
      v-if="isAdmin"
      data-toggle='tooltip' 
      @click='onMedicoLegalCaseDelete($attrs.data.id)'
      data-title='Delete'>
      <i class="fa fa-trash"></i>
    </a>
    <br/>
    <toggle-button @change="onChangeEventHandler($attrs.data.id, $event, 'current', this)"
      :font-size="9"
      :labels="{checked: 'CURRENT',
      unchecked: 'PENDING'}"
      ref='toggleToCurrent'
      :width="75"
      :class="'mlc-toggle'"
      :v-model='Boolean(toggleValue)'
      :color="{checked: '#28a745', 
        unchecked: '#ffc107', 
        disabled: '#cccccc'
    }" v-if="activeTab === 'pending'"/>
    <toggle-button @change="onChangeEventHandler($attrs.data.id, $event, 'settled', this)"
      :font-size="9"
      :labels="{checked: 'SETTLED',
      unchecked: 'CURRENT'}"
      :width="75"
      ref='toggleToSettled'
      :class="'mlc-toggle'"
      :v-model='Boolean(toggleValue)'
      :color="{checked: '#cccccc', 
        unchecked: '#28a745', 
        disabled: '#cccccc'
    }" v-if="activeTab === 'current'"/>
    <toggle-button @change="onChangeEventHandler($attrs.data.id, $event, '', this)"
      :font-size="9"
      :labels="{checked: '',
      unchecked: 'SETTLED'}"
      :width="75"
      :class="'mlc-toggle'"
      :disabled="true"
      style='cursor: disabled'
      :v-model='Boolean(toggleValue)'
      :color="{checked: '#cccccc', 
        unchecked: '#cccccc', 
        disabled: '#cccccc'
    }" v-if="activeTab === 'settled'"/>
  <tabs :medicoLegalCase="medicoLegalCase" :medicoLegalCaseId="$attrs.data.id"/>
  </div>
</template>
<script>
import UI from '../../../ui'
import activeTab from '../mixins/activeTab'
import shared from '../mixins/shared'

import Tabs from '../components/details/Tabs.vue'
export default {
  props: ['row', 'medicoLegalCase'],
  data() {
    return { 
      toggleValue: false 
    }
  },
  mixins: [activeTab, shared],
  components: {Tabs},
  methods: {
    capitalizedStatus(status) {
      return status.charAt(0).toUpperCase() + status.slice(1)
    },
    loadCaseDetails(caseId) {
      $.ajax({
        url: `/api/v1/medico_legal_cases/${caseId}`
      }).done((jsonResponse) => {
        this.medicoLegalCase = jsonResponse.data
        this.$modal.show(`tabs-modal-${caseId}`)
      })
    },
    onChangeEventHandler(id, event, nextStatus, toggle) {
      this.$swal({
        title: `Change case status to ${nextStatus}?`,
        text: 'This action cannot be reverted',
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#26B4FF',
        confirmButtonText: `<i class='fa fa-check'></i>&nbsp YES`     
        }).then((result) => {
          if (result.value) {
            $.post(`/medico_legal_cases/${id}/status`, {
              id: id, status: nextStatus, "_csrf_token": this.csrfToken
              }, function(jsRes){
                UI.showAndFadeOutFlash(jsRes.message, 'info')
                setTimeout(() => {
                  window.location.reload(true)
                }, 2000)
            })
          } else {
            this.$refs[`toggleTo${this.capitalizedStatus(nextStatus)}`].$data.toggled = false
          }
      })
    },
    onMedicoLegalCaseDelete(caseId) {
      this.$swal({
        title: `Delete this case?`,
        text: 'All corresponding data will be removed',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: 'rgb(251, 67, 74)',
        confirmButtonText: `<i class='fa fa-trash'></i>&nbsp YES`     
        }).then((result) => {
          if (result.value) {
            $.ajax({
              url: `/medico_legal_cases/${caseId}`,
              method: "DELETE",
              data: {id: caseId, "_csrf_token": this.csrfToken}
            }).done( function(jsRes){
              UI.showAndFadeOutFlash(jsRes.message, 'info')
              setTimeout(() => {
                window.location.reload(true)
              }, 2000)
            })
          }
      })
    }
  }
}
</script>