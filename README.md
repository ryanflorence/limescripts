LimeScripts
===========

Did you know you can add JavaScript to your LimeChat theme?! LimeScripts
makes adding behavior to LimeChat awesome. It includes jQuery if you're
a DOM wussy, and supports CoffeeScript if you're a hipster. Also includes
some really terrible `console.log` support so you at least have half a
clue about what's going on.

Installation
------------

1. Clone this repository into your LimeChat Themes directory. You can
   find it by opening LimeChat, Prefences > Theme > Open in Finder

2. Rename `main.coffee.example` to `main.coffee`. Don't worry, **You
   don't have to use CoffeeScript to write your own stuff**. Edit as
   you wish, its pretty straightforward.

3. Run `./install.sh <theme>` where `<theme>` is the exact name of your
   theme like "Limelight" or "Campfire". LimeChat automatically loads a
   JavaScript file with a name matching your theme. This install script
   simply creates a link to `limescripts.js` for the theme you specify.

Add your own scripts
--------------------

1. Create a `.js` or `.coffee` file in `lib/`

2. Load it in `main.coffee` like this:

   ```coffee
   # load a coffeescript file
   load 'myscript.coffee'

   # load a javascript file
   load 'something-awesome.js'

   # set the default file type so you can omit the extension
   load.language = 'js'
   load 'something-awesome' # no .js!

   # or for the hipsters
   load.language = 'coffee'
   load 'myscript'
   ```

API
---

LimeScripts is essentially an event system. When a message is added, a
bunch of events are triggered. Do see the examples in `lib/`, there's
also some decent documentation in `limescripts.js` about all the event
types you can bind to.

### Example

Here's the twitter script:

```coffeescript
# You bind to events like 'link'. 'link' will be triggered for every
# anchor tag found in the new message. Read `limescripts.js` to get an
# idea for all the events available.

bind 'link', (href, line) ->
  # href is the link's href
  # line is the top level message element

  # `this` is the anchor element, though its not used in this script
  # most events are bound to an element that makes the most sense

  matches = href.match /http[s]?:\/\/twitter.com\/(.+)\/status\/(.+)/
  return unless matches
  url = "http://api.twitter.com/1/statuses/show/#{matches[2]}.json?callback=?"

  # jQuery is available
  $.getJSON url, (data) ->
    tweet = $ '<span/>'
    tweet.html """
      tweet by: <i class=twitter-user-name>#{data.user.name}</i>
      <span class=twitter-text>#{data.text}</span>
    """

    # the message element is usually where you want to add stuff
    $(line).find('.message').append tweet

```

License & Copyright
-------------------

For all scripts in this repository:

- [MIT-Style
  license](http://www.opensource.org/licenses/mit-license.php)
- Copyright [Ryan Florence](http://ryanflorence.com)



