/////////////////////////////////////////////////////////////////////////////////////////
// "cui-menu-right" module scripts
;
(function($) {
    'use strict'
    $(function() {
        $('.cui-menu-right-action-toggle, .time-sheet-toggle').on('click', function() {
            $('body').toggleClass('cui-menu-right-visible')
            if ($('body').hasClass('cui-menu-right-visible')) {
                UI.autocompleteSearch('select#user-search', false)
            }
        })

          $('.cui-menu-right-action-toggle-mlc-details, .mlc-details-toggle').on('click', function() {
            $('body').toggleClass('cui-menu-right-visible-mlc-details')
            var isVisible = $('body').hasClass('cui-menu-right-visible-mlc-details')
            if (isVisible) {
                var caseId =window.localStorage.getItem('currentMedicoLegalCaseId')
                window.currentCase.$root.$children[0].loadCaseData(caseId)
            }
        })

        $('.cui-menu-right-action-toggle-inbox, .email-toggle').on('click', function() {
            $('body').toggleClass('cui-menu-right-visible-inbox')
            var isVisible = $("body").hasClass("cui-menu-right-visible-inbox")
            if (isVisible) {
                window.inbox.$root.$children[0].$refs.prov[0].refreshData()
            }
        })
    })
})(jQuery)