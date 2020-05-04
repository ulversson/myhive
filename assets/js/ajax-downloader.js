import download from './download-ajax'

  const downloadAjax = function (url, postData, fileName, contentType) {
  var req = new XMLHttpRequest()
  req.open("POST", url, true)
  req.responseType = "blob"
  req.setRequestHeader("Content-type", "application/json")
  req.send(JSON.stringify(postData))
  req.onload = function (event) {
    var blob = req.response;
    download(blob, fileName, contentType)
  }
}

const downloadWithCallback = (url, postData, fileOptions, callbackFn) => {
  var req = new XMLHttpRequest()
  req.open("POST", url, true)
  req.responseType = "blob"
  req.setRequestHeader("Content-type", "application/json")
  req.setRequestHeader('Authorization', `Bearer ${window.localStorage.getItem('jwt')}`)
  req.send(JSON.stringify(postData))
  req.onload = function (event) {
    var blob = req.response
    download(blob, fileOptions.fileName, fileOptions.contentType)
    callbackFn()
  }
}

export default {
  downloadAjax, downloadWithCallback
}