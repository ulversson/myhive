import Editor from './editor'
const initEditorWithVariables = (id, content) => {
  $.ajax({
    type: "GET",
    url: `/api/v1/email_template/${id}`,
  }).done((jsRes) => {
    let drodpownItems = {}
    jsRes.data.forEach((variable, index) => {
      drodpownItems[variable.name] = variable.code
    })
    Editor
      .initWithExtraDropdownItems('#email_template_body', drodpownItems, content)
  })
}

const updateTemplate = () => {
  UIError.clearErorrs()
  $(document).off('click.save-etemplate')
    .on('click.save-etemplate', 'a#update-template', function(e) {
      let itemId = $(this).data('id')
      e.preventDefault()
      let name = $("input#email_template_name").val().trim()
      let subject = $("input#email_template_subject").val().trim()
      let desc = $("textarea#email_template_description").val().trim()
      let content = window.quill.root.innerHTML
      let caseRef = $("input[type='radio']:checked").val()
      if (Editor.isQuillEmpty()) {
        Editor.addQuillError("span#email_template_body")
      } else {
        $.ajax({
          type: 'PATCH',
          url: `/email_template/${itemId}`,
          data: {
            '_csrf_token': UI.csrfToken(),
            email_template: {
              name: name,
              description: desc,
              include_case_reference: caseRef,
              subject: subject,
              body: content
            }
          }
        }).done(() => {
          UI.showAndFadeOutFlash('Template has been successfully updated', 'info')
        }).catch(err => {
          UIError.errorResponse(err, 'email_template')
        })
      }
  })
}

export default {
  initEditorWithVariables,
  init() {
    updateTemplate()
  }
}