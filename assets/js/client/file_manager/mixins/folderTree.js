import { LOAD_CHILDREN_OPTIONS } from '@riophae/vue-treeselect'

export default {
    computed: {
        treeRoot() {
            let children = this.$parent.managerComponent.rootChildren
            return children.map((child, index) => {
                return {
                    id: child.id,
                    label: child.name,
                    isBranch: true,
                    children: null
                }
            })
        }
    },
    methods: {
        folderRequestUrl(folderId) {
            return `/api/v1/folders/show_tree/${folderId}?order=${this.$store.state.order}&column=${this.$store.state.column}`
        },
        loadOptions({ action, parentNode, callback }) {
            this.updateTree()
            if (action === LOAD_CHILDREN_OPTIONS) {
                if (!parentNode.children) parentNode.children = []
                $.getJSON(this.folderRequestUrl(parentNode.id))
                    .done((jsonResponse) => {
                        this.addNodesFromResponse(jsonResponse, parentNode)
                        callback()
                        this.updateTree()
                    })
            }
        },
        updateTree() {
            if (this.$refs.tree)
                this.$refs.tree.initialize(this.treeRoot)
        },
        addNodesFromResponse(jsonResponse, parentNode) {
            jsonResponse.children.forEach(element => {
                parentNode.children.push({
                    label: element.name,
                    id: element.id,
                    isBranch: true,
                    children: null
                })
            })
            jsonResponse.assets.forEach(asset => {
                parentNode.children.push({
                    isBranch: false,
                    label: asset.name,
                    encrypted: asset.encrypted,
                    id: asset.id,
                    icon: asset.icon
                })
            })
        }
    }
}