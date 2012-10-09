
importPicture = ->
  $("#import_picture").mousedown ->
    t_ok = "Импорт"
    t_cancel = "Отмена"    
    $("html").append("<div id='import_dialog_background' />
                      <div id = 'import_dialog' >
                        <textarea id = 'import_dialog_text' />
                        <a href='#' class ='button_ok' data-method = 'delete'>"+t_ok+"</a>
                        <a href='#' class = 'button_cancel'>"+t_cancel+"</a>
                      </div>")
    
    hideImportDialog = ->
      $("#import_dialog_background").remove()
      $("#import_dialog").remove()
      return false

    updateBoard = ->
      context = $("#board")[0].getContext('2d')
      width = $("canvas").width()
      height = $("canvas").height() 
      context.clearRect(0, 0, width, height)
      text = $("#picture_code").val()
      parseCode(context, text)  

    $("#import_dialog").find(".button_cancel").click ->
      hideImportDialog()

    $("#import_dialog_background").click ->
      hideImportDialog()

    $("#import_dialog").find(".button_ok").click ->
      text = $("#import_dialog_text").val()
      parseExternalCode(text)
      updateBoard()
      hideImportDialog() 

    return false

$ ->
  importPicture() 