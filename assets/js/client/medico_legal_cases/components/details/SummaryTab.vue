<template>
  <div class="card">
      <div class="card-body">
        <h5 class="mb-3 text-black">
          <strong>Case ID #{{medicoLegalCase.id}}</strong>
        </h5>
        <dl class="row">
          <dt class="col-xl-3">Case</dt>
          <dd class="col-xl-9">
            <a href='javascript:void(0)' 
              @click='goPatientTab()'
              style='text-decoration-style: dotted !important'>
              <i class="fas fa-skull-crossbones text-dark" 
                v-if='medicoLegalCase.patient.deceased'></i>
              <div class="media align-items-center case-folder" style="cursor: pointer">
                <i class="d-block ui-w-40 rounded-circle fas fa-folder-open fa-2x" 
                  :class='`text-${this.textColor(medicoLegalCase.status)}`'>
                </i>
                <div class="media-body flex-basis-auto pl-3" style='font-size: 14px'>
                  <div class="name">{{this.patientName}}</div>
                </div>
              </div>
            </a>
          </dd>
          <dt class="col-xl-3">Status</dt>
          <dd class="col-xl-9">
            <span class='text-uppercase badge'
             :class='`badge-pill badge-${this.textColor(medicoLegalCase.status)}`' 
             style='font-size: 12px'>{{medicoLegalCase.status}}</span>
          </dd>
          <dt class="col-xl-3">Instructed by</dt>
          <dd class="col-xl-9">
            <span class='badge badge-pill badge-info'  
              style='font-size: 12px'>
              {{medicoLegalCase.instructed_by }}
            </span>
          </dd>
          <dt class="col-xl-3">Created by</dt>
          <dd class="col-xl-9">
            <span class='badge badge-pill badge-secondary' style='font-size: 12px'>
              {{medicoLegalCase.user.first_name }}&nbsp;{{medicoLegalCase.user.last_name }}
            </span>
            &nbsp;
            <span class='text-info'>{{this.parsedDateTime(medicoLegalCase.created_at)}}</span>
          </dd>
          <dt class="col-xl-3">Assigned users</dt>
          <dd class="col-xl-9" v-html="this.usersNames(medicoLegalCase.users)"></dd>
          <dt class="col-xl-3" v-if='medicoLegalCase.due_date !== null'>Due date</dt>
          <dd class="col-xl-9" v-if='medicoLegalCase.due_date !== null'>
            {{this.parsedDate(medicoLegalCase.due_date)}}
          </dd>
          <dt class="col-xl-3" v-if='medicoLegalCase.case_summary !== null'>Case Summary</dt>
          <dd class="col-xl-9" v-if='medicoLegalCase.case_summary !== null'>
            {{medicoLegalCase.case_summary}}
          </dd>
          <dt class="col-xl-3" v-if='medicoLegalCase.note !== null'>Note</dt>
          <dd class="col-xl-9" v-if='medicoLegalCase.note !== null'>
            {{medicoLegalCase.note}} 
          </dd>
          <dt class="col-xl-3">Notifications off?</dt>
          <dd class="col-xl-9">
            <toggle-button @change="onChangeEventHandler($attrs.data.id, $event, 'current', this)"
              :font-size="9"
              :labels="{checked: 'YES',
              unchecked: 'NO'}"
              :width="50"
              disabled
              :value='Boolean(medicoLegalCase.notifications_disabled)'
              :color="{checked: '#28a745', 
              unchecked: '#fb434a', 
              disabled: disabledColor
            }"/>
          </dd>
        </dl>
      </div>
    </div>
</template>
<script>
import moment from 'moment'
import activeTab from '../../mixins/activeTab'
import globals from '../../mixins/globals'
export default {
  props: ['medicoLegalCase'],
  mixins: [activeTab, globals],
  computed: {
    disabledColor() {
      if (this.medicoLegalCase.notifications_disabled) {
        return '#fb434a'
      } else {
        return '#28a745'
      }
    },
    patientName() {
      return `${this.medicoLegalCase.patient.first_name} ${this.medicoLegalCase.patient.last_name}`
    }
  },
  methods: {
    goPatientTab() {
      $('[data-target="#patient"]').click()
    },
    usersNames(users) {
      return users.map((user) => {
        return `<span class="badge badge-pill badge-secondary" style='font-size: 12px'>
        ${user.first_name} ${user.last_name}</span>`
      }).join("&nbsp;")
    }
  }
}
</script>