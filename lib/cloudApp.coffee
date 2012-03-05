##
# Inlines cloudApp images

cache = {}

bind 'link', (href, line) ->
  return unless href.match /^http:\/\/cl.ly/

  message = $(line).find '.message'

  link = $ '<a/>',
    href: href
    imageindex: 0

  if cache[href]?
    link.append cache[href].clone()
    link.appendTo message

  else
    injectIframe href, (iframe) ->
      src = iframe.contentDocument.getElementsByTagName('img')[0].src
      image = $ '<img/>',
        src: src
        class: 'inlineimage'

      image.appendTo link
      link.appendTo message
      iframe.parentNode.removeChild iframe
      cache[href] = image

