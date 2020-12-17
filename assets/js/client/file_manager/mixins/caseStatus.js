import sort from 'fast-sort'
export default {
    data() {
        return {
            caseStatuses: [],
            completed: [],
            started: []
        }
    },
    computed: {
        orderedStatuses() {
            return sort(this.caseStatuses).asc(s => s.order)
        }
    },
    methods: {
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
            }).catch((err) => {

            })
        }
    }
}