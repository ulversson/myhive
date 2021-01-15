<template>
	<div class='tab-pane pt-5' :id="provider.name.toLowerCase()"
		:class='index == 0 ? "active" : "" '>
			<div class="col-12 mt-5" v-if="entries.length > 0">
        <div class="card card-primary card-outline">
          <div class="card-body p-0">
						<MailboxControls :page="page" 
							:name="name"
							:mlcId="mlcId"
							:entries="entries"
							:pages="pages"
							:total="total"
							v-if="entries.length > 0" />
            <div class="table-responsive mailbox-messages">
              <EmailTable :entries="entries" 
								v-if="entries.length > 0"/>
            </div>
          </div>
          <div class="card-footer p-0">
            <MailboxControls :page="page" 
							:entries="entries"
							:name="name"
							:mlcId="mlcId"
							:pages="pages"
							:total="total" 
							v-if="entries.length > 0">
						</MailboxControls>
          </div>
      	</div>
    	</div>
			<Alert message="There are no emails here yet. Click refresh below to check and load emails related to this case"
				v-if="entries.length === 0"	/>
			<a class="btn btn-icon rounded-circle btn-secondary mr-2 mb-2" 
				data-toggle="tooltip" data-title="Refresh"
				@click="refreshData()"
				v-if="entries.length === 0">
        <i class="fa fa-sync-alt" aria-hidden="true"></i>
      </a>
	</div>
</template>
<script>
import Alert from '../../file_manager/components/Alert.vue'
import MailboxControls from './MailboxControls.vue'
import EmailTable from './EmailTable.vue'
import inboxRefresh from '../mixins/inboxRefresh'
export default {
	mixins: [inboxRefresh],
	updated() {
		$('[data-toggle=tooltip]').tooltip()
	},
	created() {
		this.loadEmails(this.loadEmailsUrl).then((jsRes) => {
      this.entries = jsRes.data.entries
      this.page = jsRes.data.page_number
      this.total = jsRes.data.total_entries
			this.pages = jsRes.data.total_pages
			window.localStorage.setItem('msJwt', jsRes.data.jwt.token)
		})
		this.$root.$on('checked.email', (item) => {
			if (item.checked) {
				this.$store.commit('addSelectedEmail', item)
			} else {
				this.$store.commit('removeSelectedEmail', item)
			}
		})
	},
	methods: {
		refreshData() {
			this.refresh().then((res) => {
				this.loadEmails(this.loadEmailsUrl).then((jsRes) => {
					this.entries = jsRes.data.entries
      		this.page = jsRes.data.page_number
      		this.total = jsRes.data.total_entries
      		this.pages = jsRes.data.total_pages
				})
			})
		}
	},
	data() {
		return {
			page: 1,
			total: 0,
			pages: 1,
			entries: [], 
			checkedItems: []
		}
	},
	props: ['provider', 'index'],
	components: {
		Alert, MailboxControls, EmailTable 
	}
}
</script>