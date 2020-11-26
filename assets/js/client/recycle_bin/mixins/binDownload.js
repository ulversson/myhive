import download from '../../file_manager/mixins/download'
export default {
  mixins: [download],
  computed: {
    downloadFileName() {
      return `${this.item.name}.zip`
    },
    downloadLink() {
      switch (this.itemType) {
        case 'file':
          return `/downloads/${this.item.id}`
        case 'folder':
          return ''
      }
    }
  },
  methods: {
    getItem() {
       switch (this.itemType) {
        case 'file':
          return window.location.href = this.downloadLink
        case 'folder':
          this.$store.commit('addSelectedItem', {
            type: 'folder',
            id: this.item.id,
            checked: true
          })
          this.downloadAll()
          break;
      }
    }
  }
}