import Quill from "quill/dist/quill"
import QuillTools from './dynamic-quill-tools'
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

const init = (container) => {
  let Delta = Quill.import("delta")
  window.quill = new Quill(container, {
    modules: {
      toolbar: commonToolbar(),
    },
    placeholder: "Write your important message here...",
    theme: "snow",
  });

  var change = new Delta()
  quill.on("text-change", function(delta) {
    change = change.compose(delta)
    UIError.clearErorrs()
  })
}

const initWithExtraDropdownItems = (container, dropdownItems, content) => {
  window.quill = new Quill(container, {
    theme: "snow",
    modules: {
      toolbar: {
        container: commonToolbar(),
      },
    },
  })
  attachDropdownItems("Available variables", dropdownItems)
  if (content) {
    debugger
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
  if (dropdownItems.length > 0) {
    dropdown.attach(quill)
  }
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
  initWithExtraDropdownItems, 
  isQuillEmpty,
  addQuillError
}
