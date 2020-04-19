<template>
  <div id='dashboard-cases'>
    <a class="btn btn-sm btn-primary ml-2" 
      href='/medico_legal_cases/new'
      id='add-new-user'>Add New&nbsp;
      <i class="fa fa-briefcase"></i>
    </a>
    <table-list/>
  </div>  
</template>
<script>
import TableList from './components/TableList.vue'
export default {
  components: {
    TableList
  }
}
</script>