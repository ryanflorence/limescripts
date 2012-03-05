##
# Inserts an invisible iframe on the page and returns it
#
# @param {String} href - the url of the web page to load
# @param {Function} callback
@injectIframe = (href, callback) ->
  iframe = document.createElement 'iframe'
  iframe.src = href
  iframe.setAttribute 'width', 0
  iframe.setAttribute 'height', 0
  iframe.setAttribute 'class', "border: none"
  if callback
    iframe.onload = ->
      callback.call iframe, iframe
  document.body.appendChild iframe
  iframe

##
# Creates an empty iframe and returns it
@emptyIframe = ->
  iframe = document.createElement 'iframe'
  doc = """
    <!doctype html>
    <html>
      <head></head>
      <body>
  """
  iframe.src = "javascript:document.write('#{doc}')"
  document.body.appendChild iframe
  iframe

