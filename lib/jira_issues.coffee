use_jquery_dollarsign = ($) ->

  bind 'privmsg', ( line ) ->
    # These must be configured in env.coffee for privacy
    USERNAME = document.env.jira.username
    PASSWORD = document.env.jira.password
    SERVER   = document.env.jira.server
    ISSUE_ID_MATCHER = document.env.jira.issue_id_matcher

    issue_metadata = {}

    basic_password = ( username, password ) ->
      "Basic #{btoa( username + ":" + password )}"

    jira_link = (issue_id) ->
      "<a href='#{SERVER}/browse/#{issue_id}'>#{issue_id}</a>"

    jira_summary = (summary) ->
      "<div class='jira-summary'>#{summary}</div>"

    jira_issue_url = (issue_id) ->
      "#{SERVER}/rest/api/2/issue/#{issue_id}?fields=summary"

    parse_jira_issue_ids = (html) ->
      ids = []
      html.replace ISSUE_ID_MATCHER, (_, issue_id) ->
        ids.push(issue_id)
      ids

    request_issue = (issue_id, options) ->
      opts =
        dataType: 'json'
        headers:
          'Authorization': basic_password( USERNAME, PASSWORD )
      opts[k] = v for k, v of options
      $.ajax jira_issue_url(issue_id), opts

    # Compare two objects and return true iff set_a is a subset of set_b
    keys_subset = (set_a, set_b) ->
      for k, v of set_a
        return false if not k in set_b
      return true

    # Compare two objects and return true iff their keys are equal
    keys_equal = (set_a, set_b) ->
      return keys_subset(set_a, set_b) and keys_subset(set_b, set_a)

    fetch_and_store_issue = (issue_id, store, always_fn) ->
      request_issue issue_id,
        success: ( data ) ->
          store[ issue_id ] = 
            summary: data?.fields?.summary
        error: ->
          store[ issue_id ] = 
            summary: false
        complete: ->
          always_fn(issue_id)

    # Put it all together
    stitch = (text, issue_metadata) ->
      text.replace ISSUE_ID_MATCHER, (_, issue_id) ->
        md = issue_metadata[issue_id]
        link = jira_link(issue_id)
        if md.summary
          link + " (#{md.summary})"
        else
          link

    # Main function
    $span = $('.message', line)
    message = $span.html()

    issue_ids = {}
    for issue_id in parse_jira_issue_ids(message)
      issue_ids[ issue_id ] = true

    for issue_id, _ of issue_ids
      fetch_and_store_issue issue_id, issue_metadata, ( issue_id ) ->
        if keys_equal(issue_metadata, issue_ids)
          $span.html stitch(message, issue_metadata)

use_jquery_dollarsign jQuery
