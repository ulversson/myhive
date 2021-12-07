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
        <a :href="dicomLink" 
          class="cui-github-explore-sort-option btn btn btn-success text-white"
          target="_blank" @click="openBrowser()" 
          v-if="browser !== ''">
          <i class='fas fa-eye'></i>&nbsp;
          WEB BROWSE
        </a>
        <a :href="`/radiology/browse/${dicomName}`" 
          class="cui-github-explore-sort-option btn btn btn-info text-white"
          target="_blank">
          <i class='fas fa-desktop'></i>&nbsp;
          DESKTOP BROWSE
        </a>
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
    dicomName() {
      return this.dicomLink.split("=")[1]
    },
    caseId() {
      return this.$store.state.currentMedicoLegalCaseId
    },
    authHeader() {
     return 'Basic ' + btoa(this.username + ':' + this.password).toString('base64');
    },
    dicomLink() {
      return `https://${this.username}:${this.password}@${this.browser}`
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
      debugger
       $.ajax({
    		url: this.dicomLink,
        headers: { 
          'Authorization': this.authHeader,
          'Access-Control-Allow-Origin' : '*'
        }
			}).done(function() {
				window.open(this.dicomLink, "_blank");
			})
    }
  }
}
</script>