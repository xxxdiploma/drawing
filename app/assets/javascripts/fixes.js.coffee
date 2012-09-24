# Capitalize fix

capitalizeFix = ->
  surname_field = $("#user_surname")
  surname_field.keyup ->
    text = surname_field.val()
    text = text[0].toUpperCase() + text.substr(1).toLowerCase()
    surname_field.val(text) 

# Load

$ ->
  capitalizeFix()
