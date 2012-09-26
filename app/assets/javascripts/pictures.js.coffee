# Canvas test

actions = ["line", "curve", "bezier", "arc", "circle", "ellipse", "rectangle", "text"]
action = actions[0]

sqr = (x) ->
  return x*x

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

drawPoint = (context, X1, Y1) ->  
  context.moveTo(X1 - 5, Y1)
  context.lineTo(X1 + 5, Y1)
  context.moveTo(X1, Y1 - 5)
  context.lineTo(X1, Y1 + 5) 

drawLine = (context, points, draw_points = false) -> 
  [[X1, Y1], [X2, Y2]] = points

  context.beginPath()
  context.moveTo(X1, Y1)
  context.lineTo(X2, Y2)

  if draw_points 
    drawPoint(context, X1, Y1)
    drawPoint(context, X2, Y2) 

  context.stroke()
  context.closePath()

drawCircle = (context, points, draw_radius = false, draw_points = false) ->
  [[X1, Y1], [X2, Y2]] = points

  radius = Math.sqrt(sqr(X1-X2) + sqr(Y1-Y2))

  context.beginPath()  
  context.arc(X1, Y1, radius, 0, 2 * Math.PI, false)

  if draw_radius
    context.moveTo(X1, Y1)
    context.lineTo(X2, Y2)

  if draw_points
    drawPoint(context, X1, Y1)
    drawPoint(context, X2, Y2)    
  
  context.stroke()
  context.closePath()

drawBezierCurve = (context, points, draw_points = false) ->
  if points.length is 2 then drawLine(context, points, draw_points)
  if points.length is 3 then drawBezierCurve(context, points.concat([points[2]]), draw_points)

  [[X1, Y1], [X2, Y2], [X3, Y3], [X4, Y4]] = points

  context.beginPath() 
  context.moveTo(X1, Y1)
  context.bezierCurveTo(X3, Y3, X4, Y4, X2, Y2)
  
  if draw_points
    drawPoint(context, X1, Y1)
    drawPoint(context, X2, Y2)
    drawPoint(context, X3, Y3)
    drawPoint(context, X4, Y4)  

  context.stroke()
  context.closePath()

drawQuadraticCurve = (context, points, draw_points = false) ->
  if points.length is 2 then drawLine(context, points, draw_points)

  [[X1, Y1], [X2, Y2], [X3, Y3]] = points

  context.beginPath() 
  context.moveTo(X1, Y1)
  context.quadraticCurveTo(X3, Y3, X2, Y2)
  
  if draw_points
    drawPoint(context, X1, Y1)
    drawPoint(context, X2, Y2)
    drawPoint(context, X3, Y3) 

  context.stroke()
  context.closePath()   

drawArc = (context, points, draw_radius = false, draw_points = false) ->  
  if points.length is 2 then drawCircle(context, points, draw_radius, draw_points)

  [[X1, Y1], [X2, Y2], [X3, Y3]] = points

  radius = Math.sqrt(sqr(X1 - X2) + sqr(Y1 - Y2))
  start_angle = 0.5 * Math.PI - Math.atan2(X2 - X1, Y2 - Y1)
  end_angle = 0.5 * Math.PI - Math.atan2(X3 - X1, Y3 - Y1)

  context.beginPath()  
  context.arc(X1, Y1, radius, start_angle, end_angle, false)

  if draw_radius
    context.moveTo(X1, Y1)
    context.lineTo(X2, Y2)
    context.moveTo(X1, Y1)
    context.lineTo(X3, Y3)

  if draw_points
    drawPoint(context, X1, Y1)
    drawPoint(context, X2, Y2)  
    drawPoint(context, X3, Y3)     
  
  context.stroke()
  context.closePath()

