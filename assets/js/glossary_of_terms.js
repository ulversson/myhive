import Swal from 'sweetalert2'

const onGlossaryItemsSubmit = () => {
  $("a#save-and-post-got").on('click', function(e) {
    e.preventDefault()
    let name = $("input#glossary_of_term_name").val().trim()
    let content = quill.root.innerHTML
    let shortName = $("input#glossary_of_term_short_name").val().trim()
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
            description: content,
            short_name: shortName
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

const collapseExpand = () => {
  $(document).on('click', 'a.btn-link', function() {
    const id = $(this).parent().parent().attr("id").replace("h","")
    $(`div.collapse[id='${id}']`).collapse()
  })
}

const onGlossaryTabChange = () => {
  $('a.nav-link').on('click', function() {
    const target = $(this).data('target').replace('#','')
    $('div.tab-pane').removeClass('active')
    $(`div.tab-pane[id="${target}"]`).addClass('active')
    loadGlossaryItems(target)
  })
  collapseExpand()
  setTimeout(() => {
    $("ul.got li.nav-item:first a")
      .click()
  }, 200)
}

const loadGlossaryItems = (letter) => {
  $.get(`/glossary/${letter}/items`, function(htmlRes) {
     $(`div.tab-pane[id="${letter}"]`).html(htmlRes)
  })
}

const loadGlossaryItemsByQuery = (q) => {
  $.get(`/glossary/search?q=${q}`, function(htmlRes) {
     $(`div.tab-pane.active`).html(htmlRes)
  })
}

const searchGlossaryItems = () => {
  $("input#livesearch-input").on('keyup paste', function() {
    const query = $(this).val().trim()
    loadGlossaryItemsByQuery(query)
  })
}

const initInlineEdit = () => {
  $(document).on('dblclick', 'div.got-description', function(){
    const id = $(this).data('id')
    const selector =`div.got-description[data-id="${id}"]`
    if ($(`div.got-description[data-id='${id}'] .ql-editor`).length === 0) {
      const quill = Editor.glossaryOfTerms(selector, () => {
        updateField(id, "description", quill.root.innerHTML)
        Editor.destroyEditor(selector)
      })
    }
  })
}

const updateField = (id, field, value) => {
  return $.ajax({
    type: 'PATCH',
    url: `/glossary/${id}/update`,
    data: {
      "_csrf_token" : UI.csrfToken(),
      field: field,
      value: value
    }
  })
}

const inlineEditTextField = () => {
  $(document).on('dblclick', 'span.inline-edit', function(){
    const fieldType = $(this).data('field')
    const id = $(this).data('id')
    const originalText = $(this).text().trim()
    const value = $(this).text().trim()
      .replaceAll(")","").replaceAll("(","")
    const input = `<input type='text' data-original-text="${originalText}" class='form-control inline-editing' data-id='${id}' data-field="${fieldType}" value="${value}" />
      <a class='btn btn-xs btn-outline-success save-inline' data-id="${id}" data-field='${fieldType}'><i class='fal fa-save'></i>&nbsp;Save</a>
      <a class='btn btn-xs btn-outline-secondary cancel-inline' data-id="${id}" data-field='${fieldType}'><i class='fal fa-ban'></i>&nbsp;Cancel</a><br/>`
    const selector = `input.inline-editing[data-id="${id}"][data-field="${fieldType}"]`

    if ($(selector).length === 0) {
      $(this).html(input)
    }
  })   

} 

const cancelInlineEdit = () => {
  $(document).on('click', 'a.cancel-inline', function(){
    const id = $(this).data('id')
    const fieldType = $(this).data("field")
    const originalText = $(`input[data-id="${id}"][data-field="${fieldType}"]`).attr("data-original-text")
    $(`span.inline-edit[data-id="${id}"][data-field="${fieldType}"`)
      .html(originalText)
  })
}

const saveInlineEdit =  () => {
  $(document).on('click', 'a.save-inline', function(){
    const id = $(this).data('id')
    const fieldType = $(this).data("field")
    const text = $(`input[data-id="${id}"][data-field="${fieldType}"]`).val().trim()
    if (!text) {
      Swal.fire(
        'Error', 'Field cannot be empty', 'error'
      )
    } else {
      updateField(id, fieldType, text)
        .then((res) => {
          $(`span.inline-edit[data-id="${id}"][data-field="${fieldType}"`)
            .html(text)
      })
    }
   
  })
}

const removeGlossaryItem = () => {
  $(document).on('click', 'a.delete-got-item', function(){
    const id = $(this).data('id')
    UI.runConfirmedAction(
      'fal fa-trash-alt', 
      'DELETE', 
      'Remove this item',
      'This action cannot be reversed', 
      '/glossary/'+id, 
      () => {
        debugger
        $(`div.card.glossary-of-term[data-id="${id}"]`).remove()
      }
    )
  })
}

export default {
  init() {
    if ($('#glossary_of_term_description').length > 0) {
      Editor.init('#glossary_of_term_description')  
    }
    onGlossaryItemsSubmit()
    onGlossaryTabChange()
    searchGlossaryItems()
    initInlineEdit()
    inlineEditTextField()
    cancelInlineEdit()
    saveInlineEdit()
    removeGlossaryItem()
  }
}