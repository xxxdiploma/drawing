# --------------------------------------------------------------------- 

actions = ["line", "curve", "bezier", "arc", "circle", "ellipse", "rectangle"]
action = "no action"

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
    if $("#board").attr("type") isnt "show" then action = $(this).attr "tool"

    return false

  return menu  

createBoard = -> 
  canvas = $("#board")[0]
  canvas.width = $("canvas").width()
  canvas.height = $("canvas").height()
  context = canvas.getContext('2d') 
  $("#board").css "position" : "absolute" 

  createMenu() 

  return context    

# --------------------------------------------------------------------- 

printFigureCode = (points) ->
  text = $("#picture_code")
  old_text = text.val().replace /^\s+/g, ""

  text.val(old_text + action + " " + points.join(" ") + "\n")

# ---------------------------------------------------------------------   
 
clearBoard = (context) -> 
  width = $("canvas").width()
  height = $("canvas").height() 
  context.clearRect(0, 0, width, height)

# Drawing on the boards -----------------------------------------------

draftDrawing = (context, points) ->
  drawing(action, context, points, true)

  return false  

finishDrawing = (context, points) -> 
  if drawing(action, context, points)
    printFigureCode(points)
    return true
  
  return false 

# Initialize canvas ---------------------------------------------------    

canvasInit = -> 
  board = createBoard()
  fake = createFakeBoard()

  points = []
  mouse_down = false
  previous_action = "no action"

  parseCode(board, $("#picture_code").val())

  $("canvas#fake_board").mousedown (p) ->
    mouse_down = true

    if not points.length 
      points.push([p.offsetX, p.offsetY])
      previous_action = action

    return false

  $("canvas#fake_board").mouseup (p) -> 
    mouse_down = false

    points.push([p.offsetX, p.offsetY])

    if finishDrawing(board, points)
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
