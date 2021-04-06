<template>
  <tr>
    <td>{{ report.id }}</td>
		<td>
			<span class='badge badge-rounded badge-pill badge-teal text-white' 
					style="background-color: #a3c6c4 !important"
					v-if="report.draft">
					Draft
				</span>
			<span v-else class='badge badge-rounded badge-pill badge-info text-white'>
					Final
				</span>
		</td>
    <td>{{ report.report_template.name }}</td>
    <td>
      <span class="badge badge-pill badge-rounded badge-secondary" 
      style="font-size: 13px">
       {{ report.user.name }}
      </span>
    </td>
    <td>
      <label>
        <i class='fal fa-clock text-warning'></i>&nbsp;
          {{ reportUpdatedDate }}
        </label>  
    </td>
    <td>
      <RowActions :report="report" :ref="`action-${report.id}`" />
    </td>
  </tr>
</template>
<script>
  import RowActions from './RowActions.vue'
  export default {
    props: ['report'],
    components: { RowActions },
    computed: {
      reportUpdatedDate() {
        return moment(this.report.updated_at)
          .format('DD/MM/YYYY HH:mm')
      }
    }
  }
</script>