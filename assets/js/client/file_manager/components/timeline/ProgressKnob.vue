<template>
	<div class='progress-knob'>
		<knob-control 
			v-model="knobValue"
			 v-if="showKnobOnInit" :style='knobStyle' />
    <label  
			v-if="showKnobOnInit" :style="knobStyle">
      Total progress %
    </label>
	</div>
</template>
<script>
import KnobControl from 'vue-knob-control'
export default {
	props: ['showKnobOnInit', 'knobValue'],
	components: { KnobControl },
	computed: {
		knobStyle() {
			return 'float: right'
		}
	}
}
</script>