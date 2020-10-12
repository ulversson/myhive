<template>
  <div class='time-entry-form'>
    <div class='alert alert-warning' v-if="$parent.formVisible && showOtherTrackingAlert()">
      <i class='fa fa-2x fa-exclamation-circle'></i>&nbsp;
      This time is currently being recorded for other case. 
      <strong>{{recordedCaseName()}}</strong>
    </div>
    <form class='form-horizontal' id='new-entry-form'>
      <input type='hidden' :value="medicoLegalCaseId" />
      <div class="form-row" v-if="isAdmin">
        <div class='form-group col-md-8'
        :class="userError !== null ? 'is-invalid':''">
        <label class='form-label'>
          Select user
          <span class='required'>*</span>
        </label>
        <select class="form-control" 
          id="user-ts-search"
          style="100% !important"
          v-if="isAdmin"
          @change='serializeAndSaveFormLocal'
          v-model="selectedUserId"
          placeholder="Select user for this time entry">
          <option v-for="user in users" 
            :key="user.id" 
            :value="user.id">
            {{user.text}}
          </option>
        </select>
        <span class='invalid-feedback user-error' v-if="userError !== null">
          You must select at least one user
        </span>
        <small class='text-muted help-block'>
          Time entry will be created on behalf of selected user
        </small>
        </div>
      </div>
      <div class="form-row">
        <div class="form-group col-md-2">
          <label class="form-label">Date
            <span class='required'>*</span>
          </label>
          <date-picker 
            style="width: 130px"
            v-model="entryDateDefault"
            @change="serializeAndSaveFormLocal"
            value-type="format"
            :value="entryDateDefault"
            format="DD/MM/YYYY">
          </date-picker>
        </div>
        <div class="form-group col-md-2"
          :class="startTimeError !== null ? 'is-invalid' : ''">
          <label class="form-label">Start time
            <span class='required'>*</span>
          </label>
          <vue-timepicker 
            input-width="120px"
            :class="startTimeError !== null ? 'is-invalid' : ''"
            manual-input
            :close-on-complete="true"
            @change="startTimeError = null"
            @close="serializeAndSaveFormLocal"
            @blur="serializeAndSaveFormLocal"
            v-model="startTime">
          </vue-timepicker>  
          <span class='invalid-feedback start-time-error' v-if="startTimeError !== null">
            {{ startTimeError }}
          </span>
        </div>
        <div class="form-group col-md-2"
          :class="endTimeError !== null ? 'is-invalid' : ''">
          <label class="form-label">End time
            <span class='required'>*</span>
          </label>
          <vue-timepicker 
            input-width="120px"
            manual-input
            :close-on-complete="true"
            @close="serializeAndSaveFormLocal"
            @blur="serializeAndSaveFormLocal"
            @change="endTimeError = null"
            :class="endTimeError !== null ? 'is-invalid' : ''"
            v-model="endTime">
          </vue-timepicker> 
          <span class='invalid-feedback start-time-error' 
            v-if="endTimeError != ''">
            {{ endTimeError }}
          </span> 
        </div>
        <div class="form-group col-md-2">
          <label class="form-label">Note</label>
          <input type='text' 
            style='height: 34px !important'
            @blur='serializeAndSaveFormLocal'  
            class='form-control' 
            v-model="note"/>  
        </div>
        <div class='form-group col-md-4 mt-5'>
          <h3 style='font-size: 15px' class='form-label badge badge-pill badge-secondary'>
            Duration: {{getDuration()}}
          </h3>
        </div>  
      </div>
      <div class='form-row col-8'>
        <span class='required'>*</span>
        <textarea placeholder='Describe your task here...' 
          @blur='serializeAndSaveFormLocal' 
          @change="descriptionError = null" 
          v-model='description' 
          class='form-control' 
          style='resize: none' 
          rows="3" 
          :class=" descriptionError !== null ? 'is-invalid' : ''">
        </textarea>
        <span class='invalid-feedback description-error' 
          v-if="descriptionError !== null">
          {{ descriptionError }}
        </span>
      </div>  
      <br/>
      <div class='form-row col-6'>
        <a class="btn btn-primary btn-sm text-white" style='cursor: pointer'
          @click='saveInDatabase'>
          <i class='fas fa-save'></i>&nbsp;SAVE
        </a>
        &nbsp;
        <a class="btn btn-secondary btn-sm text-white" style='cursor: pointer' 
          @click='cancelTracking'>
          <i class='fas fa-ban'></i>&nbsp;CANCEL
        </a>
      </div>
  </form>  
  </div>
