<template>
  <modal 
    name="radiology"
    :min-width="200" :min-height="250"
    :adaptive="true" :scrollable="true"
    :height="'auto'"
    :reset="true"
    @opened="afterOpened" 
    width="50%" >
    <div class='card'>
      <div class='card-header'>
        <span class='cui-utils-title'>Radiology</span>
      </div>
      <div class='card-body'>
        <button class="cui-github-explore-sort-option btn btn-sm btn-success text-white"
          @click="openBrowser()" v-if="browser !== ''">
          <i class='fas fa-eye'></i>&nbsp;
          BROWSE
        </button>
        <Alert message="No imported imaging for this case yet" v-if="browser === ''"/>
        <RadiologyImports :imports="imports" />
      </div>
    </div>
  </modal>
</template>
<script>
import Alert from '../Alert.vue'
import RadiologyImports from './RadiologyImports.vue'
export default {
  components: {
    RadiologyImports, Alert
  },
  data(){
    return {
      imports: [],
      browser: '',
      username: '',
      password: ''
    }
  },
  computed: {
    caseId() {
      return this.$store.state.currentMedicoLegalCaseId
    },
    authHeader() {
     return 'Basic ' + new Buffer(this.username + ':' + this.password).toString('base64');
    }
  },
  methods: {
    loadImports() {
      $.getJSON(`/api/v1/radiology_imports/${this.caseId}`, (jsonResp) => {
        this.imports = jsonResp.data
        this.browser = jsonResp.browser
        this.username = jsonResp.username
        this.password = jsonResp.password
      })
    },
    afterOpened() {
      this.loadImports()
    },
    openBrowser() {
      $.ajax({
    		url: this.browser,
        headers: { 
          'Authorization': this.authHeader,
          'Access-Control-Allow-Origin' : '*'
        }
			}).done(function() {
				window.open(this.browser, "_blank");
			})
    }
  }
}
</script>