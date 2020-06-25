import Quill from 'quill/dist/quill'
import Users from './users'
import Swal from 'sweetalert2'
const Uppy = require('@uppy/core')
const DragDrop = require('@uppy/drag-drop')
const ProgressBar = require('@uppy/progress-bar')
const Tus = require('@uppy/tus')

const initQuill = (container) => {
  let Delta = Quill.import('delta')
  let toolbarOptions = [
    [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
    [{ 'font': [] }],
    ['bold', 'italic', 'underline'],   
    [ 'link', 'image'],          // add's image support    // toggled buttons
    ['blockquote', 'code-block'],
    [{ 'list': 'ordered'}, { 'list': 'bullet' }],
    [{ 'script': 'sub'}, { 'script': 'super' }],      // superscript/subscript
    [{ 'indent': '-1'}, { 'indent': '+1' }],          // outdent/indent  
    [{ 'color': [] }, { 'background': [] }],          // dropdown with defaults from theme
    [{ 'align': [] }],
    ['clean']                                         // remove formatting button
  ]
  window.quill = new Quill(container, {
    modules: {
      toolbar: toolbarOptions
    },
    placeholder: 'Write your important message here...',
    theme: 'snow'
  })

  var change = new Delta()
  quill.on('text-change', function(delta) {
    change = change.compose(delta)
    clearErorrs()
  })
}

const initUppy = () => {
  const uploader = new Uppy({ debug: true, autoProceed: true })
  uploader
    .use(DragDrop, { target: '.for-DragDrop' })
    .use(Tus, { endpoint: 'https://master.tus.io/files/' })
    .use(ProgressBar, { target: '.for-ProgressBar', hideAfterFinish: false })
    .on('upload-success', onUploadSuccess('.uploaded-files ol'))
}

const onUploadSuccess = (elForUploadedFiles) => (file, response) => {
  const url = response.uploadURL
  const fileName = file.name

  document.querySelector(elForUploadedFiles).innerHTML +=
    `<li><a href="${url}" target="_blank">${fileName}</a></li>`
}

const onBlogPostSubmit = () => {
  $("a#save-and-post").on('click', function(e) {
    e.preventDefault()
    let title = $("input#post_title").val().trim()
    let postType = $("input.post-type:checked").val()
    let content = quill.root.innerHTML;
    let tags = $("select#post_tag_list").val()
    if (isQuillEmpty()) {
      addQuillError()
    } else {
      $.ajax({
        type: 'POST',
        url: '/blog/post',
        data: {
          '_csrf_token': UI.csrfToken(),
          post: {
            title: title,
            post_type: postType,
            author_id: Users.currentUserId(),
            body: content,
            tag_list: tags.join(',')
          }
        }
      }).done(() => {
        window.location.href = '/newsfeed'
      }).catch(err => {
        errorResponse(err)
      })
    }
  })
}

const clearErorrs = () => {
  $(".is-invalid").removeClass('is-invalid')
  $('span.invalid-feedback').html('')
}
const addQuillError = () => {
  $("div.quill").addClass('is-invalid')
  $("span#post_body").html('cannot be empty')
}
const errorResponse = (err) => {
  clearErorrs()
  if (err.status === 422) {
    let responseJson = JSON.parse(err.responseText)
    renderJsonErrors(responseJson.errors)
  }
  else {
    Swal.fire("Error", "The server responded with error", 'error')
  }
}
const isQuillEmpty = () => {
  if ((window.quill.getContents()["ops"] || []).length !== 1) { return false }
  return window.quill.getText().trim().length === 0
}

const renderJsonErrors = (errors) => {
  for (let [key, value] of Object.entries(errors)) {
    let span = `span#post_${key}`
    let errorString  = value.join(',')
    $(span).prev().addClass('is-invalid')
    $(span).html(errorString)
  }
}

export default {
  initQuill,
  clearErorrs,
  init() {
    initQuill('#post_body')
    initUppy()
    onBlogPostSubmit()
  }
}