import sort from 'fast-sort'
import { mapState } from 'vuex'

export default {
    data() {
        return {
            completed: [],
            started: [],
            total: 0
        }
    },
    computed: {
        ...mapState(['medicoLegalCaseStatuses']),
        orderedStatuses() {
            return sort(this.medicoLegalCaseStatuses).asc(s => s.order)
        }
    },
    methods: {
        updateSum() {
            this.total = this.totalSum()
            this.$root.$emit('timeline', {
                show: true,
                sum: this.totalSum()
            })
        },
        setStatuses(data) {
            this.$store.commit('setMedicoLegalCaseStatuses', data)
        },
        isStartedStage(status) {
            return status.started_at !== null && status.completed_at === null
        },
        isCompletedStage(status) {
            return status.started_at !== null && status.completed_at !== null
        },
        isNotStartedStage(status) {
            return status.started_at === null && status.completed_at === null
        },
        percentage(status) {
            if (this.isNotStartedStage(status)) return 0
            if (this.isStartedStage(status)) {
                return status.percentage_value / 2
            } else if (this.isCompletedStage(status)) {
                return parseFloat(status.percentage_value)
            } else {
                return 0
            }
        },
        totalSum() {
            return this.medicoLegalCaseStatuses.map(s => {
                return this.percentage(s)
            }).reduce((a, b) => a + b, 0)
        },
        loadCaseStatuses() {
            this.$store.commit('setMedicoLegalCaseStatuses', [])
            let medicoLegalCaseId = this.$store.state.currentMedicoLegalCaseId
            $.ajax({
                type: 'GET',
                url: `/api/v1/medico_legal_cases/${medicoLegalCaseId}/stages`,
            }).done((jsRes) => {
                this.setStatuses(jsRes.data)
                jsRes.started.forEach(stage => {
                    this.started.push(stage.order)
                })
                jsRes.completed.forEach(stage => {
                    this.completed.push(stage.order)
                })
                this.total = this.totalSum()
                this.$root.$emit('timeline', {
                    show: this.medicoLegalCaseStatuses.length > 0,
                    sum: this.totalSum()
                })
            }).catch((err) => {

            })
        }
    }
}