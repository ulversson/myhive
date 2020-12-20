<template>
	<div class='form-group'>
    <label class='form-label'>
      Please select attachment
    </label>
    <treeselect v-model="files" 
      :multiple="true"
      :options="treeRoot"
      :flat="true"
      :load-options="loadOptions"
      :default-expand-level="0"
      ref="tree"
      :disable-branch-nodes="true"
      :sort-value-by="sortValueBy"
      placeholder="Select files">
      <label slot="option-label" slot-scope="{ node, shouldShowCount, count, labelClassName, countClassName }" 
      :class="labelClassName">
        <i class="fa fa-folder" v-if="node.isBranch" 
          :style="`color: ${textColor}`"></i>
        <i :class="`${node.icon}`" 
          :style="`color: ${textColor}`"
          v-if="node.icon"></i>
        &nbsp;{{ node.label }}
        <i class="fas fa-lock" v-if="node.isBranch === false && node.raw.encrypted" ></i>
        <span v-if="shouldShowCount" :class="countClassName">({{ count }})</span>
      </label>
    </treeselect>
  </div>
</template>
<script>
import Treeselect from '@riophae/vue-treeselect'
import folderTree from '../../../mixins/folderTree'
export default {
	components: { Treeselect },
	mixins: [folderTree],
	props: ['textColor'],
	data() {
		return {
      files: [],
			valueConsistsOf: 'LEAF_PRIORITY',
      sortValueBy: 'ORDER_SELECTED',
		}
	}
}
</script>