# Canvas test

action = "line"
actions = ["line", "circle", "ellipse", "arc", "curve", "text"]

createFakeBoard = -> 
  canvas = document.createElement("canvas")
  canvas.id = "fake_board"
  canvas.width = $("canvas").width()
  canvas.height = $("canvas").height()

  $("#board")[0].parentNode.appendChild(canvas)
  $("#fake_board").css 
    "position" : "absolute"

  context = canvas.getContext('2d')
  context.strokeStyle = "#b2d179"

  return context

createBoard = -> 
  canvas = $("#board")[0]
  canvas.width = $("canvas").width()
  canvas.height = $("canvas").height()
  context = canvas.getContext('2d') 
  $("#board").css 
    "position" : "absolute" 

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
    "margin-top" : -1


  for name in actions
    button = document.createElement "input"
    button.type = "button"
    button.setAttribute "class", "board_tools_button "+name
    button.setAttribute "tool", name
    menu.appendChild button

    $(".board_tools_button."+name).css 
      "background-image" : "url('/assets/buttons/"+name+".gif')"

  $(".board_tools_button").css 
    "margin-bottom" : 2
    "width" : 38
    "height" : 24
    "background-repeat" : "no-repeat"
    "background-position" : "center"
    "cursor" : "pointer"
  

  $(".board_tools_button").click ->
    action = $(this).attr "tool"

    return false

drawLine = (context, X1, Y1, X2, Y2) -> 
  context.beginPath()  
  context.moveTo(X1, Y1)
  context.lineTo(X2, Y2)
  context.stroke()
  context.closePath()

  return false

drawArc = (context, X1, Y1, X2, Y2, draw_radius = false) ->
  radius = Math.sqrt((X1-X2)*(X1-X2) + (Y1-Y2)*(Y1-Y2))

  context.beginPath()  
  context.arc(X1, Y1, radius, 0, 2*Math.PI, true)

  if draw_radius
    context.moveTo(X1, Y1)
    context.lineTo(X2, Y2)
  
  context.stroke()
  context.closePath()

  return false  

clearBoard = (context) -> 
  width = $("canvas").width()
  height = $("canvas").height() 
  context.clearRect(0, 0, width, height)

  return false

canvasInit = -> 
  mouseX = 0
  mouseY = 0
  mouseDown = false

  board = createBoard()
  fake = createFakeBoard()
  createMenu()

  $("canvas#fake_board").mousedown (p) ->
    mouseX = p.offsetX
    mouseY = p.offsetY
    mouseDown = true

  $("canvas#fake_board").mouseup (p) ->
    clearBoard(fake)

    switch action
      when "line" then drawLine(board, mouseX, mouseY, p.offsetX, p.offsetY)
      when "circle"  then drawArc(board, mouseX, mouseY, p.offsetX, p.offsetY)
    
    mouseDown = false

  $("canvas#fake_board").mousemove (p) ->
    clearBoard(fake)

    if mouseDown
      switch action
        when "line" then drawLine(fake, mouseX, mouseY, p.offsetX, p.offsetY)
        when "circle"  then drawArc(fake, mouseX, mouseY, p.offsetX, p.offsetY, true)


# Load

$ ->
  canvasInit()