drawEllipce = (context, points, draw_radius = false, draw_points = false) -> 
  if points.length is 2 then drawCircle(context, points, draw_radius, draw_points)

  [[X1, Y1], [X2, Y2], [X3, Y3]] = points

  width = Math.sqrt(sqr(X1 - X2) + sqr(Y1 - Y2)) * 1.33
  height = Math.sqrt(sqr(X1 - X3) + sqr(Y1 - Y3))

  context.beginPath() 
  context.moveTo(X1, Y1 - height)
  context.bezierCurveTo(X1 + width, Y1 - height, X1 + width, Y1 + height, X1, Y1 + height)
  context.bezierCurveTo(X1 - width, Y1 + height, X1 - width, Y1 - height, X1, Y1 - height)

  if draw_radius
    context.moveTo(X1, Y1)
    context.lineTo(X1 + width / 1.33, Y1)

  if draw_points
    drawPoint(context, X1, Y1)
    drawPoint(context, X1 + width / 1.33, Y1) 
    drawPoint(context, X3, Y3)   

  context.stroke()
  context.closePath()

drawRect = (context, points, draw_diag = false, draw_points = false) ->
  [[X1, Y1], [X3, Y3]] = points 
  [[X2, Y2], [X4, Y4]] = [[X3, Y1], [X1, Y3]]

  context.beginPath()  

  context.moveTo(X1, Y1)
  context.lineTo(X2, Y2) 
  context.lineTo(X3, Y3)
  context.lineTo(X4, Y4)
  context.lineTo(X1, Y1)

  if draw_points
    drawPoint(context, X1, Y1)
    drawPoint(context, X2, Y2)  
    drawPoint(context, X3, Y3)  
    drawPoint(context, X4, Y4)

  if draw_diag
    context.moveTo(X1, Y1)
    context.lineTo(X3, Y3)
    context.moveTo(X2, Y2)
    context.lineTo(X4, Y4) 
    
  context.stroke()    
  context.closePath()

# ---------------------------------------------------------------------    

drawText = (context, points) ->
  X1 = points[0][0]
  Y1 = points[0][1]

  if points.length is 2
    height = $("canvas").height()
    width = $("canvas").width()
    field_height = $("#board_text_tool").height()

    $("#board_text_tool").css
      "visibility" : "visible" 
      "margin-top" : -height+Y1-field_height
      "width" : width - X1
      "margin-left" : X1

    $("#board_text_tool").focus() 
  else
    text = $("#board_text_tool").val()
    context.fillText(text, X1, Y1)

# ---------------------------------------------------------------------  

clearBoard = (context) -> 
  width = $("canvas").width()
  height = $("canvas").height() 
  context.clearRect(0, 0, width, height)
  
  $("#board_text_tool").val("")
  $("#board_text_tool").css "visibility" : "hidden"
  

# Drawing on the boards -----------------------------------------------

drawInAction = (context, points, mouse_pointer) ->
  points = points.concat([mouse_pointer])

  switch action
    when "line" then drawLine(context, points, true)
    when "circle" then drawCircle(context, points, true, true)
    when "curve" then drawQuadraticCurve(context, points, true)
    when "arc" then drawArc(context, points, true, true)
    when "bezier" then drawBezierCurve(context, points, true)
    when "ellipse" then drawEllipce(context, points, true, true)
    when "rectangle" then drawRect(context, points, true, true)

  return false  

drawFigure = (context, points) -> 
  switch points.length        
    when 2
      switch action 
        when "line" then drawLine(context, points)
        when "circle" then drawCircle(context, points)
        when "rectangle" then drawRect(context, points)
        when "text" 
          drawText(context, points)
          return false
        else return false
    when 3
      switch action 
        when "ellipse" then drawEllipce(context, points)
        when "curve" then drawQuadraticCurve(context, points)
        when "arc" then drawArc(context, points)
        when "text" then drawText(context, points)
        else return false
    when 4
      switch action 
        when "bezier" then drawBezierCurve(context, points)
        else return false  

  return true        

# Initialize canvas ---------------------------------------------------    

canvasInit = -> 
  board = createBoard()
  fake = createFakeBoard()

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

    if drawFigure(board, points)
      points = []
      clearBoard(fake)  
    
    return false

  $("canvas#fake_board").mousemove (p) ->
    if previous_action isnt action 
      points = []
      clearBoard(fake)  

    if mouse_down
      clearBoard(fake)
      drawInAction(fake, points, [p.offsetX, p.offsetY])

    return false  

  return false

# Load

$ ->
  canvasInit()
