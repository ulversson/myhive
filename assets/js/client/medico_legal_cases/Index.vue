<template>
  <div id='dashboard-cases'>
    <a class="btn btn-sm btn-primary ml-2" 
      v-if="isAdmin"
      href='/medico_legal_cases/new'
      id='add-new-user'>Add New&nbsp;
      <i class="fa fa-briefcase"></i>
    </a >
    <tabs ref='tabs'/>
  </div>  
</template>
<script>
import Tabs from './components/Tabs.vue'
import shared from './mixins/shared'
export default {
  mixins: [shared],
  components: {
    Tabs
  }
}
</script>