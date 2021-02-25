<template>
  <div class="form-group">
    <label>
      Select expert
      <span class='required'>*</span>
    </label>
    <v-select label="name" 
      @search="onSearch"
      :value="selectedUser"
      @input="setSelected"
      :class="hasSelectError ? 'has-danger' : ''"
      :options="users"
      :filterable="false">
      <template slot="no-options">
        type to search users...
      </template>
      <template v-slot:option="option">
        <i class='fal fa-user'></i>&nbsp;
        {{ option.name }}&nbsp;
      </template>
    </v-select>
    <span class='help-block' v-if="hasSelectError">
      cannot be blank
    </span>
  </div>
</template>
<script>
import Users from '../../../users.js'
export default {
  props: ['submit'],
  data() {
    let firstAndLast = Users.currentUserName().split(" ")
    return {
      selectedUser: {
        id: Users.currentUserId(),
        name: Users.currentUserName(),
        first_name: firstAndLast[0],
        last_name: firstAndLast[1]
      },
      users: []
    }
  }, 
  methods: {
    setSelected(value) {
      this.selectedUser = value
      this.$parent.loadDraft()
    },
    onSearch(search, loading) {
      loading(true)
      $.ajax({
        url: `/api/v1/users/search?q=${search}`,
        type: 'GET'
      }).done((jsRes) => {
        this.$nextTick(() => {
          this.users = jsRes.data
          loading(false)
        })
      })
    }
  },
  computed: {
    hasSelectError() {
      return this.selectedUser === null && this.submit
    },
    userId() {
      return Users.currentUserId()
    }
  },
}
</script>
<style>
  .v-select.has-danger  {
    border: 1px solid #fb434a !important;
    border-color: #fb434a !important;
  }
</style>