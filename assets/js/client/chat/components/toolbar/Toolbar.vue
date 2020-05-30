<template>
  <div class="card-header">
    <div class="pull-right">
      <div class="dropdown mt-2 d-inline-block pull-right" style='float: right'>
        <a href="" class="dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
          <i class="icmn-database mr-2"></i>
          <span class="hidden-lg-down">Actions</span>
          <span class="caret"></span>
        </a>
        <div class="dropdown-menu dropdown-menu-right" role="menu">
          <div class="dropdown-header">Chat Rooms</div>
          <a class="dropdown-item" href="javascript:void(0)">Create</a>
          <a class="dropdown-item" href="javascript:void(0)">Join</a>
          <a class="dropdown-item" href="javascript:void(0)">Invite</a>
          <div class="dropdown-header">Inactive</div>
          <a class="dropdown-item" href="javascript:void(0)">Marketing</a>
          <div class="dropdown-divider"></div>
          <a class="dropdown-item" href="javascript:void(0)"><i class="dropdown-icon icmn-cog"></i> Settings</a>
        </div>
      </div>
    </div>
    <h4 class="mt-1 mb-1 text-black">
      <strong>{{ conversation.title }}</strong>
    </h4>
  </div>
</template>
<script>
export default {
  computed: {
    conversation() {
      return this.$store.state.conversation
    }
  }
}
</script>