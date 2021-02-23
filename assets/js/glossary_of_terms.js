
const onGlossaryItemsSubmit = () => {
  $("a#save-and-post-got").on('click', function(e) {
    e.preventDefault()
    let name = $("input#glossary_of_term_name").val().trim()
    let content = quill.root.innerHTML;
    if (Editor.isQuillEmpty()) {
      Editor.addQuillError("span#post_body")
    } else {
      $.ajax({
        type: 'POST',
        url: '/glossary',
        data: {
          '_csrf_token': UI.csrfToken(),
          glossary_item: {
            name: name,
            description: content
          }
        }
      }).done(() => {
        window.location.href = '/glossary'
      }).catch(err => {
        UIError.errorResponse(err, 'glossary_of_term')
      })
    }
  })
}
export default {
  init() {
    Editor.init('#glossary_of_term_description')
    onGlossaryItemsSubmit()
  }
}