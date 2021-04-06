import UI from '../ui'
import Uppy from '@uppy/core'
import ThumbnailGenerator from '@uppy/thumbnail-generator'
import ProgressBar from '@uppy/progress-bar'
import DragDrop from '@uppy/drag-drop'
import XHRUpload from '@uppy/xhr-upload'
import 'cropperjs/dist/cropper.css';
import Cropper from 'cropperjs';
import Swal from 'sweetalert2'
import '@uppy/drag-drop/dist/style.css'
import { debug } from 'phoenix_live_view'
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
  return window.cropper.getCroppedCanvas({
    fillColor: '#fff',
  }).toDataURL("image/jpeg")
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
  uppy.use(ProgressBar, {
    target: '.for-ProgressBar',
    hideAfterFinish: true
  })
	uppy.use(DragDrop, {
		target: '.for-sig-DragDrop',
		width: 600,
		height: 200
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
  uppy.on('complete', (result) => {
    window.location.reload(true)
  })
	styleUppy()
	positionHeader()
}

const styleUppy = () => {
	$(".uppy-DragDrop-container").css('background-image', `url(${$("div#logo-preview img").attr('src')})`)
	$(".uppy-DragDrop-container").css('object-fit', 'cover')
	$("div#logo-preview").hide()
	$("div.uppy-DragDrop-inner").hide()
	$(".uppy-DragDrop-container").css('background-repeat', 'no-repeat')
	$(".uppy-DragDrop-container").css('background-position', 'center')
	$(".uppy-DragDrop-container").css('background-size', 'contain')
}

const positionHeader = () => {
	if (window.location.pathname !== '/profile') {
		$('h5.sig-header').addClass('positioned')
	} else {
		$('h5.sig-header').removeClass('positioned')
	}
}

const initCropping = () => {
  if ($('#signature-image-file').length > 0) {
    const image = document.getElementById('signature-image-file');
    window.cropper = new Cropper(image, {
			movable: true,
      zoomable: true,
      rotatable: true,
      scalable: true, 
      crop(event) {
       
      },
    })
	 setupCropping(image)
 	 saveCropping()
  }
}

const setupCropping = (image) => {
	$('a.crop-option').on('click', function(e) {
		const target = e.target
		e.stopPropagation()
		e.preventDefault()
		const data = {
			method: $(this).data("method"),
			target: $(this).data("target"),
			option: $(this).data("option") || undefined,
			secondOption: $(this).data("second-option") || undefined
		}
		if (data.method) {
			if (typeof data.target !== 'undefined') {
				input = document.querySelector(data.target);
		
				if (!target.hasAttribute('data-option') && data.target && input) {
					try {
						data.option = JSON.parse(input.value);
					} catch (e) {
						console.log(e.message)
					}
				}
			}
			window.cropper[data.method](data.option, data.secondOption)
		}
	})
}

const saveCropping = () => {
	$(document).off('click.save-signature')
		.on('click.save-signature', "a#save-cropped-signature", 
			function() {
				Swal.fire({
					title: 'Save area?',
					text: "Save selected area as new users signature?",
					icon: 'warning',
					showCancelButton: true,
					confirmButtonText: 'Save'
				}).then((result) => {
					if (result.isConfirmed) {
						requestUpdateSignature()
					} 
				})
		})
	}

export default {
  uploadSignature,
  initCropping,
  saveCropping,
	setupCropping,
	positionHeader,
  init() {
    uploadSignature()
    initCropping()
    saveCropping()
		setupCropping()
    UI.confirmDialog(() => {
      window.location.reload(true)
    })
		positionHeader()
  }
}