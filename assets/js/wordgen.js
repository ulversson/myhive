const officegen = require('officegen')
const fs = require('fs')
let docx = officegen('docx')
let outputFile = process.argv[2].toString()
let headerText = process.argv[3].toString()

let stringFields = JSON.parse(process.argv[4].toString())
let textFields = JSON.parse(process.argv[5].toString())

const addCVHeader = (docx, name) => {
  let header = docx.getHeader().createP()
  header.addText(name, {
    font_face: 'Times New-Roman', 
    font_size: 36 
  })
}

const addTableRow = (label, value) => {
  return [
    {
      val: `${label}:`,
      opts: {
        cellColWidth: 2500,
        b: true,
        sz: '24',
        shd: {
          fill: '000',
          themeFillTint: '20'
        }
      }
    },{
      val: `${value}`,
      opts: {
        cellColWidth: 6000,
        b: false,
        sz: '24',
        shd: {
          fill: '000',
          themeFill: 'Arial',
          themeFillTint: '20'
        }
      }
    }
  ]
}

const addTextParagraph = (docx, parHeader, parText) => {
  let pObj = docx.createP()

  pObj.addText(parHeader, {
    bold: true,
    font_face: 'Times New-Roman',
    font_size: 12
  }) 
  pObj = docx.createP()
  pObj.options.align = 'justify'

  pObj.addText(parText,{
    bold: false, 
    font_face: 'Times New-Roman',
    font_size: 12
  })
}

docx.on('finalize', function(written) {
  console.log(
    outputFile
  )
})

docx.on('error', function(err) {
  console.log(err)
})
addCVHeader(docx, headerText)

let tableData = []
stringFields.forEach((field) => {
  let row = addTableRow(field.name, field.value)
  tableData.push(row) 
})

let tableStyle = {
  tableColWidth: 3000,
  tableSize: 72,
  tableColor: '000',
  spacingBefor: 120, // default is 100
  spacingAfter: 120, // default is 100
  spacingLine: 80, // default is 240
  tableAlign: 'left',
  tableFontFamily: 'Times New-Roman',
  borders: false
}
docx.createTable(tableData, tableStyle)
docx.createP()
textFields.forEach((field) => {
  addTextParagraph(docx, field.name, field.value)
}) 
let out = fs.createWriteStream(outputFile)
out.on('error', function(err) {
  console.log(err)
}) 
docx.generate(out)