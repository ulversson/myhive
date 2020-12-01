<template>
  <div class="form-group"
    :class="[
      isFullWidth ? 'col-12' : 'col-6',
      hasSelectError ? 'has-danger' : ''
    ]">
    <label>
      {{variable.name}}
      <span class='required'>*</span>
    </label>
    <v-select label="name" 
      @search="onSearch"
      :value="selectedExpert"
      @input="setSelected"
      :class="hasSelectError ? 'has-danger' : ''"
      :options="experts"
      :filterable="false">
      <template slot="no-options">
        type to search users...
      </template>
      <template v-slot:option="option">
        <i class='fas fa-user'></i>&nbsp;
        {{ option.name }}&nbsp;
      </template>
    </v-select>
    <span class='help-block' v-if="hasSelectError">
      cannot be blank
    </span>
  </div>
</template>
<script>
import variable from '../mixins/variable'
export default {
  data() {
    return {
      selectedExpert: null,
      experts: []
    }
  }, 
  methods: {
    setSelected(value) {
      this.selectedExpert = value
    },
    onSearch(search, loading) {
      loading(true)
      $.ajax({
        url: `/api/v1/users/search?q=${search}`,
        type: 'GET'
      }).done((jsRes) => {
        this.$nextTick(() => {
          this.experts = jsRes.data
          loading(false)
        })
      })
    }
  },
  computed: {
    hasSelectError() {
      return this.selectedExpert === null && this.submit
    }
  },
  mixins: [variable]
}
</script>
<style>
  .v-select.has-danger  {
    border: 1px solid #fb434a !important;
    border-color: #fb434a !important;
  }

</style>