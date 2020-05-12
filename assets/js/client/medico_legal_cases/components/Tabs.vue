<template>
  <div id='mlc-tabs' class='mt-5'>
    <ul class="nav nav-tabs mb-4" role="tablist">
    <li class="nav-item tabs-pending">
      <a class="nav-link" 
        :class="activeTab === 'pending' ? 'active': ''"
        @click="setActiveTab('pending')"
        href="#pending" data-toggle="tab" data-target="#pending" role="tab">
        <i class="fa fa-user-clock"></i>
        Pending
      </a>
    </li>
     <li class="nav-item tabs-current">
      <a class="nav-link" href="#current" 
        :class="activeTab === 'current' ? 'active': ''"
        @click="setActiveTab('current')"
        data-toggle="tab" data-target="#current" role="tab">
        <i class="fas fa-clock"></i>
        Current
      </a>
    </li>
    <li class="nav-item tabs-settled">
      <a class="nav-link" href="#settled" 
        :class="activeTab === 'settled' ? 'active': ''"
        @click="setActiveTab('settled')"
        data-toggle="tab" data-target="#settled" role="tab">
        <i class="fas fa-check"></i>
        Settled
      </a>
    </li>
    </ul>
    <div class="tab-content">
      <div class="tab-pane"         
        :class="activeTab === 'pending' ? 'active': ''"
        id="pending">
        <table-list :tab="'pending'" ref='tabPending'/>
      </div>
      <div class="tab-pane" 
        :class="activeTab === 'current' ? 'active': ''"
        id="current">
        <table-list :tab="'current'" ref='tabCurrent'/>
      </div>
      <div class="tab-pane" 
        :class="activeTab === 'settled' ? 'active': ''"
        id="settled">
        <table-list :tab="'settled'" ref='tabSettled'/>
      </div>
    </div>
  </div>
</template>
<script>
import TableList from './TableList.vue'
import { Event } from 'vue-tables-2'
import settings from '../../file_manager/mixins/settings'
export default {
  mixins: [settings],
  created() {
    this.loadSettings()
    $(`a[href='#${this.defaultTab}']`).click()
    let self = this
    Event.$on('vue-tables.loaded', () => {
      $("[data-toggle='tooltip").tooltip()
      let tab = window.location.hash.replace('#','')
      if (tab === "") tab = this.defaultTab
      this.setActiveTab(tab)
      UI.goToTab()
      this.clearFilterPlaceholder()
    })
  },
  data() { 
   return { activeTab: this.defaultTab}
  },
  components: {
    TableList
  },
  methods: {
    setActiveTab(tab) {
      this.activeTab = tab
    },
    clearFilterPlaceholder() {
      $(".table-mlc .VueTables__filters-row input").attr('placeholder','')
    }
  }
}
</script>