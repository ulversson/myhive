<template>
  <modal 
    :name="modalName"
    :min-width="200"
		@opened="loadComments"
    :adaptive="true" :scrollable="true"
    styles="font-size: 13px" 
    width="30%" height="auto">
  	<div class='card comment' style="width: 100% !important">
			<div class='card-body' style='height: 400px; overflow-y: scroll'>
				<div class="cui-apps-profile-wall-comments p-2"
					v-for="comment in itemComments"
						:key="comment.id">
					<Comment :comment="comment"/>
				</div>
				<NewComment v-show="newCommentVisible"
					:status="status"
					ref="newComment" />
				<Alert message="There are no comments yet. Click below to add" 
					v-if="itemComments.length === 0 && !newCommentVisible"/>
			</div>
		</div>
		<CommentButtons 
			:buttonVisible.sync="newCommentVisible"
			:toggleComment="toggleComment"
			:save="save" 
			:hideComments="hideComments"
		/>
</modal>
</template>
<script>
import Alert from '../../Alert.vue'
// @ts-nocheck
import Comment from './Comment.vue'
import CommentButtons from './CommentButtons.vue'
import NewComment from './NewComment.vue'
export default {
	props: ['status'],
	components: {
		Alert, Comment, NewComment, CommentButtons 
	},
	data() {
		return {
			newCommentVisible: false,
			itemComments: []
		}
	},
	computed: {
		content: {
			get() {
				return this.$refs.newComment.content
			},
			set(value) {
				this.$refs.newComment.content = value
			}
		},
		modalName() {
			return `comments-modal-${this.status.id}`			
		}
	},
	watch: {
		newCommentVisible: function(newVal, oldVal) {
			let vm = this
			if (newVal) {
				setTimeout(() => {
					var elem = $('div.ql-editor')[0]
					elem.scrollIntoView(false)
					vm.content = ''
				}, 300)
			}
		}
	},
	methods: {
		removeComment() {

		},
		loadComments() {
			this.itemComments.splice(0, this.itemComments.length)
			$.ajax({
        type: "GET",
				url: `/api/v1/timeline/${this.status.id}/comments`,
      }).done((jsRes) => {
				jsRes.data.forEach((comment, index) => {
					this.itemComments.push(comment)
				})
			}).always(() => {
					setTimeout(() => {
						var lastItem = $(".cui-apps-profile-wall-content:last")[0]
						if (lastItem) {
							lastItem.scrollIntoView()
						}
					}, 500)
				})
		},
		save() {
			debugger
			if(this.content !== '') {
				$.ajax({
					type: "POST",
					url: `/api/v1/timeline/${this.status.id}/comment`,
					data: this.$refs.newComment.formData
				}).done((comment) => {
					this.itemComments.push(comment)
					this.content = ''
					this.toggleComment()
					this.increaseCommentCount()
				})
			} else {
				this.$swal('Error', 'Content cannot be empty', 'error')
			}
		},
		hideComments() {
			this.$modal.hide(this.modalName)
		},
		toggleComment() {
			this.newCommentVisible = !this.newCommentVisible
		},
		decreaseCommentCount() {
			let currentCount = this.$parent.status.comments_count
			let newCount = currentCount - 1
			if (newCount < 0) newCount = 0
			this.$set(this.$parent.status, 'comments_count', newCount)
		},
		increaseCommentCount() {
			let currentCount = this.$parent.status.comments_count
			let newCount = currentCount + 1
			this.$set(this.$parent.status, 'comments_count', newCount)
		},
		removeComment(comment) {
			$.ajax({
				url: `/api/v1/timeline/comments/${comment.id}/delete`,
				type: 'DELETE',
				data: {
					"id" : comment.id
				}
			}).done((jsRes) => {
				let idx = this.itemComments.indexOf(comment)
				this.itemComments.splice(idx, 1)
				this.decreaseCommentCount()
			})
		} 
	}
}
</script>