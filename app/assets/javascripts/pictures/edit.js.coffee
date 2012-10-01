# --------------------------------------------------------------------- 

actions = ["line", "curve", "bezier", "arc", "circle", "ellipse", "rectangle", "text"]
action = actions[0]

# Create board --------------------------------------------------------

createFakeBoard = -> 
  canvas = document.createElement "canvas"
  canvas.id = "fake_board"
  canvas.width = $("canvas").width()
  canvas.height = $("canvas").height()

  $("#board")[0].parentNode.appendChild canvas
  $("#fake_board").css "position" : "absolute"

  context = canvas.getContext('2d')
  context.strokeStyle = "#b2d179"

  return context

createMenu = ->
  menu = document.createElement "div"
  menu.id = "board_menu"

  $("#board")[0].parentNode.appendChild menu

  $("#board_menu").css 
    "float" : "right"
    "width" : 40 
    "height" : "100%" 
    "margin-right" : -44
    "margin-top" : -2

  for name in actions
    button = document.createElement "input"
    button.type = "button"
    button.setAttribute "class", "board_tools_button " + name
    button.setAttribute "tool", name
    menu.appendChild button

    $(".board_tools_button." + name).css 
      "background-image" : "url('/assets/buttons/" + name + ".png')"  

  $(".board_tools_button").mousedown -> 
    action = $(this).attr "tool"

    return false

  return menu  

createTextField = ->
  input = document.createElement "input"  
  input.id = "board_text_tool"
  $("#board")[0].parentNode.parentNode.appendChild input
  $("#board_text_tool").css 
    "position" : "absolute"
    "visibility" : "hidden"
    "background" : "transparent"
    "border" : 0

createBoard = -> 
  canvas = $("#board")[0]
  canvas.width = $("canvas").width()
  canvas.height = $("canvas").height()
  context = canvas.getContext('2d') 
  context.font = "13px arial"
  $("#board").css "position" : "absolute" 

  createMenu()
  createTextField()  

  return context    

# Drawing functions ---------------------------------------------------  

# ---------------------------------------------------------------------    

# ---------------------------------------------------------------------  

showTextField = (points) ->
  [X1, Y1] = points[0]

  height = $("canvas").height()
  width = $("canvas").width()
  field_height = $("#board_text_tool").height()

  $("#board_text_tool").css
    "visibility" : "visible" 
    "margin-top" : -height+Y1-field_height
    "width" : width - X1
    "margin-left" : X1

  $("#board_text_tool").focus()

# --------------------------------------------------------------------- 

printFigureCode = (points) ->
  text = $("#picture_code")
  old_text = text.val().replace /^\s+/g, ""

  text.val(old_text + action + "," + points + "\n")

# --------------------------------------------------------------------- 

printTextCode = (points, user_text) -> 
  text = $("#picture_code")
  old_text = text.val().replace /^\s+/g, ""
  user_text = user_text.replace /^\s+/g, ""

  text.val(old_text + action + "," + points + "," + user_text + "\n")

# ---------------------------------------------------------------------   
 
clearBoard = (context) -> 
  width = $("canvas").width()
  height = $("canvas").height() 
  context.clearRect(0, 0, width, height)
  
  $("#board_text_tool").val("")
  $("#board_text_tool").css "visibility" : "hidden" 

# Drawing on the boards -----------------------------------------------

draftDrawing = (context, points) ->
  drawing(action, context, points, true)

  return false  

finishDrawing = (context, points) -> 
  if drawing(action, context, points)
    printFigureCode(points)
    return true
  
  return false

textDrawing = (context, points) ->  
  if action is "text"
    if points.length is 3
      text = $("#board_text_tool").val()
      drawing(action, context, points.slice(1,2), text)
      printTextCode(points.slice(1,2), text)
      return true
    else 
      showTextField(points)

  return false  
  

# Initialize canvas ---------------------------------------------------    

canvasInit = -> 
  board = createBoard()
  fake = createFakeBoard()

  points = []
  mouse_down = false
  previous_action = "no action"

  parseAndDraw(board, $("#picture_code").val())

  $("canvas#fake_board").mousedown (p) ->
    mouse_down = true

    if not points.length 
      points.push([p.offsetX, p.offsetY])
      previous_action = action

    return false

  $("canvas#fake_board").mouseup (p) -> 
    mouse_down = false

    points.push([p.offsetX, p.offsetY])

    if finishDrawing(board, points) or textDrawing(board, points)
      points = []
      clearBoard(fake)  
    
    return false

  $("canvas#fake_board").mousemove (p) ->
    if previous_action isnt action 
      points = []
      clearBoard(fake)  

    if mouse_down
      clearBoard(fake)
      draftDrawing(fake, points.concat([[p.offsetX, p.offsetY]]))

    return false  

  return false

# Load ----------------------------------------------------------------

$ ->
  canvasInit()
