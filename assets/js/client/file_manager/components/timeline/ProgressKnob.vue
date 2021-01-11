<template>
	<div class='progress-knob' style='float: right; width: 100px;margin-top: 15px'>
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
<style>
div.progress-knob {
    float: right;
    margin-top: 50px;
    position: absolute;
    right: 0;}
</style>
