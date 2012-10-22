
importPicture = ->
  $("#import_picture").mousedown ->
    t_ok = "Импорт"
    t_cancel = "Отмена"    
    $("html").append("
      <div id='import_dialog_background' />
      <div id = 'import_dialog' >
        <textarea id = 'import_dialog_line_numbers' readonly = 'true' />
        <textarea id = 'import_dialog_text' />
        <a href='#' class ='button_ok' data-method = 'delete'>"+t_ok+"</a>
        <a href='#' class = 'button_cancel'>"+t_cancel+"</a>
      </div>")
    
    updateLines = -> 
      num = ""
      for i in [0..9]
        num += "0" + i + "\n"
      for i in [10..99]
        num += i + "\n"

      text = $("#import_dialog_line_numbers").val()
      $("#import_dialog_line_numbers").val(text + num)

    updateLines()

    $("#import_dialog_text").scroll ->
      $("#import_dialog_line_numbers")[0].scrollTop = $(this)[0].scrollTop
      
      if $("#import_dialog_line_numbers")[0].scrollTop != $(this)[0].scrollTop
        updateLines()


    hideImportDialog = ->
      $("#import_dialog_background").remove()
      $("#import_dialog").remove()
      return false  

    $("#import_dialog").find(".button_cancel").click ->
      hideImportDialog() 

    $("#import_dialog_background").click ->
      hideImportDialog()

    $("#import_dialog").find(".button_ok").click ->
      text = $("#import_dialog_text").val()
      parseExternalCode(text)
      context = $("#board")[0].getContext('2d')
      updateBoard(context)
      hideImportDialog() 

    return false

$ ->
  importPicture() 