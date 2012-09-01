# Autohide flash message

autohideFlash = ->
  setTimeout (() ->
    $(".flash").animate {"opacity": 0}, 1000
    setTimeout (() ->
      $(".flash").remove()
      ), 1000
    ), 5000

  return false

# Load

$ ->
  autohideFlash()
