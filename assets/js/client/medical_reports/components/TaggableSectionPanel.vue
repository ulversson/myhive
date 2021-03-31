<template>
	<div class='panel'>
		<a href="javascript:void(0)" id="add-new-glossary-item" 
      data-toggle='tooltip'
      title='Add new glossary item'
			@click="showModal"
      class="btn btn btn-sm btn-myhive active mb-4">
        <i class="fal fa-plus"></i>
      &nbsp;Add new glossary item
    </a>
		<div class='taggable-input'>
			<label>Type to search item</label>
			<vue-tags-input
				style="width: 100%"
				:tags="items"
				v-model="tag"
				ref="tagSelect"
				:avoid-adding-duplicates="true"
				:add-on-blur="false"
				:placeholder="'Type to search item'"
				:autocomplete-items="filteredItems"      
				:add-from-paste="false"
				@input="searchItems" 
				@tags-changed="onTagsChanged" />
			<span class='text-muted help-block'>
				Items will be organised alphabetically in the report
			</span>
			<div class='item-editor'
				v-for="(item, iidx) in items" :key="item.id">
			<label><strong>{{ nameForItem(item) }} </strong></label>
			<Editor :name="`editor-${section.id}-${index}`"
				:key="index"
				class="form-group mb-3 col-12"
				:ref="`tag-${item.value}`"
				:tagId="item.value"
				:defaultContent="item.description"
				:sectionId="section.id"
				:templateId="template ? template.id : null" />
			</div> 
		</div>
		<NewGlossaryItem 
			ref="new-got" :items.sync="items"/>
		</NewGlossaryItem>
	</div>
</template>
<script type="text/javascript">
  import VueTagsInput from '@johmun/vue-tags-input'
  import Editor from './Editor.vue'
	import NewGlossaryItem from './NewGlossaryItem.vue'
	import sorting from '../../file_manager/mixins/sorting'
  export default {
    props: ['template', 'section', 'index'],
		mixins: [sorting],
    components: { VueTagsInput, Editor, NewGlossaryItem },
    data() {
      return {
        tag: '',
        items: [],
        filteredItems: [],
        isTaggable: true
      }
    },
		computed: {
			orderedItems() {
				return this.naturalSort(this.items).asc(d => d.name)
			}
		},
  	methods: {
			showModal() {
				this.$modal.show('got-modal')
			},
      nameForItem(item) {
        if (item.short_name) {
          return `${item.name} (${item.short_name})`
        } else {
          return item.name
        }
      },
      onTagsChanged(tags) {
        this.filteredItems = [];
        this.items = tags
        this.tag = ''
      },
      searchItems(query) {
        this.filteredItems.splice(0, this.filteredItems.length)
        return $.ajax({
          type: 'GET',
          url: `/api/v1/glossary/search?q=${query}`
        }).done((respItems) => {
          respItems.data.forEach((item, index) => {
            item.text = item.name
            item.value = item.id
            this.filteredItems.push(item)
          })
        })
      }
    }
  }
</script>