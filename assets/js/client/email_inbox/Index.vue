<template>
	<div id='email-inbox'>
		<div class="nav-tabs-horizontal">
			<ul role="tablist" class="nav nav-tabs" style="font-size: 16px; float: right;">
				<li class="nav-item" v-for="(provider, index) in providers">
						<a href="javascript: void(0);" data-toggle="tab" 
							:class='index == 0 ? "active" : "" '
							:data-target="provider.name.toLowerCase()" role="tab" class="nav-link active">
							<i :class="provider.icon"></i>
							{{ provider.name }}
        		</a>
				</li> 
			</ul>
			<div class='tab-content' v-for="(provider, index) in providers">
				<ProviderEmail :provider="provider" :index="index"/>
			</div>
	</div>
</div>
</template>
<script>
import settings from '../file_manager/mixins/settings'
import ProviderEmail from './components/ProviderEmail.vue'
export default {
	data() {
		return {
			providers: []
		}
	},
	created() {
		this.loadProviders()
	},
	methods: {
		loadProviders() {
			$.getJSON(`/api/v1/email_inbox/providers`, (jsRes) =>{
				this.providers = jsRes.providers
			})
		}
	},
	mixins: [settings],
	components: { ProviderEmail }
}
</script>
<style>

.badge {
    border-radius: 8px;
    padding: 4px 8px;
    font-size: .7142em;
    line-height: 12px;
    background-color: transparent;
    border: 1px solid;
    margin-bottom: 5px;
    border-radius: .875rem;
}
.bg-green {
    background-color: #50d38a !important;
    color: #fff;
}
.bg-blush {
    background-color: #ff758e !important;
    color: #fff;
}
.bg-amber {
    background-color: #FFC107 !important;
    color: #fff;
}
.bg-red {
    background-color: #ec3b57 !important;
    color: #fff;
}
.bg-blue {
    background-color: #60bafd !important;
    color: #fff;
}
.inbox .action_bar .delete_all {
    margin-bottom: 0;
    margin-top: 8px
}

.inbox .action_bar .btn,
.inbox .action_bar .search {
    margin: 0
}

.inbox .mail_list .list-group-item {
    border: 0;
    padding: 15px;
    margin-bottom: 1px
}

.inbox .mail_list .list-group-item:hover {
    background: #eceeef
}

.inbox .mail_list .list-group-item .media {
    margin: 0;
    width: 100%
}

.inbox .mail_list .list-group-item .controls {
    display: inline-block;
    margin-right: 10px;
    vertical-align: top;
    text-align: center;
    margin-top: 11px
}

.inbox .mail_list .list-group-item .controls .checkbox {
    display: inline-block
}

.inbox .mail_list .list-group-item .controls .checkbox label {
    margin: 0;
    padding: 10px
}

.inbox .mail_list .list-group-item .controls .favourite {
    margin-left: 10px
}

.inbox .mail_list .list-group-item .thumb {
    display: inline-block
}

.inbox .mail_list .list-group-item .thumb img {
    width: 40px
}

.inbox .mail_list .list-group-item .media-heading a {
    color: #555;
    font-weight: normal
}

.inbox .mail_list .list-group-item .media-heading a:hover,
.inbox .mail_list .list-group-item .media-heading a:focus {
    text-decoration: none
}

.inbox .mail_list .list-group-item .media-heading time {
    font-size: 13px;
    margin-right: 10px
}

.inbox .mail_list .list-group-item .media-heading .badge {
    margin-bottom: 0;
    border-radius: 50px;
    font-weight: normal
}

.inbox .mail_list .list-group-item .msg {
    margin-bottom: 0px
}

.inbox .mail_list .unread {
    border-left: 2px solid
}

.inbox .mail_list .unread .media-heading a {
    color: #333;
    font-weight: 700
}

.inbox .btn-group {
    box-shadow: none
}

.inbox .bg-gray {
    background: #e6e6e6ac
}

@media only screen and (max-width: 767px) {
    .inbox .mail_list .list-group-item .controls {
        margin-top: 3px
    }
}
</style>