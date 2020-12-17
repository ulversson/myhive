import sort from 'fast-sort'
export default {
    data() {
        return {
            caseStatuses: [],
            completed: [],
            started: [],
            total: 0
        }
    },
    computed: {
        orderedStatuses() {
            return sort(this.caseStatuses).asc(s => s.order)
        }
    },
    methods: {
        updateSum() {
            debugger
            this.total = this.totalSum()
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
            return this.caseStatuses.map(s => {
                return this.percentage(s)
            }).reduce((a, b) => a + b, 0)
        },
        loadCaseStatuses() {
            this.caseStatuses.splice(0, this.caseStatuses.length)
            let medicoLegalCaseId = this.$store.state.currentMedicoLegalCaseId
            $.ajax({
                type: 'GET',
                url: `/api/v1/medico_legal_cases/${medicoLegalCaseId}/stages`,
            }).done((jsRes) => {
                jsRes.data.forEach(stage => {
                    this.caseStatuses.push(stage)
                })
                jsRes.started.forEach(stage => {
                    this.started.push(stage.order)
                })
                jsRes.completed.forEach(stage => {
                    this.completed.push(stage.order)
                })
                this.total = this.totalSum()
            }).catch((err) => {

            })
        }
    }
}