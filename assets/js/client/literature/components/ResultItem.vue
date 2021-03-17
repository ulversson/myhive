<template>
	<div class="clearfix search-result">
    <span class='text-muted'>{{publicationSummary}}</span>
    <h4><a :href="publicationUrl">{{ result.publication_title }}</a>
		</h4>
    <p class="text-success">{{ this.authors }}</p>
    <p>Tags: {{ this.tags}} </p>
  </div>
</template>
<script type="text/javascript">
  export default {
    props: ['result'],
    computed: {
      publicationUrl() {

      },
      publicationSummary() {

      },
			tags() {
				return this.result.tags.map(t => `#${t}`).join(", ")
			},
      authors() {
        return this.result.authors.map(a => `${a.first_name} ${a.last_name}`)
					.join(', ')
      }
    }
  }
</script>