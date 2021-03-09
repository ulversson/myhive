<template>
  <div class="editor">
    <div class='labelled mb-0'
      v-for="(repSec, i) in items">
      <div class='row time-date'
        v-if="hasTimestamp(index)">
        <div class='col-1 p-0 form-group' style="margin-left: 16px; max-width: 50px !important">
          <label v-if="section.is_letter_visible" style="margin-top: 7px">
            <strong>{{letter}}{{i+1}}</strong>
          </label>
        </div>
        <div class='col-2 mr-0 pr-0 pl-0 form-group' style="max-width: 120px">
          <date-picker 
            style="width: 110px"
            value-type="format"
            v-model="dates[i]"
            :ref="`date-${section.id}`"
            format="DD/MM/YYYY">
          </date-picker>
        </div>
        <div class='col-1 mr-4 p-0 form-group' style="margin-left: 3px">
          <vue-timepicker 
            :input-width="'70px'"
            manual-input
            :v-model="times[i]"
            format="HH:mm"
            placeholder="hh:mm"
            :ref="`time-${section.id}`"
            :close-on-complete="true" />
        </div>
        <div class='form-group' 
          style="float: right;padding-right: 0px;padding-left: 0px; width:496px">
          <Editor :name="`editor-${section.id}-${index}`"
            :key="index"
            :ref="`editor-${section.id}`"
            :defaultContent="contentForIndex(index)"
            :sectionId="section.id"
            :templateId="template ? template.id : null" /> 
        </div>
        <div class='ml-0 row form-group'>
          <div class='col-12'>
            <a href='javascript:void(0)' 
              class='btn btn-danger btn-sm mt-0'
              data-toggle='tooltip' 
              style="margin-top: -78px !important" 
              data-title='Remove section'
              @click="removeSection(i)"
              v-if="itemSections.length > 1">
              <i class='fal fa-trash-alt'></i>&nbsp;
            </a>
          </div>
        </div>
    </div>
    <div class='row mt-2 ml-0' style="max-width: 758.63px" v-else>
      <label class='col-1 pl-0' v-if="section.is_letter_visible">
        <strong>{{letter}}{{i+1}}</strong>
      </label>
     <Editor :name="`editor-${section.id}-${index}`"
        :key="index"
        class="form-group mb-3"
        :class='$parent.isMultiple(index) ? "col-11" : "col-12" '
        :ref="`editor-${section.id}`"
        :defaultContent="contentForIndex(index)"
        :sectionId="section.id"
        :templateId="template ? template.id : null" /> 
      <div class='row form-group'>
        <div class='col-12' style="margin-top: -8px">
          <a href='javascript:void(0)' 
            class='btn btn-danger btn-sm mt-0'
            data-toggle='tooltip' 
            data-title='Remove section'
            @click="removeSection(i)"
            v-if="itemSections.length > 1">
            <i class='fal fa-trash-alt'></i>&nbsp;
          </a>
        </div>
      </div>
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
    created() {
      console.log()
    },
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
        date: null,
        isTaggable: false
      }
    },
    methods: {
      contentForIndex(i) {
        if (this.template.report_sections[i]) {
          return this.template.report_sections[i].default_content
        } else {
          return null
        }
      },
      removeSection(index) {
        debugger
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
<style type="text/css">
  .editor .ql-toolbar.ql-snow {
    max-height: 34px;
    padding-top: 3px;
    border-radius: 4px
  }

  .editor .ql-editor {
    min-height: 100px !important;
  }

  .time-picker input {
    border-radius: 4px;
  }

  .editor .ql-container.ql-snow {
    border-radius: 0px;
  }

</style>