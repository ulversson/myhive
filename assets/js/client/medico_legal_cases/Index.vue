<template>
  <div id='dashboard-cases'>
    <a class="btn btn-sm btn-primary ml-2" 
      href='/medico_legal_cases/new'
      id='add-new-user'>Add New&nbsp;
      <i class="fa fa-briefcase"></i>
    </a>
    <tabs ref='tabs'/>
  </div>  
</template>
<script>
import Tabs from './components/Tabs.vue'
export default {
  components: {
    Tabs
  }
}
</script>