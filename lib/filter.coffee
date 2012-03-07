##
# Adds a filter to the chat log, you'll need to add some styling
# to your theme for `.filter`, I recommend this:
#
# .filter {
#   position: fixed;
#   top: 0;
#   right: 0;
#   padding: 4px;
#   background: #eee;
#   z-index: 9999;
#   border: solid 1px #ccc;
#   -webkit-border-bottom-left-radius: 4px;
#   border-top: 0;
# }
#
# .filter input {
#   width: 200px;
# }
#
# This is a quick proof of concept for adding features with JS
# needs more polish, but is pretty useful as is, might be
# terrible when the log is huge.

input = document.createElement 'input'
wrapper = document.createElement 'wrapper'
wrapper.className = 'filter'
wrapper.appendChild input

handler = (event) ->
  clearTimeout timer
  timer = setTimeout filter, 300

filter = ->
  term = input.value
  try
    regex = new RegExp term, 'gi'
  catch e
    return
  $(document.body).children().each ->
    $child = $ this
    return unless $child.hasClass 'line'
    if term.length < 2
      $child.removeClass 'hidden'
      return
    # really crappy filter
    text = $child.html()
    if regex.test text
      $child.removeClass 'hidden'
    else
      $child.addClass 'hidden'

input.addEventListener 'keyup', handler, false
document.body.appendChild wrapper

