# Custom notification

customNotifications = ->
  $(".button_delete").click ->
    delete_link = $(this).find("a").attr("object_url")
    t_message = "Вы подтверждаете удаление?"
    t_ok = "Да"
    t_cancel = "Нет"
    $("html").append("<div id='message_background' />
                      <div id = 'message' >
                        <p>"+t_message+"</p>
                        <a href="+delete_link+" class ='button_ok' data-method = 'delete'>"+t_ok+"</a>
                        <a href='#' class = 'button_cancel'>"+t_cancel+"</a>
                      </div>")

    hideNotification = ->
      $("#message_background").remove()
      $("#message").remove()
      return false

    $("#message").find(".button_cancel").click ->
      hideNotification()

    $("#message_background").click ->
      hideNotification()

    return false

# Load

$ ->
  customNotifications()
