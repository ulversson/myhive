<template>
	<div class="outgoing-email col-12 row p-0 m-0 mb-3">
    <div class="form-group col-12 p-0 m-0 mb-3">
      <label>
        Save file/s in
        <span class="required">*</span>
      </label>
			<treeselect
				:multiple="false"
				:options="storageFolders"
				ref="tree"
				:disable-branch-nodes="false"
				:value="lastItem"
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
		</div>
	</div>
</template>
<script>
import folderTree from '../../../mixins/folderTree'
import Treeselect from '@riophae/vue-treeselect'
export default {
	mixins: [folderTree],
	components: { Treeselect },
	props: ['textColor', 'fullTree'],
	data() {
		return {
			valueConsistsOf: 'LEAF_PRIORITY',
      sortValueBy: 'ORDER_SELECTED'
		}
	},
	computed: {
		selectedValue() {
			return this.$refs.tree.internalValue[0]
		},
		lastItem() {
			let len = this.storageFolders.length
			return this.storageFolders[len-1]
		},
		storageFolders() {
			if (this.fullTree) return this.treeRoot
			return this.treeRoot.filter(it => it.folderType !== 'medico_legal_case')
		}
	}
}
</script>