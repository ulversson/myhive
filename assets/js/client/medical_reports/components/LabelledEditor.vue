<template>
  <div class="editor">
    <div class='labelled mb-3'
      v-for="(repSec, i) in items">
      <label v-if="section.is_letter_visible">
        <strong>{{letter}}{{i+1}}</strong>
      </label>
      <div class='row time-date'
        v-if="hasTimestamp(index)">
        <div class='col-4 form-group'>
          <label class="form-label">
            <strong>Date</strong>
          </label>
          <date-picker 
            style="width: 130px"
            @change="setDates()"
            value-type="format"
            v-model="dates[i]"
            :ref="`date-${section.id}`"
            format="DD/MM/YYYY">
          </date-picker>
        </div>
        <div class='col-4 form-group'>
          <label><strong>Timestamp</strong></label>
          <vue-timepicker 
            input-width="120px"
            manual-input
            :v-model="times[i]"
            format="HH:mm"
            :ref="`time-${section.id}`"
            :close-on-complete="true" />
        </div>
        <span class='help-block text-muted ml-3 mb-3'>
          Leave date fields empty if you don't need them
        </span>
      </div>
      <Editor :name="`editor-${section.id}-${index}`"
        :key="index"
        :ref="`editor-${section.id}`"
        :sectionId="section.id"
        :templateId="template ? template.id : null" /> 
        &nbsp;
      <div class='buttons' style="float: right">
        <a href='javascript:void(0)' 
          class='btn btn-danger btn-sm mt-1'
          data-toggle='tooltip' 
          data-title='Remove section'
          style='margin-left: -8px'
          @click="removeSection(index)"
          v-if="itemSections.length > 1">
          <i class='fal fa-trash-alt'></i>&nbsp;
      </a>
      </div>
    </div>
  </div>
</template>
<script>
  import VueTimepicker from 'vue2-timepicker'
  import Editor from './Editor.vue'
  export default {
    components: { Editor, VueTimepicker },
    props: ['template', 'index', 'items', 'section'],
    computed: {
      letter() {
        return this.section.letter
      },
      itemSections() {
        return this.$parent.reportSectionContents[this.section.letter]
      }
    },
    data() {
      return {
        dates: [],
        times: [],
        date: null
      }
    },
    methods: {
      setDates() {

      },
      removeSection(index) {
        this.$parent.reportSectionContents[this.section.letter].splice(index, 1)
      },
      body() {
        this.$refs[`editor-${index}`][0].body()
      },
      hasTimestamp(i) {
        return this.template.report_sections[i].has_timestamp
      }
    }
  }
</script>