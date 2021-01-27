<template>
  <div class='reports-table'>
    <Pagination :total="total"
      :page="page"
      :mlcId="mlcId"
      :pages="pages"
      :entries="reports"/>
    <table class="table table-striped">
    <thead>
        <tr>
          <th>ID</th>
          <th>Name</th>
          <th>By</th>
          <th>Last Saved</th>
          <th>Actions</th>
        </tr>
    </thead>
    <tbody>
      <ReportRow :report="report" 
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
  export default {
    components: { Pagination, ReportRow },
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
          this.reports = res.data
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