</template>
<script>
import Vue from 'vue'
import DatePicker from 'vue2-datepicker'
import VueTimepicker from 'vue2-timepicker'
import moment from 'moment'
import humanizeDuration from 'humanize-duration'
import roomManager from '../../chat/mixins/roomManager'
import shared from '../../medico_legal_cases/mixins/shared'
import chatUser from '../../chat/mixins/chatUser'
import serialization from '../mixins/serialization'
import 'vue2-datepicker/index.css'
export default {
  created() {
    UI.setup()
    this.loadUsers()
  },
  mixins: [shared, chatUser, serialization],
  updated() {
    this.$root.$emit('show-recording', this.isFormSerialized())
  },
  data() {
    return {
      submit: false, 
      users: [],
      selectedUserId: this.userId,
      entryDate: null,
      startTime: moment().format('HH:mm'),
      startTimeError: null,
      endTime: null,
      endTimeError: null,
      note: "",
      description: "",
      userError: null,
      descriptionError: null
    }
  },
  computed: {
    selectName() {
      return 'select#user-ts-search'
    },
    dateFormat() {
      return "DD/MM/YYYY HH:mm"
    },
    medicoLegalCaseId() {
      return this.$store.state.currentMedicoLegalCaseId
    },
    entryDateDefault: {
      get() {
        return this.entryDate || this.nowDate
      },
      set(val) {
        this.entryDate = val
      }
    },
    nowDate() {
      return moment().utc().format('DD/MM/YYYY')
    },
    ownerId() {
      if (this.selectedUserId) {
        return this.selectedUserId
      } else {
        return this.userId
      }
    },
    entryDateWithStartTime() {
      let stringDate = `${this.entryDateDefault} ${this.startTime}`
      return moment.utc(stringDate, this.dateFormat).format()
    },
    entryDateWithEndTime() {
      let stringDate = ''
      if (!this.endTime) return ''
      if (typeof this.endTime === 'object') {
        stringDate = `${this.entryDateDefault} ${this.endTime.HH}:${this.endTime.mm}`
      } else {
        stringDate = `${this.entryDateDefault} ${this.endTime}`
      }
      return moment.utc(stringDate, this.dateFormat).format()
    }
  },
  methods: {
    formData() {
      return {
        time_entry: {
          description: this.description,
          medico_legal_case_id: this.medicoLegalCaseId,
          note: this.note,
          entry_date: this.entryDateDefault,
          owner_id: this.ownerId,
          start_date: this.entryDateWithStartTime,
          end_date: this.entryDateWithEndTime,
          patient: $("[data-case-id]").html()
        }
      }
    },
    loadUsers() {
      $.getJSON(`/api/v1/users/all`, (jsonRes) => {
        jsonRes.forEach((item, index) => {
          this.users.push({
            text: `${item.first_name} ${item.last_name}`,
            id: item.id      
          })
        })
      })
    },
    resetForm() {
      this.submit = false
      this.startTime = moment().format('HH:mm')
      this.endTime = null
      this.entryDate = null
      this.description = null
      this.note = null
      this.selectedUserId = this.userId
      this.startTimeError = null
      this.endTimeError = null
      this.descriptionError = null
      $("input.display-time:last").val('')
    },
    saveInDatabase() {
      this.submit = true
      let vm = this
      debugger
      $.post(`/api/v1/time_sheet`, this.formData(), (jsonRes) => {
        this.$parent.formVisible = false
        Vue.nextTick(() => {
          this.$parent.$refs.table.$refs["time-sheet"].refresh()
        })
      }).catch((err) => {
        let jsonError = JSON.parse(err.responseText)
        if (jsonError.errors.hasOwnProperty('description')) {
          this.descriptionError = jsonError.errors.description.join(', ')
        }
        if (jsonError.errors.hasOwnProperty('start_date')) {
          this.startTimeError  = jsonError.errors.start_date.join(', ')
        }
        if (jsonError.errors.hasOwnProperty('end_date')) {
          this.endTimeError  = jsonError.errors.end_date.join(', ')
        }
        if (jsonError.errors.hasOwnProperty('owner_id')) {
          this.userError  = jsonError.errors.owner_id.join(', ')
        }
      })
    },
    getDuration() {
      if (this.startTime && this.endTime) {
        let startTime = moment.utc(this.entryDateWithStartTime)
        let endTime = moment.utc(this.entryDateWithEndTime)
        if (!endTime.isAfter(startTime)) {
          endTime = endTime.add(1, 'days');
        }
        let duration = endTime.diff(startTime, 'miliseconds')
        let durationAsText = humanizeDuration(duration)
        return durationAsText
      }
    },
    cancelTracking() {
      this.$swal({
        title: 'Are you sure?',
        text: 'Current entry will be rejected',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Yes, cancel it!',
        position: 'top',
        heightAuto: false, 
        customClass: 'sweetalert-lg',
        width: 550,
        target: document.querySelector('form#new-entry-form'),
        cancelButtonText: 'No, keep it'
      }).then((result) => {
        if (result.value) {
          this.formVisible = false
          this.$parent.formVisible = false
          this.clearSavedForm()
          this.$nextTick(() => {
            this.resetForm()
          })
        }
      })
    },
    showOtherTrackingAlert() {
      let deserializedForm = this.deserializeForm()
      if (!deserializedForm) return false
      let canShow = this.isFormSerialized && deserializedForm.medico_legal_case_id !== this.medicoLegalCaseId
      return canShow
    },
    recordedCaseName() {
      let deserializedForm = this.deserializeForm()
      if (!deserializedForm) return ""
      return deserializedForm.patient
    },
  },
  components: { VueTimepicker }
}
</script>
<style>
input.display-time {
  height: 34px !important
}
span.is-invalid input,
.is-invalid .select2-selection.select2-selection--single {
  border: 1px solid #dc3545 !important;
}
.is-invalid .invalid-feedback {
  display: block !important;
}
form#new-entry-form .swal2-container {
  z-index: 99999999999 !important;
  min-height: 300px !important;
  min-width: 400px !important;
  width: 510px !important;
}
form#new-entry-form .swal2-popup {
  height: 320px !important;
  width: 510px !important;
}

</style>