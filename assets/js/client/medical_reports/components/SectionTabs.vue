<template>
	<div class="tabs-vertical">
	  <ul class="nav nav-tabs reports" role="tablist">
	     <li class="nav-item" v-for="(sec, index) in sections"> 
	     		<a class="nav-link" data-toggle="tab" 
	     			:class="isActiveClass(index)" 
	     			:href="`#section-${sec.id}`" role="tab" aria-selected="true">
	     			{{ sec.name }}
	     		</a> 
	     	</li>
	   </ul>
     <div class="tab-content pt-3" style="max-height: 500px; overflow-y: scroll; width: 100%">
	     <div class="tab-pane fade show"
	      :class="isActiveClass(index)" 
	      v-for="(sec, index) in sections"
	      :id="`section-${sec.id}`" role="tabpanel" 
	      aria-labelledby="home-vertical-tab">
        <LabelledEditor 
          :items="items(sec.letter)"
          :index="index"
          :template="template"
          :ref="`editor-${sec.id}`"
          :section="sec"/>
          <a href='javascript:void(0)' 
            class='btn btn-success btn-sm mt-5'
            data-toggle='tooltip' 
            :data-letter="sec.letter"
            data-title='Add another paragraph'
            @click="addSectionFromIndex(index)"
            v-if="isMultiple(index)">
            <i class='fal fa-plus'></i>&nbsp;
            Add paragraph
          </a>
	      </div>              
   	</div>
  </div>
</template>
<script>
  import LabelledEditor from './LabelledEditor.vue'
	export default {
    components: {  LabelledEditor },
		props: ['sections', 'template'],
    data() {
      return {
        reportSectionContents:  {}
      }
    },
		methods: {
      items(sec) {
        let items = this.reportSectionContents[sec]
        if (!items) {
          this.$set(this.reportSectionContents, sec, ['LabelledEditor'])
        }
        return this.reportSectionContents[sec]
      },
			isActiveClass(index) {
				return index === 0 ? 'active' : ''
			},
      isMultiple(index) {
        const scs = this.template.report_sections[index]
        if (!scs) return false
        return scs.is_multiple
      },
      addSection(section) {
        this.items(section).push('LabelledEditor')
      },
      removeSection(section) {
        const idx = this.items(section).indexOf('LabelledEditor')
        this.items(section).splice(idx, 1)
      },
      removeSections(section) {
        this.items(section).splice(0, this.items(section).length)
      },
      addSectionFromIndex(index) {
        const section = this.sections[index]
        this.addSection(section.letter)
      },
      populateSectionContents() {
        this.sections.forEach((sec, idx) => {
          this.$set(this.reportSectionContents, sec.letter, ['LabelledEditor'])
        })
      }
		}
	}
</script>
<style>
	
.tab-vertical .nav.nav-tabs {
    float: left;
    display: block;
    margin-right: 0px;
    border-bottom: 0
}

.tab-vertical .nav.nav-tabs .nav-item {
    margin-bottom: 6px
}

.tab-vertical .nav-tabs .nav-link {
    border: 1px solid transparent;
    border-top-left-radius: .25rem;
    border-top-right-radius: .25rem;
    background: #fff;
    padding: 17px 49px;
    color: #71748d;
    background-color: #dddde8;
    -webkit-border-radius: 4px 0px 0px 4px;
    -moz-border-radius: 4px 0px 0px 4px;
    border-radius: 4px 0px 0px 4px
}

.tab-vertical .nav-tabs .nav-link.active {
    color: #5969ff;
    background-color: #fff !important;
    border-color: transparent !important
}

.tab-vertical .nav-tabs .nav-link {
    border: 1px solid transparent;
    border-top-left-radius: 4px !important;
    border-top-right-radius: 0px !important
}

.tab-vertical .tab-content {
    overflow: auto;
    -webkit-border-radius: 0px 4px 4px 4px;
    -moz-border-radius: 0px 4px 4px 4px;
    border-radius: 0px 4px 4px 4px;
    background: #fff;
    padding: 30px
}
</style>