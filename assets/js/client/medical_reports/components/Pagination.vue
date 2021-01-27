<template>
  <div class="pagination">
    <div class="float-left">
      <div class="btn-group">
        <button type="button" class="btn btn-default btn-sm"
          :disabled="page == 1" 
          @click="loadPrevEntries()"
           v-if="pages > 1">
          <i class="fas fa-chevron-left"></i>
        </button>
        <button type="button" class="btn btn-default btn-sm" 
          @click="loadNextEntries()"
          :disabled="page == pages" 
          v-if="pages > 1">
          <i class="fas fa-chevron-right"></i>
        </button>
      </div>
    </div>
    &nbsp;
    <span v-if="areEntriesLoaded">
      &nbsp;{{startItem}}&nbsp;-&nbsp;{{endItem}} of {{ total }}
    </span>
  </div>
</template>
<script>
  export default {
    props: ['total', 'page', 'mlcId', 'pages', 'entries'],
    data() {
      return {
        perPage: 10
      }
    },
    computed : {
      areEntriesLoaded() {
        return this.entries.length > 0
      },
      startItem() {
        return ((this.page - 1) * this.perPage) + 1
      },
      endItem() {
        if (this.page == this.pages) {
          return this.total
        } else {
          return (this.page * this.perPage)
        }
      },
      nextPageUrl() {
        return `/api/v1/reports/${this.mlcId}?page=${this.page+1}`
      },
      prevPageUrl() {
        return `/api/v1/reports/${this.mlcId}?page=${this.page-1}`
      },
    }, 
    methods: {
      loadNextEntries() {
        this.$parent.loadUserReports(this.nextPageUrl)
      },
      loadPrevEntries() {
        this.$parent.loadUserReports(this.prevPageUrl)
      }
    }
  }
</script>
