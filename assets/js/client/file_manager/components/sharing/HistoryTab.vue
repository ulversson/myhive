<template>
  <div class='share-history'>
    <table class="table table-striped" v-if="directories.length > 0">
      <thead>
        <tr>
          <th>#</th>
          <th>Recipient</th>
          <th>Expires</th>
          <th></th>
          <th></th>
        </tr>
      </thead>
        <tbody>
          <history-tab-row v-for="(dir, idx) in directories" 
            :key="dir.id" :idx="idx" :dir="dir" />
      </tbody>
    </table>
    <Alert message="There has not been any files shared yet" v-else />
  </div>
</template>
<script>
import Alert from '../Alert.vue'
import HistoryTabRow from './HistoryTabRow.vue'
export default {
  components: { Alert, HistoryTabRow  },
  data() {
    return {
      directories: []
    }
  },
  mounted() {
    const mlcId = window.localStorage.currentMedicoLegalCaseId
    $.getJSON(`/api/v1/shareables/${mlcId}`, (res) => {
      if (res) {
        res.forEach((el) => {
          this.directories.push(el)
        })
      }
    })
  }
}
</script>