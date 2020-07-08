<template>
  <div class='archive'>
    <Header :currentFolderId="currentFolder.id" 
      :currentFolder.sync="currentFolder"
      ref='headerPanel'/> 
    <h4>{{name}}</h4>
    <table class="cui-github-explore-nav table table-hover">
    <tbody>
      <Directory 
        v-for="directory in directories" 
        :directory="directory"
        :textColor="textColor"
        :currentFolder="currentFolder"
        :key="directory.id" />
    </tbody>
  </table>
  </div>
</template>
<script>
import Header from './components/Header.vue'
import Directory from './components/Directory.vue'
import settings from '../file_manager/mixins/settings'
export default {
  components: { Header, Directory },
  mixins: [settings],
  data() {
    return {
      directories: [],
      name: "",
      currentFolder: null
    }
  },
  created() {
    this.loadArchiveRoot()
    this.loadSettings()
  },
  computed: {
    order() {
      return this.$store.state.order
    },
    column() {
      return this.$store.state.column
    }
  },
  methods: {
    loadArchiveRoot() {
      $.getJSON(`/api/v1/archive?order=${this.order}&column=${this.column}`, 
        (folder) => {
          this.currentFolder = folder
          folder.children.forEach(child => {
            this.directories.push(child)
          })
          this.name = folder.name
          this.$store.commit('setRole', folder.roles[0])
        })
    }
  }
}
</script>