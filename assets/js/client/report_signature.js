import UI from '../ui'
import Uppy from '@uppy/core'
import ThumbnailGenerator from '@uppy/thumbnail-generator'
import FileInput from '@uppy/file-input'
import ProgressBar from '@uppy/progress-bar'
import XHRUpload from '@uppy/xhr-upload'
import 'cropperjs/dist/cropper.css';
import Cropper from 'cropperjs';
import Swal from 'sweetalert2'
const signatureId = () => {
  let userId = window.location.href.split("/")[5]
  if (!userId) {
    return 'me'
  } else {
    return userId;
  }
}

const requestUrl = () =>  {
 return  `/user/${signatureId()}/signature`
}

const imageData = () => {
  return window.cropper.getCroppedCanvas()
    .toDataURL("image/jpeg")
    .replace(/^data:image\/(png|jpg|jpeg);base64,/, "");
}
 
const requestUpdateSignature = () => {
  $.ajax({
    type: 'PATCH',
    url: requestUrl(),
    data: {
      content: imageData(),
      id: signatureId(),
      "_csrf_token": UI.csrfToken()
    }
  }).done((r) => {
    window.location.reload(true)
  })
}

const uploadSignature = () => {

  let csrfToken = document.querySelector("meta[name='csrf-token']")
      .getAttribute("content")

  if ($('div.signature-form').length === 0) return
  const uppy = new Uppy({ 
    autoProceed: true,
    allowMultipleUploads: false,
    restrictions: {
      allowedFileTypes: ['image/*']
    }, 
  })
  uppy.use(FileInput, {
    target: 'div.signature-form',
    pretty: true, 
    locale: {
        strings: {
          chooseFiles: 'Choose signature image'
        },
    },
    replaceTargetContent: true
  })
  uppy.use(ProgressBar, {
    target: '.for-ProgressBar',
    hideAfterFinish: true
  })
  uppy.use(XHRUpload, {
    endpoint: requestUrl(),
    headers: {
      'x-csrf-token': csrfToken
    },
    formData: true,
    limit: 1,
    fieldName: 'files[]'
  }) 
  uppy.use(ThumbnailGenerator, {
    id: 'ThumbnailGenerator',
    thumbnailWidth: 200,
    thumbnailHeight: 200,
    waitForThumbnailsBeforeUpload: false
  })
  uppy.on('complete', (result) => {
    window.location.reload(true)
  })
}

const initCropping= () => {
  if ($('#signature-image-file').length > 0) {
     const image = document.getElementById('signature-image-file');
    window.cropper = new Cropper(image, {
      aspectRatio: 2/1,
      crop(event) {
       
      },
    })
  saveCropping()
  }
}

const saveCropping = () => {
  $(document).off('click.save-signature')
    .on('click.save-signature', "a#save-cropped-signature", 
      function() {
        debugger

        Swal.fire({
          title: 'Save area?',
          text: "Save selected area as new users signature?",
          icon: 'warning',
          showCancelButton: true,
          confirmButtonText: 'Save'
        }).then((result) => {
          debugger
          if (result.isConfirmed) {
            requestUpdateSignature()
          } 
        })
    });
 }
  //

export default {
  uploadSignature,
  initCropping,
  saveCropping,
  init() {
    uploadSignature()
    initCropping()
    saveCropping()
    UI.confirmDialog(() => {
      window.location.reload(true)
    })
  }
}