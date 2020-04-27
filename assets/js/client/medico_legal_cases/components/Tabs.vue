<template>
  <div id='mlc-tabs' class='mt-5'>
    <ul class="nav nav-tabs mb-4" role="tablist">
    <li class="nav-item tabs-pending">
      <a class="nav-link active" 
        @click="setActiveTab('pending')"
        href="javascript: void(0);" data-toggle="tab" data-target="#pending" role="tab">
        <i class="fa fa-user-clock"></i>
        Pending
      </a>
    </li>
     <li class="nav-item tabs-current">
      <a class="nav-link" href="javascript: void(0);" 
        @click="setActiveTab('current')"
        data-toggle="tab" data-target="#current" role="tab">
        <i class="fas fa-clock"></i>
        Current
      </a>
    </li>
    <li class="nav-item tabs-settled">
      <a class="nav-link" href="javascript: void(0);" 
        @click="setActiveTab('settled')"
        data-toggle="tab" data-target="#settled" role="tab">
        <i class="fas fa-check"></i>
        Settled
      </a>
    </li>
    </ul>
    <div class="tab-content">
      <div class="tab-pane active" id="pending">
        <table-list :tab="'pending'" ref='tabPending'/>
      </div>
      <div class="tab-pane" id="current">
        <table-list :tab="'current'" ref='tabCurrent'/>
      </div>
      <div class="tab-pane" id="settled">
        <table-list :tab="'settled'" ref='tabSettled'/>
      </div>
    </div>
  </div>
</template>
<script>
import TableList from './TableList.vue'
export default {
  data() { 
   return { activeTab: 'pending'}
  },
  components: {
    TableList
  },
  methods: {
    setActiveTab(tab) {
      this.activeTab = tab
    }
  }
}
</script>