<template>
	<div class="card position-relative overflow-hidden mb-8">
			<div class="position-absolute bottom-0 left-0 right-0 d-none d-lg-flex flex-row-fluid">
				<span class="svg-icon svg-icon-full flex-row-fluid svg-icon-dark opacity-3">
					<HomeBgSvg />
				</span>
			</div>
			<div class="position-absolute d-flex top-0 right-0 offset-lg-6 col-lg-6 opacity-30 opacity-lg-100">
				<span class="svg-icon svg-icon-full flex-row-fluid p-10">
					<SvgIcon /></SvgIcon>
				</span>
			</div>
			<div class="card-body" style="min-height: 300px">
				<div class="col-lg-6">
					<div class="d-flex align-items-center flex-wrap py-25 px-5">
						<h2 class="text-dark font-weight-bolder mr-12"></h2>
						<SearchInput></SearchInput>
					</div>
				</div>
			</div>
		</div>
</template>
<script>
import SearchInput from './components/SearchInput.vue'
import HomeBgSvg from './components/HomeBgSvg.vue'
import SvgIcon from './components/SvgIcon.vue'
export default {
	components: {
    SearchInput, HomeBgSvg, SvgIcon 
	}
}
</script>