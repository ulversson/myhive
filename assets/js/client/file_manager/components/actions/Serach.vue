<template>
    <form action="" class="search-form">
      <div class="form-group has-feedback">
        <label for="search" class="sr-only">Search</label>
        <input type="text" v-model="search" 
          class="form-control" name="search" 
          id="search" placeholder="search">
        <span class="fas fa-search form-control-feedback"></span>
      </div>
  	</form>
</template>
<script>
import currentFolder from '../../mixins/currentFolder'
export default {
  props: ['currentFolder'],
  mixins: [currentFolder],
  data() {
    return {
      search: ""
    }
  }
}
</script>