<template>
	<div class="form-group">
    <label>
      Please select template
      <span class='required'>*</span>
    </label>
    <v-select label="name" 
      @search="onSearch"
      :value="selectedTemplate"
      @input="setSelected"
      :options="templates"
      :filterable="false">
      <template slot="no-options">
        type to search select template...
      </template>
      <template v-slot:option="option">
        <hr v-if="isFirst(option)" />
        <i class='fal fa-file-medical'></i>&nbsp;
        {{ option.name }}&nbsp;
        <span class='text-muted'>{{ hint(option) }}</span>
      </template>
    </v-select>
  </div>
</template>
<script>
export default {
	data() {
		return {
			selectedTemplate: null,
			templates: []
		}
	}, 
  computed: {
    tabs() {
      return this.$parent.$refs.tabs
    }
  },
	methods: {
    isFirst(option) {
      return this.templates.findIndex(o => o.code === option.code) === 1
    },
    hint(option) {
      if (option.code == 'lt') return 'Letter Builder'
      return 'Report Builder'
    },
		onSearch(search, loading) {
      this.tabs.$set(this.tabs, 'reportSectionContents', {})
			loading(true)
      $.ajax({
        url: `/api/v1/reports?q=${search}`,
        type: 'GET'
      }).done((jsRes) => {
        this.$nextTick(() => {
          this.templates = jsRes.data
          loading(false)
        })
        this.tabs.populateSectionContents()
      })
		},
		setSelected(value) {
			this.selectedTemplate = value
			this.$root.$emit('selectedTemplate', value)
    },
	}
}
</script>
<style type="text/css">
  hr {
  margin-top: 1rem;
  margin-bottom: 1rem;
  border: 0;
  border-top: 1px solid rgba(0, 0, 0, 0.1);
}
</style>