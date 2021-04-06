<template>
  <div class='reports-table'>
    <Pagination :total="total"
      :page="page"
      :mlcId="mlcId"
      :pages="pages"
      :entries="reports"/>
    <Alert message="No reports" v-if="reports.length === 0"/>
    <table class="table table-striped"
      v-if="reports.length > 0">
    <thead>
        <tr>
          <th>ID</th>
					<th>Status</th>
          <th>Name</th>
          <th>By</th>
          <th>Last Saved</th>
          <th>Actions</th>
        </tr>
    </thead>
    <tbody>
      <ReportRow :report="report" 
        :ref="`row-${report.id}`"
        v-for="report in reports" />
    </tbody>
  </table>
  <Pagination :total="total"
    :page="page"
    :mlcId="mlcId"
    :pages="pages"
    :entries="reports"/>
  </div>
</template>
<script>
  import Pagination from './Pagination.vue'
  import ReportRow from './ReportRow.vue'
  import Alert from '../../file_manager/components/Alert.vue'
  export default {
    components: { Pagination, ReportRow, Alert },
    data() {
      return {
        reports: [],
        page: 1,
        total: 0,
        mlcId: window.localStorage.getItem('currentMedicoLegalCaseId'),
        pages: 0
      }
    },
    created() {
      this.loadUserReports(this.loadReportsUrl)
    },
    updated() {
      $("[data-toggle='tooltip']").tooltip()
    },
    computed: {
      loadReportsUrl() {
        return  `/api/v1/reports/${this.mlcId}?page=${this.page}`
      }
    },
    methods: {
      loadUserReports(url) {
        $.ajax({
          url: url,
          type: 'GET'
        }).done((res) => {
          this.reports = res.data.reverse()
          this.pages = res.total_pages
          this.page = res.page_number
          this.total = res.total_entries
        }).catch(err => {
          this.$swal('Error', 'Unable to load reports for the case', 'error')
        })
      }
    }
  }
</script>