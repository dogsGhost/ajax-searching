'use strict'

app =
  init: ->
    @cacheVariables()
    @bindElements()

  cacheVariables: ->
    @inputField = document.getElementById 'author'
    @matches = document.getElementById 'matches'
    @results = document.getElementById 'results'
    @noResults = false
    @prevMatch = ''
    @resultsTemplate = document.getElementById('resultsTemplate').innerHTML
    return

  bindElements: ->
    @inputField.addEventListener 'keyup', @requestAuthors
    @inputField.addEventListener 'keydown', @downArrow

  requestAuthors: ->
    data = app.inputField.value
    regex = new RegExp app.prevMatch, 'ig'

    # If last request returned no results do regeExp test to see if input still contains a string with no matches.
    # This will prevent requests from being made when we know there will be no results.
    if not app.noResults or (app.noResults and not regex.test(data))
      # If input field is empty.
      unless data
        app.matches.style.display = 'none'
        return
      else
        # Add flag characters to data so backend knows what kind of search it is.
        data = "@@#{data}"
        app.sendRequest 'php/json.php', app.handleAuthorRequest, data

  handleAuthorRequest: (req) ->
    json = JSON.parse req.responseText
    i = json.length
    output = ''

    # If there are no results.
    unless i
      output = '<li class="item error">No matches found.</li>'
      app.noResults = true
      # Set prevMatch for testing next time the value on the input field changes.
      app.prevMatch = app.inputField.value 
    # If there are results.
    else
      # Make sure noResults is false.
      app.noResults = false
      output += "<li tabindex='0' class='item'>#{json[i]}</li>" while i--
      app.matches.addEventListener 'keydown', app.keyActions
      
    app.matches.innerHTML = output
    app.matches.style.display = 'block'
    return

  downArrow: (evt) ->
    evt = evt or window.event 
    if evt.keyCode is 40 and @value
      app.matches.getElementsByTagName('li')[0].focus()

  keyActions: (evt) ->
    # Assign actions to keys when navigating search results list.  
    evt = evt or window.event
    cur = evt.target or evt.srcElement

    if cur.nodeName.toLowerCase() is 'li'
      switch evt.keyCode
        # 40 - Down arrow action - move to next list item.
        when 40 then if cur.nextSibling then cur.nextSibling.focus()
        # 38 - Up arrow action - move to previous list item.
        when 38 then if cur.previousSibling then cur.previousSibling.focus()
        # 13 - Enter key action - send selected author for book matching; hide matches list.
        when 13
          cur.parentNode.style.display = 'none'
          app.requestBooks cur.innerHTML
        # default - Any other key - do nothing.
        else break

  requestBooks: (string) ->
    app.sendRequest 'php/json.php', app.handleBooksRequest, string

  handleBooksRequest: (req) ->
    json = JSON.parse req.responseText

    # Render the html from our template and output it on the page.
    app.results.innerHTML = app.assembleTemplate app.resultsTemplate, json
    
    # Clear and re-focus the input field.
    app.inputField.value = ''
    app.inputField.focus()

  assembleTemplate: (template, arr) ->
    # This function takes the template code from our document and an array of objects
    # and generates our html.
    output = ''

    replaceBrackets = (object) ->
      temp = ''
      # Use a for-in loop since the items in the array are objects.
      for key, value of object
        if object.hasOwnProperty(key)
          # Define a regex that will match our special brackets with the key we're looking for.
          pattern = new RegExp "@=#{key}=@", 'ig'
          # Use replace method to go through our string and make the swap.
          # Note the or statement, first time we use the template string, after that temp has a value
          # so we use that to match the rest of the keys and retain the swap made with previous keys.
          temp = (temp or template).replace pattern, value
      temp
  
    for obj in arr
      output += replaceBrackets obj
    output

  sendRequest: (url, callback, postData) ->
    # Create the XMLHttp object.
    xhr = new XMLHttpRequest()

    # Cancel operation if xhr is false.
    return false unless xhr

    # Check if there's postData.
    requestType = if postData then 'POST' else 'GET'

    # Make the request, set true for asynchronous.
    xhr.open requestType, url, true
    xhr.setRequestHeader 'X-Requesteed-With', 'XMLHttpRequest'

    # Set header as a form if posting data.
    if postData
      xhr.setRequestHeader 'Content-type', 'application/x-www-form-urlencoded'

    # Fire callback when the request is completed.
    xhr.onreadystatechange = ->
      if xhr.readyState isnt 4
        return
      if xhr.status isnt 200 and xhr.status isnt 304
        return
      callback xhr

    # If request is completed, stop function from sending it again.
    if xhr.readyState is 4
      return

    # If it's a post, send the data to server-side page.
    if postData
      xhr.send "data=#{postData}"
    else
      xhr.send null      

app.init()