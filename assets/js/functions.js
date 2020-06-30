const decodeHtml = (html)  => {
  var txt = document.createElement("textarea")
  txt.innerHTML = html
  return txt.value
}

async function getBase64ImageFromUrl(imageUrl) {
  var res = await fetch(imageUrl)
  var blob = await res.blob()

  return new Promise((resolve, reject) => {
    var reader  = new FileReader();
    reader.addEventListener("load", function () {
        resolve(reader.result)
    }, false);

    reader.onerror = () => {
      return reject(this)
    };
    reader.readAsDataURL(blob)
  })
}

export default {
  decodeHtml,
  getBase64ImageFromUrl
}