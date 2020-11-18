<template>
  <form>
    <div class="row">
      <div class='alert alert-danger col-lg-12 col-xs-12'
        v-if="showFieldsError">
        One of the fields below other than date needs to be present
      </div>
      <div class="col-lg-4 col-xs-12">
        <div class="form-group">
          <div class="input-group">
           <datetime type="datetime"
            style="width: 100%"
            @close="submit = false"
            :input-class="showConsultationDateError ? 'form-control is-invalid' : 'form-control'"
            :class="showConsultationDateError ? 'is-invalid' : ''"
            v-model="consultationDate">
              <label for="startDate" slot="before">Consultation date</label>
              <label class="description  text-muted" slot="after">
                Please click to select time
              </label>
              <template slot="button-cancel">
                <i class='fas fa-ban'></i>
                Cancel
              </template>
              <template slot="button-confirm">
                <i class='fas fa-check'></i>
                Confirm
              </template>
            </datetime>
            <span class='invalid-feedback start-time-error' 
              v-if="consultationDateError !== null">
              {{consultationDateError}}
            </span>
          </div>
        </div>
      </div>
      <div class="col-lg-4 col-xs-12">
        <div class="form-group">
          <label>Blood pressure</label>
          <div class="input-group">
            <div class="input-group-prepend">
              <div class="input-group-text">
                <i class="fas fa-tint"></i>
              </div>
            </div>
            <input class="input-error form-control" type="text" 
            v-model="bloodPressure"/>
            <div class="input-group-append">
              <div class="input-group-text">
                mmHg
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-lg-4 col-xs-12">
        <div class="form-group">
          <label>Temperature</label>
          <div class="input-group">
            <div class="input-group-prepend">
              <div class="input-group-text">
                <i class="fas fa-thermometer-half"></i>              
              </div>
            </div>
            <input class="input-error form-control" 
              v-model="temperature" type="number">
            <div class="input-group-append">
              <div class="input-group-text">
                &#8451;
              </div>
            </div>
          </div>
        </div>
    </div>
  </div>
  <div class="row">
      <div class="col-lg-4 col-xs-12">
        <div class="form-group">
          <label>Weight</label>
          <div class="input-group">
            <div class="input-group-prepend">
              <div class="input-group-text">
                <i class="fas fa-balance-scale"></i>
              </div>
            </div>
            <input class="input-error form-control" 
              v-model="weight" type="number"/>
            <div class="input-group-append">
              <div class="input-group-text">
                kg
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-lg-4 col-xs-12">
        <div class="form-group">
          <label>Height</label>
          <div class="input-group">
            <div class="input-group-prepend">
              <div class="input-group-text">
                <i class="fas fa-arrow-up"></i>
              </div>
            </div>
            <input class="input-error form-control" type="number" 
            v-model="height"/>
            <div class="input-group-append">
              <div class="input-group-text">
                cm
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-lg-4 col-xs-12">
        <div class="form-group">
          <label>BMI</label>
          <div class="input-group">
            <div class="input-group-prepend">
              <div class="input-group-text">
                <i class="fa fa-dashboard"></i>
              </div>
            </div>
            <input class="input-error form-control" type="number" disabled
            v-model="bmi" />
            <div class="input-group-append">
              <div class="input-group-text">
                kg/m2
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-lg-6 col-lg-12">
        <div class="form-group">
          <label>Note</label>
          <div class="input-group">
            <textarea class='form-control' 
              v-model="note" style='resize:none' rows="3"></textarea>
            </div>
          </div>
        </div>
    </div>
    <div class="row">
      <div class="col-lg-6 col-lg-12">
        <label class="cui-utils-control cui-utils-control-checkbox">COVID-19 Consent?
            <input name="covid_consent" type="checkbox" value="true" v-model="covid19Consent">         
             <span class="cui-utils-control-indicator"></span>
        </label>
      </div>
    </div>
      <a class="btn btn-sm btn-secondary pull-right mt-2 mr-2"
        style="float: right; margin-right: 0px !important;margin-bottom: 20px !important;"
        @click="hideConsultationForm()">
        <i class="far fa-times-circle"></i>&nbsp;Close
      </a>
      <a class="btn btn-sm btn-primary pull-right mt-2 mr-2"
        style="float: right; margin-bottom: 20px !important;"
        @click="saveConsultation()">
        <i class="fas fa-save"></i>&nbsp;Save
      </a>
  </form>
</template>
<script>
import { Datetime } from 'vue-datetime'
import number from '../../mixins/number'
export default {
  mixins: [number],
  components: { Datetime },
  methods: {
    hideConsultationForm() {
      this.$root.$emit('toggleConsultation', false)
    },
    saveConsultation() {
      this.submit = true
      $.ajax({
        type: "POST",
        data: this.postData,
        url: '/api/v1/patient_consultation'
      }).done(() => {
        this.hideConsultationForm()
      }).catch((err) => {
        this.$swal("Error", "Unable to save this consultation", "error")
      })
    }
  },
  computed: {
    bmi(){
      if (this.isNumeric(this.weight) && this.isNumeric(this.height)) {
        var ht2 = parseFloat(this.height/100) * parseFloat(this.height/100)
        var bmi =  parseFloat(this.weight/ht2)
        return bmi.toFixed(2)
      } else {
        'Ht & Wt mandatory!'
      }
    },
    postData() {
      return {
        "consultation" : {
          "consultation_date" : this.consultationDate,
          "blood_pressure" : this.bloodPressure,
          "temperature" : this.temperature,
          "weight" : this.weight,
          "height" : this.height,
          "bmi" : this.bmi,
          "note" : this.note,
          "medico_legal_case_id" : window.localStorage
            .getItem('currentMedicoLegalCaseId'),
          "covid_consent": this.covid19Consent
        }
      }
    },
    consultationDateError() {
      return 'cannot be empty'
    },
    showConsultationDateError() {
      return this.submit && this.consultationDateError != null 
    },
    showFieldsError() {
      return this.submit && (!this.bloodPressure && !this.temperature && !this.weight && !this.height && !this.note)
    }
  },
  data(){
    return {
      showNewConsultationForm: false,
      submit: false,
      consultationDate: null,
      bloodPressure: null,
      temperature: null,
      weight: null,
      height: null,
      note: null,
      covid19Consent: false
    }
  }
};
</script>
