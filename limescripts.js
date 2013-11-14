/*!
 * limescripts.js (c) Ryan Florence
 * https://github.com/rpflorence/limescripts
 * MIT License <http://www.opensource.org/licenses/mit-license.php>
 */

(function () {

  /*
   * Main API into limescript, pretty much all you need. The whole system is
   * built around binding to global events that trigger when a message is
   * added. There are static events, and dynamic events (like fired for
   * elements with certain classNames, etc). To get a feel for the types of
   * events available, uncomment the first line of `function trigger` later
   * in this file while you use lime chat.
   *
   * @param {String}   event   - the name of the event you want to bind to
   * @param {Function} handler - the function to call
   *
   * Static events
   * -------------
   *
   * @event 'line'
   *   @signature - function(line)
   *   @context - line
   *
   * @event 'link' - when a message contains a link
   *   @signature - function(href, line)
   *   @context - the link anchor element
   *
   * @event 'line:highlight' - when a message is highlighted
   *   @signature - function(line)
   *   @context - line
   *
   * Dynamic Events
   * --------------
   *
   * @event "#{type}" - when a line of `type` is added
   *   @signature - function(line)
   *   @context - line
   *
   * @event "message:#{type}" - when a message of `type` is added
   *   @signature - function(line)
   *   @context - message element
   *
   * @event "#{className}" - when an element with `className` is added
   *   @signature - function(line)
   *   @context - the element matching `className`
   *
   */
  this.bind = function (event, handler) {
    if (events[event] == null) events[event] = [];
    events[event].push(handler);
  };


  /*
   * Load a JavaScript or CoffeeScript file. If you specify `load.language`
   * to either `js` or `coffee` then you can omit the extension.
   *
   * @param {String} src - file name relative to `lib` directory
   * @param {Function} callback - callback on load of script
   */
  this.load = function (src, callback) {
    if (load.language) src += '.' + load.language;
    var loader = src.match(/\.js$/) ? loadJS : loadCS;
    loader('limescripts/lib/' + src, callback);
  };

  /*
   * Load a JavaScript file
   *
   * @param {String} src
   * @param {Function} callback
   */
  this.loadJS = function (src, callback) {
    var script = document.createElement('script');
    if (src.indexOf('?') === -1) src += '?';
    // web view caches like crazy
    script.src = src + '&bust=' + Date.now();
    script.type = 'text/javascript';
    if (callback) script.onload = callback;
    document.body.appendChild(script);
  };

  /*
   * Load a CoffeeScript file
   *
   * @param {String} src
   * @param {Function} calback
   */
  this.loadCS = function (src, callback) {
    CoffeeScript.load(src, callback);
  };

  /*
   * Really terrible debugging, thinking about getting firebug lite
   * but haven't looked at it yet
   */
  this.console = {};

  /*
   * Logs arguments as strings to the screen
   */
  this.console.log = function () {
    var args = [].slice.call(arguments, 0);
    args.unshift('js-console-log');
    log.apply(null, args);
  };

  /*
   * same as console.log but adds `js-console-error` class for styling
   */
  this.console.error = function () {
    var args = [].slice.call(arguments, 0);
    args.unshift('js-console-error');
    log.apply(null, args);
  };

  // Override window.onerror so we actually get some error reporting
  this.onerror = function (error) {
    console.error('ERROR:', error);
  };

  // its all pretty much non-api private stuff from here

  function log (className) {
    var msgs = [].slice.call(arguments, 1);
    var node = document.createElement('div');
    node.className = className;
    node.innerHTML = '<span class="message">' + msgs.join('  ') + '</span>';
    document.body.appendChild(node);
  }

  // triggers all the events
  function triggerEvents (line) {
    var type = line.getAttribute('_type');

    // line event
    trigger('line', line, [line]);

    // line type event
    trigger(type, line, [line]);

    // highlight event
    if (line.getAttribute('highlight') === 'true') {
      trigger('line:highlight', line, [line]);
    }

    // fire events for all elements in the line
    var els = line.querySelectorAll('*');
    for (var i = 0, l = els.length; i < l; i++) {
      triggerElementEvents(els[i], line);
    }
  }

  function triggerElementEvents (el, line) {

    // link event
    if (el.tagName === 'A') {
      trigger('link', el, [el.getAttribute('href'), line]);
    }

    // message:#{type} event
    if (el.className === 'message') {
      trigger('message:' + el.className, el, [line]);
    }

    // className event
    trigger(el.className, el, [line]);
  }

  // event storage object used in `this.bind`
  var events = {};

  // triggers an event
  function trigger (name, context, args) {
    // console.log(name) // <-- do this to discover events
    var handlers = events[name];
    if (!handlers) return;
    for (var i = 0, l = handlers.length; i < l; i++) {
      handlers[i].apply(context, args);
    }
  }

  // the handler called whenever a dom node is inserted, ensures that we don't
  // trigger events unless it's the top level element of a new message
  function processMessage (event) {
    var node = event.target;
    var parent = node.parentNode;
    var isLine = node.className.match(/line/);
    if (parent !== document.body || !isLine) return;
    triggerEvents(node);
  }

  // attach the main handler
  document.addEventListener('DOMNodeInserted', processMessage, false);

  // load in coffeesscript (for the hipsters) and jQuery (for the wussies)
  // and the helpers file
  (function() {
    var scriptsLoaded = 0;
    loadJS('limescripts/vendor/coffee-script.js', finish);
    loadJS('limescripts/vendor/jquery-1.7.1.min.js', finish);

    function finish() {
      scriptsLoaded++;
      if (scriptsLoaded !== 2) return;
      load('helpers.coffee', function() {
        load('main.coffee');
      });
    }
  })();

}).call(this);

