import { mapState } from 'vuex'

export default {
    computed: {
        ...mapState(['selectedEmails']),
        name() {
            return this.provider.name
        },
        loadEmailsUrl() {
            return `/api/v1/email_inbox?id=${this.mlcId}&provider=${this.name}&page=${this.page}`
        },
        mlcId() {
            return window.localStorage.getItem('currentMedicoLegalCaseId')
        }
    },
    methods: {
        refresh() {
            return $.getJSON(`/api/v1/email_inbox/refresh/${this.mlcId}`)
        },
        loadEmails(emailUrl) {
            return $.getJSON(emailUrl)
        }
    }
}