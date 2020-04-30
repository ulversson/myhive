<template>
  <table class="cui-github-explore-nav table table-hover col-9 table-default">
    <tbody>
      <tr v-for="directory in directories" :key="directory.id">
        <td class="cui-github-explore-nav-icon text-secondary">
          <i class="fa fa-folder"></i>
        </td>
        <td class="cui-github-explore-nav-content">
          <a href="#" class="cui-github-explore-nav-link">
            {{ directory.name }}
          </a>
        </td>
        <td class="cui-github-explore-nav-descr">information about file</td>
        <td class="cui-github-explore-nav-time">{{ dateAgo(directory) }}</td>
      </tr>
    </tbody>
  </table>
</template>
<script>
import moment from 'moment'
export default {
  props: ['directories'],
  methods: {
    dateAgo(directory) {
      return moment(directory.updated).fromNow()
    }
  }
}
</script>