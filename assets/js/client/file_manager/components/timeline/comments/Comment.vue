<template>
  <div class="comment">
    <div class="cui-apps-profile-wall-avatar">
      <a class="cui-avatar cui-avatar-50" href="javascript:void(0);"
				v-html="comment.avatar">
      </a>
    </div>
    <div class="cui-apps-profile-wall-content">
      <div class="mb-1">
        <div class="pull-right" style="float: right">
					<button class="btn btn-icon btn-xs btn-rounded btn-outline-danger mt-2 ml-2 pull-right"
						style="opacity: 0.6"
						data-toggle='tooltip' 
						@click="removeComment()"
						v-if="comment.user_id === userId"
						data-title='Remove comment'>
						<i class="fas fa-trash-alt"></i>
        	</button>
        </div>
        <strong>{{ comment.user }}</strong> posted:
				<br/>
        <small class="text-muted">
					{{ commentedWhen }}
				</small>
      </div>
      <div v-html="comment.content"></div>
    </div>
  </div>
</template>
<script>
import Users from '../../../../../users'
	import moment from 'moment'
	export default {
		created() {
			$(".tooltip").tooltip()
		},
		methods: {
			removeComment() {
				this.$parent.$parent.removeComment(this.comment)
			}
		},
		computed: {
			userId() {
				return Users.currentUserId()
			},
			commentedWhen() {
				return moment(this.comment.commented_at).fromNow()
			}
		},
		props: {
			comment: {
				type: Object
			}
		}
	}
</script>
