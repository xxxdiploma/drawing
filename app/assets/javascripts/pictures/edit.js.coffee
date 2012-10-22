# --------------------------------------------------------------------- 

actions = ["line", "curve", "bezier", "arc", "circle", "ellipse", "rectangle"]
action = "no action"

demensions = ["xy", "xz", "yz", "xyz"]
demension = "xy"

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


  button = document.createElement "input"
  button.type = "button"
  button.id = "board_demension_button" 
  button.value = demension
  menu.appendChild button

  $("#board_demension_button").mousedown ->    
    i = demensions.indexOf(demension)
    if i is demensions.length-1 then i = -1
    demension = demensions[i+1]
    $(this).val demension

    canvas = $("#board")[0]
    context = canvas.getContext('2d') 
    updateBoard(context)

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

  new_points = []
  for i in points
    switch demension
      when "xy" then new_points.push([i[0], i[1], 0])
      when "xz" then new_points.push([i[0], 0, i[1]])
      when "yz" then new_points.push([0, i[0], i[1]])      

  text.val(old_text + action + " " + new_points.join(" ") + "\n")

# ---------------------------------------------------------------------   

root = exports ? this 
root.clearBoard = (context) -> 
  width = $("canvas").width()
  height = $("canvas").height() 
  context.clearRect(0, 0, width, height)

root.updateBoard = (context) ->
  clearBoard(context)
  text = $("#picture_code").val()
  drawGrid(context, 20)
  parseCode(context, demension, text)

# Drawing on the boards -----------------------------------------------

draftDrawing = (context, points) ->
  drawing2D(action, context, "xy", points, true)

  return false  

finishDrawing = (context, points) -> 
  if drawing2D(action, context, "xy", points)
    printFigureCode(points)
    return true
  
  return false 

# Other ---------------------------------------------------------------

drawGrid = (context, scale) ->
  if demension is "xyz" then return false

  width = context.canvas.width
  height = context.canvas.height

  oldstyle = context.strokeStyle
  context.strokeStyle = "#f3f3f3"
  
  for i in [1..width/scale]
    drawing2D("line", context, "xy", [[i*scale, 0],[i*scale, height]])
  
  for i in [1..height/scale]
    drawing2D("line", context, "xy", [[0, i*scale],[width, i*scale]])      

  context.strokeStyle = oldstyle 

  return true        

# Initialize canvas ---------------------------------------------------    

canvasInit = -> 
  board = createBoard()
  fake = createFakeBoard()
  updateBoard(board)

  points = []
  mouse_down = false
  previous_action = "no action"

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
