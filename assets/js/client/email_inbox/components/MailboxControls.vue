<template>
  <div class="mailbox-controls">
    <div class="btn-group">
      <button type="button" class="btn btn-default btn-sm"
				:disabled="noItemsSelected"
				@click="removeSelected"
				v-if="areEntriesLoaded">
        <i class="far fa-trash-alt"></i>
      </button>
    </div>
    <button type="button" class="btn btn-default btn-sm"
			v-if="areEntriesLoaded"
			@click="refresh">
      <i class="fas fa-sync-alt"></i>
    </button>
    <div class="float-right">
      <span v-if="areEntriesLoaded">
				{{startItem}}&nbsp;-&nbsp;{{endItem}} of {{ total }}
			</span>
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
  </div>
</template>
<script>
	import { mapState } from 'vuex'
 	export default {
		props: ['name', 'total', 'page', 'mlcId', 'pages', 'entries'],
		data() {
			return {
				perPage: 15
			}
		},
		computed : {
			removeUrl() {
				return `/api/v1/email_inbox/delete/${this.selectedIds}`
			},
			selectedIds() {
				return this.selectedEmails.map(e => e.id).join(',')
			},
 			...mapState(['selectedEmails']),
			noItemsSelected() {
				return this.selectedEmails.length === 0
			},
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
				return `/api/v1/email_inbox?id=${this.mlcId}&provider=${this.name}&page=${this.page+1}`
			},
			prevPageUrl() {
				return `/api/v1/email_inbox?id=${this.mlcId}&provider=${this.name}&page=${this.page-1}`
			}
		}, 
		methods: {
			removeItemFromList() {
				this.selectedEmails.forEach(eml => {
					this.$store.commit('resetSelectedEmail')
					let idx = this.$parent.entries.findIndex(i => i.id == eml.id)
					this.$parent.entries.splice(idx, 1)
					$("input:checked").prop('checked', false)
				});
			},
			removeSelected() {
				UI.runConfirmedAction(
					'fas fa-trash-alt',
					'DELETE',
					`Remove selected emails`,
					'You will not be able to revert this',
					this.removeUrl,
					() => {
						this.removeItemFromList()
					}, undefined, this
				)
			},
			refresh() {
				this.$parent.refreshData()
			},
			loadNextEntries() {
				this.$parent.loadEmails(this.nextPageUrl)
			},
			loadPrevEntries() {
				this.$parent.loadEmails(this.prevPageUrl)
			}
		}
	}
</script>
