# Capitalize fix

capitalizeFix = ->
  object = $("#user_surname")
  object.keyup ->
    text = object.val()
    text = text[0].toUpperCase() + text.substr(1).toLowerCase()
    object.val(text)


# Load

$ ->
  capitalizeFix()
