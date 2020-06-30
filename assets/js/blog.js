import Quill from 'quill/dist/quill'
import Users from './users'
import Swal from 'sweetalert2'
import Uppy from '@uppy/core'
import DragDrop from '@uppy/drag-drop'
import ProgressBar from '@uppy/progress-bar'
import XHRUpload from '@uppy/xhr-upload'
import Plyr from 'plyr'
const blogAttachmentsStorageKey = 'blogAttachments'

const blogAttachmentStorage = () =>  {
  return window.localStorage.getItem(blogAttachmentsStorageKey)
}

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
    .use(XHRUpload, {
      endpoint: '/api/v1/blog/post/upload',
      formData: true,
      fieldName: 'files[]',
      headers: {
        'Authorization': `Bearer ${window.localStorage.getItem('jwt')}`
      }
    })
    .use(ProgressBar, { target: '.for-ProgressBar', hideAfterFinish: false })
    .on('upload-success', onUploadSuccess)
}

const onUploadSuccess = (file, response) => {
  response.body.forEach(dbFile => {
    const url =`/blog/post/attachment/${dbFile.id}`
    const deleteUrl = `/blog/post/attachment/${dbFile.id}/delete`
    addUploadedFileId(dbFile.id)
    document.querySelector('.uploaded-files ol').innerHTML +=
    `<li data-id='${dbFile.id}'>
      <a href="${url}" target="_blank" class='inline-edit cui-utils-link-underlined cui-utils-link-blue'>
        <i class='icmn-download2'></i>&nbsp;${file.name}
      </a>
      <a href='#' data-url=${deleteUrl} class='del-battach btn btn-icon btn-danger btn-xs btn-rounded mr-2 mb-2'>
        <i class='fas fa-minus-circle'></i>
      </a>
    </li>`
    deleteBlogAttachment(dbFile.id)
  })
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
            tag_list: tags.join(','),
            attachment_ids: attachmentData()
          }
        }
      }).done(() => {
        clearStorage()
        window.location.href = '/newsfeed'
      }).catch(err => {
        clearStorage()
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

const serializedAttachmentsStorage = () => {
  return JSON.parse(blogAttachmentStorage())
}

const deserializeAttachmentStorage = (data) => {
  window.localStorage.setItem(blogAttachmentsStorageKey, JSON.stringify(data))
}

const addUploadedFileId = (fileId) => {
  if (!blogAttachmentStorage()) {
    window.localStorage.setItem(blogAttachmentsStorageKey, '[]')
  }
  let storage = serializedAttachmentsStorage()
  storage.push(fileId)
  deserializeAttachmentStorage(storage)
}

const clearStorage = () => {
  window.localStorage.removeItem(blogAttachmentsStorageKey)
}

const attachmentData = () => {
  return JSON.parse(blogAttachmentStorage())
}

const deleteBlogAttachment = (fileId) => {
  $(document).off('click.del-blog-attach').on('click.del-blog-attach', 'a.del-battach', function() {
    UI.runConfirmedAction(
      'fas fa-trash-alt', 
      'DELETE',
      'Remove attachment',
      '', $(this).attr('data-url'),
      () => {
        $(`li[data-id='${fileId}']`).remove()
      })
  })
}

const initVideoPlayer = () => {
   const players = {}

   Array.from(document.querySelectorAll('video')).forEach(video => {
      players[video.id] = new Plyr(video)
   })
   return players
}

const initAudioPlayer = () => {
  const players = {}

  Array.from(document.querySelectorAll('audio')).forEach(audio => {
     players[audio.id] = new Plyr(audio)
  })
  return players
}

const deleteNewsfeedPost = () => {
  $(document).off('click.del-np').on('click.del-np', 'a.del-newsfeed-post', function() {
    let id = $(this).data('id')
    UI.runConfirmedAction(
      'fas fa-trash-alt', 
      'DELETE',
      'Delete newsfeed post',
      'You will not be able to revert this', 
      $(this).attr('data-url'),
      () => {
        debugger
        $(`article[data-id='${id}']`).remove()
    })
  })
}

const onPostTypeChange = () => {
  $('input.post-type').on('change', function() {
    let value = $(this).val()
    if (value === 'external_link') {
      runExtractionFromUrl()
    } else {
      window.extractSwal.hide()
      resetForm()
    }
  })
}

const resetForm = () => {
  $("input#post_title").val('')
  window.quill.root.innerHTML = ''
  $('select.select2-tags').val('').trigger('change')
}

const runExtractionFromUrl = () => {
  window.extractSwal = Swal.fire({
    input: 'text',
    icon: 'info',
    title: "Please enter article url",
    inputAttributes: {
      autocapitalize: 'off'
    },
    showCancelButton: true,
    confirmButtonText: '<i class="fas fa-upload"></i>&nbsp;Extract',
    showLoaderOnConfirm: true,
    preConfirm: (url) => {
      return fetch(`/api/v1/url/extraction/new?url=${url}`, {
        headers: {
          "Authorization" : `Bearer ${window.localStorage.getItem('jwt')}`
        }
      })
        .then(response => {
          if (!response.ok) {
            throw new Error(response.statusText)
          }
          return response.json()
        })
        .catch(error => {
          Swal.showValidationMessage(
            `Request failed: ${error}`
          )
        })
    },
    allowOutsideClick: () => !Swal.isLoading()
  }).then((result) => {
    if (result.value) {
      $("input#post_title").val(result.value.title)
      window.quill.root.innerHTML = `${result.value.description}
      <p><img src='${result.value.image64}' alt='${result.value.title}'/></p>
      <p><a href='${result.value.url}' target="_blank">Link to the source</a><p>`
      addExternalTag()
    } else {
      $('input.post-type[value="own"]')
        .prop('checked', true)
      resetForm()
    }
  })
}

const addExternalTag = () => {
  let opt = new Option('external','external', true, true)
  $("select#post_tag_list").append(opt).trigger('change')
}
 
export default {
  initQuill,
  clearErorrs,
  attachmentData,
  initVideoPlayer,
  initAudioPlayer,
  deleteNewsfeedPost,
  init() {
    clearStorage()
    initQuill('#post_body')
    initUppy()
    onBlogPostSubmit()
    onPostTypeChange()
  }
}