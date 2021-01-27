<template>
  <tr>
    <td>{{ report.id }}</td>
    <td>{{ report.report_template.name }}</td>
    <td>
      <span class="badge badge-pill badge-rounded badge-secondary" 
      style="font-size: 13px">
       {{ report.user.name }}
      </span>
    </td>
    <td>
      <i class='fal fa-clock text-warning'></i>&nbsp;
      {{ reportUpdatedDate }}</td>
    <td>
      <RowActions :report="report" />
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