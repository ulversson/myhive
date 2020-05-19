import UI from './ui'
import Uppy from '@uppy/core'
import ThumbnailGenerator from '@uppy/thumbnail-generator'
import FileInput from '@uppy/file-input'
import ProgressBar from '@uppy/progress-bar'
import XHRUpload from '@uppy/xhr-upload'
import 'jquery.fancytree/dist/skin-bootstrap-n/ui.fancytree.css'
import 'jquery.fancytree/dist/modules/jquery.fancytree.glyph'
import {createTree} from 'jquery.fancytree'

const uploadAccountLogo = () => {
  let csrfToken = document.querySelector("meta[name='csrf-token']")
      .getAttribute("content")
  const uppy = new Uppy({ 
    autoProceed: true,
    allowMultipleUploads: false,
    restrictions: {
      allowedFileTypes: ['image/*']
    }, 
  })
  uppy.use(FileInput, {
    target: 'div.uppy-form',
    pretty: true, 
    locale: {
        strings: {
          chooseFiles: 'Choose logo'
        },
    },
    replaceTargetContent: true
  })
  uppy.use(ProgressBar, {
    target: '.for-ProgressBar',
    hideAfterFinish: true
  })
  uppy.use(XHRUpload, {
    endpoint: '/settings/upload/logo',
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

const enableFormSubmit = () => {
  $("button#accounts-submit").on('click', () => {
    $("form#settings-form").submit()
  })
}
const setupNewFolderTreeForm = () => {
  $('input[type="file"]').on("change", function() {
    let filenames = []
    let files = document.getElementById("case_folder_tree_uploaded_file").files
    if (files.length > 1) {
      filenames.push("Total Files (" + files.length + ")")
    } else {
      for (let i in files) {
        if (files.hasOwnProperty(i)) {
          filenames.push(files[i].name)
        }
      }
    }
    $(this)
      .next(".custom-file-label")
      .html(filenames.join(","))
  })
}

const showCaseFolderTree = () => {
  $(document).on('click', 'a.show-case-folder-tree', function() {
    let tree = $(this).data('tree')
    let fancytree = transformTree(tree)
    let name = $(this).data('name')
    let id = $(this).data('id')
    $.showAlert({
      title: name, 
      modalClass: 'tree-modal fade',
      body: `<div id='${id}_tree'></div>`
    })
    $('div.tree-modal').on('shown.bs.modal', function(){
      createTree(`#${id}_tree`, {
        source: fancytree,
        theme: 'boostrap',
        extensions: ['glyph'],
        glyph: {
          preset: "awesome4",
          map: {}
        }
      })
    })
  })
}

const transformTree = (tree) => {
  let newTree = []
  Object.keys(tree).forEach((itemName, index) => {
    let treeValue = tree[itemName]
    if (treeValue && treeValue.constructor === Object) {
        newTree.push({
          title: itemName,
          id: index, 
          icon: 'fas fa-folder',
          children: transformTree(tree[itemName])
        }) 
    } else if (treeValue && treeValue.constructor === Array) {
      newTree.push({
        title: itemName,
        id: index, 
        icon: 'fas fa-folder',
        children: tree[itemName].map((child) => {
          return {
            title: child, 
            id: `1_${index}`,
            icon: 'fas fa-folder'
          }
        })
      })
    } else {
        newTree.push({
          title: itemName,
          id: index, 
          icon: 'fas fa-folder'
        }) 
    }
  })
  return newTree  
}

const hideSubmitIfIrrelevant = (active) => {
  if (active === '#medic-legal-cases' || active === '#app-modules') {
    $("button#accounts-submit").hide()
    $("button#accounts-submit").next().hide()
  } else {
    $("button#accounts-submit").show()
    $("button#accounts-submit").next().show()
  }
}

const hideSubmitIfIrrelevantOnClick  = () => {
  if (window.location.hash) {
    hideSubmitIfIrrelevant(window.location.hash)
  }
  $("a.nav-link").click(function() {
    let href = $(this).attr('href')
    hideSubmitIfIrrelevant(href)
  })
}

const activateDeactivateModule = () => {
  $('input.app-module-activator').on('change', function(e){
    let isChecked = $(this).prop('checked')
    let moduleId = $(this).data('id')
    e.stopPropagation()
    if (isChecked) {
      runActivateModuleAction(moduleId, this)
    } else {
      runDeactivateModuleAction(moduleId, this)
    }
  })
}

const runActivateModuleAction = (id, button) => {
  let amount = $(this).data('amount')
  let dataIcon = "fas fa-check"
  let title = "Activate this module"
  let text = `Would you like to activate this module and add £${amount} to your monthly bill?`
  let requestUrl = `/app_module/${id}/activate`
  UI.runConfirmedAction(dataIcon, "PATCH", title, text, requestUrl, () => {
    window.location.reload(true)
  }, () => {
    $(button).bootstrapToggle('off', true)
  })
}

const runDeactivateModuleAction = (id, button) => {
  let dataIcon = "fas fa-question-circle"
  let title = "Deactivate this module"
  let text = `Would you like to deactivate this module and and deacrease your monthly payment?`
  let requestUrl = `/app_module/${id}/deactivate`
  UI.runConfirmedAction(dataIcon, "PATCH", title, text, requestUrl, () => {
    window.location.reload(true)
  }, () => {
    
    $(button).bootstrapToggle('on', true)
  })
}

export default {
  uploadAccountLogo,
  setupNewFolderTreeForm,
  init() {
    UI.setupBritishPhoneMask("account_address_phone_number")
    uploadAccountLogo()
    enableFormSubmit()
    showCaseFolderTree()
    UI.setup()
    UI.confirmDialog(() => {
      setTimeout(() => 
        window.location.reload(true)
      , 2500)
    })
    hideSubmitIfIrrelevantOnClick()
    activateDeactivateModule()
  }
}


