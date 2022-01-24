<template>
  <tr :data-id="dir.id">
    <loading :active.sync="loading" :can-cancel="false"  :is-full-page="true" />  
    <th scope="row">{{ idx + 1 }} </th>
      <td>
        <small class="text-uppercase text-default">{{ dir.email }}</small>
        <br>
        {{dir.first_name}}&nbsp;{{dir.last_name}}
      </td>
      <td>
        <small class="text-uppercase text-default">Expires</small>
        <br>
        {{ this.expiringDate }}
      </td>
      <td>
        <small class="text-uppercase text-default">Viewed</small>
        <br>
        <span class='badge badge-pill badge-success' v-if="dir.viewed">YES</span>
        <span class='badge badge-pill badge-danger' v-else>NO</span>
      </td>
      <td>
        <small class="text-uppercase text-default">Files</small>
        <br>
        {{ dir.count }}
      </td>
      <td>
        <br/>
        <a data-toggle="tooltip" data-title="Resend" @click="resend(dir.id)"
          class="btn btn-icon btn-xs btn-outline-success mr-2 mb-2 btn-rounded">
          <i class="fal fa-redo-alt"></i>
        </a> 
        <a data-toggle="tooltip" data-title="Revoke access" @click="deleteShare(dir.id)"
          class="btn btn-icon btn-xs btn-outline-danger mr-2 mb-2 btn-rounded">
          <i class="fal fa-ban"></i>
        </a>
      </td>
    </tr>
</template>
<script>
import 'vue-loading-overlay/dist/vue-loading.css'
import Loading from 'vue-loading-overlay'
export default {
  data() {
    return {
      loading: false
    }
  },
  props: {
    dir: { type: Object, default: () => {}  },
    idx: { type: Number, default: 0}
  },
  computed: {
    expiringDate() {
      return moment(this.dir.expires).format('DD/MM/YYYY')
    }
  }, 
  components: { Loading },
  methods: {
    resend(id) {
      this.loading = true
      UI.runConfirmedAction('fal fa-question', 'PUT', 
      'Send it again', 'This email will be send again to its original recipient', 
      `/api/v1/shareable/${id}`, () => {
          this.$swal('Done', 'Email has been sent', 'success')
          this.loading = false
      },() => {
        this.loading = false
      }, this)
    },
    deleteShare(id) {
      this.loading = true
      UI.runConfirmedAction('fal fa-trash-alt', 'DELETE', 
      'Revoke access', 'The access to these files will be revoked. Are you sure?', 
      `/api/v1/shareable/${id}`, () => {
          this.$swal('Done', 'Access has been revoked', 'success')
          this.loading = false
          $(`tr[data-id=${id}`).remove()
      },() => {
        this.loading = false
      }, this)
    }
  }
}
</script>