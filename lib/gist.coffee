bind 'link', (href, line) ->
  return unless href.match /http[s]?:\/\/gist.github.com\/.+/
  src = """
    <!doctype html>
      <html>
        <head>
          <style>body { font-size: 80% }</style>
          <script src="#{href}.js"></script>
        </head>
        <body>
  """
  iframe = document.createElement 'iframe'
  iframe.src = "javascript:document.write('#{src}')"
  iframe.setAttribute 'width', "98%"
  iframe.setAttribute 'height', window.innerHeight - 50
  iframe.className = 'gist'
  line.querySelector('.message').appendChild iframe

