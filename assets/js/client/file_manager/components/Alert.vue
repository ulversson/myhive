<template>
  <table class="cui-github-explore-nav table table-hover col-9">
    <tbody>
      <tr>
        <td>
          <div class="alert" role="alert" :style="`background-color: ${this.textColor}`">
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
              <span aria-hidden="true">×</span>
            </button>
            <i class='fa fa-info-circle'></i>
            {{ message }}
          </div>
        </td>
      </tr>
    </tbody>
  </table>  
</template>
<script>
import settings from '../mixins/settings'
export default {
  mixins: [settings],
  props: ['message']
}
</script>