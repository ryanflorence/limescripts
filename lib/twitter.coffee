bind 'link', (href, line) ->
  matches = href.match /http[s]?:\/\/twitter.com\/(.+)\/status\/(.+)/
  return unless matches
  url = "http://api.twitter.com/1/statuses/show/#{matches[2]}.json?callback=?"
  $.getJSON url, (data) ->
    tweet = $ '<span/>'
    tweet.html """
      tweet by: <i class=twitter-user-name>#{data.user.name}</i>
      <span class=twitter-text>#{data.text}</span>
    """
    $(line).find('.message').append tweet

