$.fn.postalize = (callback)->

  onSuccess = (data) ->
    callback data

  defaultCallback = (data) ->
    data = data[0]
    $.each ['prefecture', 'city', 'town', 'address'], ()->
      elm = $(".#{id}-#{@}")
      text = if @.toString() is 'address' then "#{data['city']}#{data['town']}" else data[@]
      switch true
        when elm.is 'select'
          options = elm.find 'option'
          options.each ->
            if $.trim($(@).text()) is text or $(@).val() is text
              $(@).attr 'selected', true
        when elm.is 'input'
          elm.val text
        else
          elm.text text
      elm.focus()

  field = $(@)
  id = field.attr 'id'
  button = $(".#{id}-load")
  if button.length is 0
    button = $('<button>Load</button>').insertAfter(field.get(-1))
  callback ?= defaultCallback

  button.click ->
    zipcode = $.map(field, (f)-> $(f).val() ).join('').replace(/[^0-9]/g, '')
    $.getJSON "#{postal_base_url}api/#{zipcode}?callback=?", onSuccess
    false

  @

$ ->
  $('.postalize').each ->
    $(@).postalize()

