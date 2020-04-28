<template>
  <div class="card" style='margin-bottom: 0'>
    <div class="card-body">
      <h5 class="mb-3 text-default">
      <strong>
        <i class='fa fa-2x fa-briefcase'></i>
        &nbsp;
        ID&nbsp;{{`#${medicoLegalCase.id}` }}
      </strong> 
      </h5>
    <dl class="row">
      <dt class="col-xl-4">Case</dt>
        <dd class="col-xl-8">
          <a href='javascript:void(0)' @click='goPatientTab()'
            style='text-decoration-style: dotted !important'>
            <div class="media align-items-center case-folder" style="cursor: pointer">
              <i class="d-block ui-w-40 rounded-circle fas fa-folder-open fa-2x" 
                :class='`text-${this.textColor(medicoLegalCase.status)}`'>
              </i>
              <div class="media-body flex-basis-auto pl-3" style='font-size: 14px'>
                <div class="name">
                    {{this.patientName}}
                  <i class="fas fa-skull-crossbones text-danger" 
                      v-if='medicoLegalCase.patient.deceased'></i>
                </div>
              </div>
            </div>
          </a>
        </dd>
        <dt class="col-xl-4">Status</dt>
        <dd class="col-xl-8">
          <span class='text-uppercase badge'
            :class='`badge-pill badge-alt badge-${this.textColor(medicoLegalCase.status)}`' 
            style='font-size: 12px'>{{medicoLegalCase.status}}
          </span>
          <span class='text-default' v-if="medicoLegalCase.status === 'settled'" >
            <i class="far fa-clock"></i>&nbsp;
            {{this.parsedDateTime(medicoLegalCase.settled_at)}}
          </span>
          <span class='text-default' v-if="medicoLegalCase.status === 'current'" >
            <i class="far fa-clock"></i>&nbsp;
            {{this.parsedDateTime(medicoLegalCase.started_at)}}
          </span>
        </dd>
        <dt class="col-xl-4">Instructed by</dt>
        <dd class="col-xl-8">
          <span class='badge badge-pill badge-info'  
            style='font-size: 12px'>
            {{medicoLegalCase.instructed_by }}
          </span>
        </dd>
        <dt class="col-xl-4">Created by</dt>
        <dd class="col-xl-8">
          <span class='badge badge-pill badge-secondary' style='font-size: 12px'>
            {{medicoLegalCase.user.first_name }}&nbsp;{{medicoLegalCase.user.last_name }}
          </span>
          &nbsp;
          <span class='text-default'>
            <i class="far fa-clock"></i>&nbsp;
            {{this.parsedDateTime(medicoLegalCase.created_at)}}
          </span>
        </dd>
        <dt class="col-xl-4">Assigned users</dt>
        <dd class="col-xl-8" v-html="this.usersNames(medicoLegalCase.users)"></dd>
        <dt class="col-xl-4" v-if='medicoLegalCase.due_date !== null'>Due date</dt>
        <dd class="col-xl-8" v-if='medicoLegalCase.due_date !== null'>
          {{this.parsedDate(medicoLegalCase.due_date)}}
        </dd>
        <dt class="col-xl-4" v-if='medicoLegalCase.case_summary !== null'>Case Summary</dt>
        <dd class="col-xl-8" v-if='medicoLegalCase.case_summary !== null'>
          {{medicoLegalCase.case_summary}}
        </dd>
        <dt class="col-xl-4" v-if='medicoLegalCase.note !== null'>Note</dt>
        <dd class="col-xl-8" v-if='medicoLegalCase.note !== null'>
          {{medicoLegalCase.note}} 
        </dd>
        <dt class="col-xl-4">Notifications off?</dt>
        <dd class="col-xl-8">
          <toggle-button @change="onChangeEventHandler($attrs.data.id, $event, 'current', this)"
            :font-size="9"
            :labels="{checked: 'YES', unchecked: 'NO'}"
            :width="50"
            disabled
            :value='Boolean(medicoLegalCase.notifications_disabled)'
            :color="{checked: '#28a745', unchecked: '#fb434a', 
            disabled: disabledColor}"/>
        </dd>
      </dl>
    </div>
  </div>
</template>
<script>
import moment from 'moment'
import activeTab from '../../mixins/activeTab'
import globals from '../../mixins/globals'
import shared from '../../mixins/shared'
export default {
  props: ['medicoLegalCase'],
  mixins: [activeTab, globals, shared],
  computed: {
    disabledColor() {
      if (this.medicoLegalCase.notifications_disabled) {
        return '#fb434a'
      } else {
        return '#28a745'
      }
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