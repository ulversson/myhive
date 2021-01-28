<template>
	<div class="outgoing-email col-12 row p-0 m-0 mb-3">
    <div class="form-group col-12 p-0 m-0 mb-3">
      <label>
				{{ labelText }}
        <span class="required">*</span>
      </label>
			<treeselect
				:multiple="false"
				:options="storageFolders"
				ref="tree"
        :class="hasError() ? 'has-danger': ''"
				:load-options="loadTreeOptions"
				:disable-branch-nodes="false"
				:value="lastItemOrPreselect"
				:value-format="'object'"
				:sort-value-by="sortValueBy"
				placeholder="Select folder">
			<label slot="option-label" slot-scope="{ node, labelClassName }" 
				:class="labelClassName">
					<i class="fa fa-folder" 
						:style="`color: ${textColor}`"></i>
					<i :class="`${node.icon}`" 
						:style="`color: ${textColor}`"
						v-if="node.icon"></i>
					&nbsp;{{ node.label }}
			</label>
    </treeselect>
      <span class='help-block' v-if="hasError()">
        Please select folder
      </span>
		</div>
	</div>
</template>
<script>
import { LOAD_CHILDREN_OPTIONS } from '@riophae/vue-treeselect'
import sort from 'fast-sort'
const naturalSort = sort.createNewInstance({
    comparer: new Intl.Collator(undefined, { numeric: true, sensitivity: 'base' }).compare,
});
import folderTree from '../../../mixins/folderTree'
import Treeselect from '@riophae/vue-treeselect'
export default {
	mixins: [folderTree],
	components: { Treeselect },
	props: ['textColor', 'fullTree', 'label', 'preselect', 'submit'],
	data() {
		return {
			valueConsistsOf: 'LEAF_PRIORITY',
      sortValueBy: 'ORDER_SELECTED'
		}
	},
	methods: {
		loadTreeOptions({ action, parentNode, callback }) {
			if (action === LOAD_CHILDREN_OPTIONS) {
        if (!parentNode.children) parentNode.children = []
          $.getJSON(this.folderRequestUrl(parentNode.id))
              .done((jsonResponse) => {
                this.addFolderNodesFromResponse(jsonResponse, parentNode)
                callback()
                this.updateTree()
          })
        }
		},
		 addFolderNodesFromResponse(jsonResponse, parentNode) {
       naturalSort(jsonResponse.children).asc(c => c.name)
         	.forEach(element => {
               parentNode.children.push({
                 	label: element.name,
                  id: element.id,
                  isBranch: true,
                  children: null
               })
           })
    },
    hasError() {
      if (!this.$refs.tree) return false
      return this.selectedValue === undefined && this.$parent.submit
    },
	},
	computed: {
		labelText() {
			if (!this.label) {
				return "Save file/s in"
			} else {
				return this.label
			}
		},
		selectedValue() {
			return this.$refs.tree.internalValue[0]
		},
		lastItemOrPreselect() {
			if (!this.preselect) {
				let len = this.storageFolders.length
				return this.storageFolders[len-1]
			} else {
				return this.storageFolders.filter(f => f.label === this.preselect)[0]
			}
		},
		storageFolders() {
			if (this.fullTree) return this.treeRoot
			return this.treeRoot.filter(it => it.folderType !== 'medico_legal_case')
		}
	}
}
</script>