
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

const collapseExpand = () => {
  $(document).on('click', 'button.btn-link', function() {
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

export default {
  init() {
    if ($('#glossary_of_term_description').length > 0) {
      Editor.init('#glossary_of_term_description')  
    }
    onGlossaryItemsSubmit()
    onGlossaryTabChange()
    searchGlossaryItems()
    initInlineEdit()
  }
}