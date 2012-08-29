#Show notification

$(document).ready ->
  $(".button_delete").click ->
    delete_link = $(this).find("a").attr("object_url")
    t_message = "Вы уверены?"
    t_ok = "Да"
    t_cancel = "Нет"
    $("html").append("<div id='message_background' />
                      <div id = 'message' >
                        <p>"+t_message+"</p>
                        <a href="+delete_link+" class ='button_ok' data-method = 'delete'>"+t_ok+"</a>
                        <a href='#' class = 'button_cancel'>"+t_cancel+"</a>
                      </div>")

    $("#message").find(".button_cancel").click =>
      $("#message_background").remove()
      $("#message").remove()

    $("#message_background").click ->
      $("#message").remove()
      $(this).remove()
