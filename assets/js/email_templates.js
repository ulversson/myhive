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
      .initWithExtraDropdownItems(
        '#email_template_body', 
        drodpownItems, content
      )
  })
}

const createTemplate = () => {
  UIError.clearErorrs()
  $(document).off('click.cr-etemplate')
    .on('click.cr-etemplate', 'a#save-template', function(e) {
      e.preventDefault()
      let name = $("input#email_template_name").val().trim()
      let content = window.quill.root.innerHTML
      if (Editor.isQuillEmpty()) {
        Editor.addQuillError("span#email_template_body")
      } else {
        $.ajax({
          type: 'POST',
          url: `/email_template`,
          data: {
            '_csrf_token': UI.csrfToken(),
            email_template: {
              name: name,
              variables_list: $("select#email_template_variables_list").val().join(","),              
              body: content
            }
          }
        }).done(() => {
          window.location.href="/email_templates"
        }).catch(err => {
          UIError.errorResponse(err, 'email_template')
        })
      }
  })
}

const updateTemplate = () => {
  UIError.clearErorrs()
  $(document).off('click.save-etemplate')
    .on('click.save-etemplate', 'a#update-template', function(e) {
      let itemId = $(this).data('id')
      e.preventDefault()
      let name = $("input#email_template_name").val().trim()
      let content = window.quill.root.innerHTML
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

const bindVariablesSearch = () => {
  $('select#email_template_variables_list').select2({
    ajax: {
      delay: 250,
      url: '/api/v1/email_templates/variables',
      dataType: 'json'
    },
  })
}

export default {
  initEditorWithVariables,
  init() {
    createTemplate()
    updateTemplate()
    bindVariablesSearch()
  }
}