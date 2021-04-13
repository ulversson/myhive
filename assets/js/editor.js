import QuillTools from './dynamic-quill-tools'
import QuillImageDropAndPaste from 'quill-image-drop-and-paste'
Quill.register('modules/imageDropAndPaste', QuillImageDropAndPaste)

var Block = Quill.import('blots/block')
const icons = Quill.import('ui/icons')
const Parchment = Quill.import("parchment")

Block.tagName = 'DIV';
Quill.register(Block, true);

const commonToolbar = () => {
  return [
    [{ header: [1, 2, 3, 4, 5, 6, false] }],
    [{ font: [] }],
    ["bold", "italic", "underline"],
    ["link", "image"], // add's image support    // toggled buttons
    ["blockquote", "code-block"],
    [{ list: "ordered" }, { list: "bullet" }],
    [{ script: "sub" }, { script: "super" }], // superscript/subscript
    [{ indent: "-1" }, { indent: "+1" }], // outdent/indent
    [{ color: [] }, { background: [] }], // dropdown with defaults from theme
    [{ align: [] }],
    ["clean"], // remove formatting button
  ]
}

const init = (container, placeholderText = "Write your important message here...") => {
  let Delta = Quill.import("delta")
  window.quill = new Quill(container, {
    modules: {
      toolbar: commonToolbar(),
      imageDropAndPaste: {},
      imageResize: {
        displaySize: true
      },
      clipboard: {
        matchVisual: false
      },
    },
    placeholder: placeholderText,
    theme: "snow",
  });

  var change = new Delta()
  quill.on("text-change", function(delta) {
    change = change.compose(delta)
    UIError.clearErorrs()
  })
}

const glossaryOfTerms = (container, saveCallback) => {
  let Delta = Quill.import("delta")
  let quill = new Quill(container, {
    modules: {
      toolbar: [
            ['bold', 'italic', 'underline', 'strike'],    
            [{ 'list': 'ordered'}, { 'list': 'bullet' }], ['save', 'ban'], ['clean']],
      imageDropAndPaste: {},
      imageResize: {
        displaySize: true
      },
      clipboard: {
        matchVisual: false
      },
    },
    placeholder: "",
    theme: "snow",
  });
  addButton('save', () => {
    saveCallback()
  })
  addButton('ban', () => {
    destroyEditor(container)
  })
  var change = new Delta()
  quill.on("text-change", function(delta) {
    change = change.compose(delta)
    UIError.clearErorrs()
  })
  return quill
}

const addButton = (name, callbackFn = null) => {
  let Btn = new Parchment.Attributor.Class(name, `ql-${name}`, {
    scope: Parchment.Scope.INLINE
  })

  Quill.register(Btn, true)
  var newBtn = document.querySelector(`.ql-${name}`)
  newBtn.addEventListener('click', function() {
   if (callbackFn && typeof callbackFn === 'function') {
      callbackFn()
    }
  })
  $(`button.ql-${name}`)
      .html(`<i class='fal fa-${name}' style='font-size: 18px'></i>`)
}

const destroyEditor = (selector) => {
  if($(selector)[0]){
    var content = $(selector)
      .find('.ql-editor').html()
      .replaceAll("<div><br></div>","")
    $(selector).html(content)
    $(selector).siblings('.ql-toolbar').remove();
    $(selector + " *[class*='ql-']").removeClass (function (index, css) {
        return (css.match (/(^|\s)ql-\S+/g) || []).join(' ')
    });

    $(selector + "[class*='ql-']").removeClass (function (index, css) {
      return (css.match (/(^|\s)ql-\S+/g) || []).join(' ')
    })
  } else {
    console.log(selector)
    console.error('editor does not exists');
  }
}

const initWithExtraDropdownItems = (container, dropdownItems, content) => {
  window.quill = new Quill(container, {
    theme: "snow",
    modules: {
      toolbar: commonToolbar(),
        imageDropAndPaste: {},
        imageResize: {
          displaySize: true
        },
        clipboard: {
          matchVisual: false
        },
        keyboard: {
          bindings: {
            linebreak: {
              key: 13,
              shiftKey: true,
              handler: function(range) {
                const currentLeaf = this.quill.getLeaf(range.index)[0]
                const nextLeaf = this.quill.getLeaf(range.index + 1)[0]
                this.quill.insertEmbed(range.index, "break", true, "user")
                if (nextLeaf === null || currentLeaf.parent !== nextLeaf.parent) {
                  this.quill.insertEmbed(range.index, "break", true, "user")
                }
                this.quill.setSelection(range.index + 1, Quill.sources.SILENT)
              }
            }
          }
        }
    },
  })
  attachDropdownItems("Available variables", dropdownItems)
  if (content) {
    quill.clipboard.dangerouslyPasteHTML(0, content)
  }
}

const attachDropdownItems = (name, dropdownItems) => {
  const dropdown = new QuillTools.QuillToolbarDropDown({
    label: name,
    rememberSelection: false,
  })
  dropdown.setItems(dropdownItems)
  dropdown.onSelect = function (label, value, quill) {
    const { index, length } = quill.selection.savedRange
    quill.deleteText(index, length)
    quill.insertText(index, value)
    quill.setSelection(index + value.length)
  }
  dropdown.attach(quill)
}

const isQuillEmpty = () => {
  if ((window.quill.getContents()["ops"] || []).length !== 1) { return false }
  return window.quill.getText().trim().length === 0
}

const addQuillError = (errorContainer) => {
  $("div.quill").addClass('is-invalid')
  $(errorContainer).html('cannot be empty')
}

export default {
  init, 
  glossaryOfTerms,
  initWithExtraDropdownItems, 
  isQuillEmpty,
  addQuillError, 
  destroyEditor
}