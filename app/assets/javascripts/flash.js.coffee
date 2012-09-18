# Autohide flash message

autohideFlash = ->
  setTimeout (() ->
    $(".flash").animate {"top": -80}, 1000
    setTimeout (() ->
      $(".flash").remove()
      ), 1000
    ), 5000

  return false

# Load

$ ->
  autohideFlash()
