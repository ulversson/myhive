import sort from 'fast-sort'
const naturalSort = sort.createNewInstance({
    comparer: new Intl.Collator(undefined, { numeric: true, sensitivity: 'base' }).compare,
})
export default {
    methods: {
      naturalSort
    },
    computed: {
      isForcedOrderingByName() {
        return Object.keys(this.currentFolder).length > 0 && this.currentFolder.parent_id === null //identify root dir
      },
      orderedDirectories() {
        if (this.isForcedOrderingByName) {
          return naturalSort(this.filteredDirectories).asc(d => d.name)
        } else {
          if (this.column === 'name' && this.order === 'asc') {
            return naturalSort(this.filteredDirectories).asc(d => d.name)
          } else if (this.column === 'name' && this.order === 'desc') {
            return naturalSort(this.filteredDirectories).desc(d => d.name)
          } else if (this.column === 'date' && this.order === 'asc') {
            return sort(this.filteredDirectories).asc(d => moment(d.updated).toDate().getTime())
          } else if (this.column === 'date' && this.order === 'desc') {
            return sort(this.filteredDirectories).desc(d => moment(d.updated).toDate().getTime())
          }
        }
      },
      orderedAssets() {
        if (this.column === 'name' && this.order === 'asc') {
          return naturalSort(this.filteredAssets).asc(d => d.name)
        } else if (this.column === 'name' && this.order === 'desc') {
          return naturalSort(this.filteredAssets).desc(d => d.name)
        } else if (this.column === 'date' && this.order === 'asc') {
          return sort(this.filteredAssets).asc(d => moment(d.updated_at).toDate().getTime())
        } else if (this.column === 'date' && this.order === 'desc') {
          return sort(this.filteredAssets).desc(d => moment(d.updated_at).toDate().getTime())
        }    
      }
    }
}