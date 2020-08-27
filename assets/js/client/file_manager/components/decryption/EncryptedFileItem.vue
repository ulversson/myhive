<template>
  <div class="form-group row">
    <label class="col-md-4 col-form-label" :for="asset.id">
      <i :class="asset.icon" :style="iconColor"></i>
        &nbsp;
        {{ asset.name }}
      <i class='fas fa-lock' :style="iconColor"></i>
    </label>
      <div class="col-md-8">
        <div class="input-group">
        <input type="text" class="form-control encrypted-item" 
          placeholder="Enter file password" 
          v-model="password"
          :id="asset.id">
        <div class="input-group-append">
          <div class="input-group-text">
            <i class="icmn-key"></i>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  props: ['asset', 'color'],
  data() {
    return {
      password: ""
    }
  },
  computed: {
    iconColor() {
      return `color: ${this.color} !important;`
    }
  }
}
</script>