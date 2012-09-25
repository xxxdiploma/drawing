# Canvas test

action = "line"
actions = ["line", "curve", "bezier", "arc", "circle", "ellipse", "text"]

createFakeBoard = -> 
  canvas = document.createElement("canvas")
  canvas.id = "fake_board"
  canvas.width = $("canvas").width()
  canvas.height = $("canvas").height()

  $("#board")[0].parentNode.appendChild(canvas)
  $("#fake_board").css "position" : "absolute"

  context = canvas.getContext('2d')
  context.strokeStyle = "#b2d179"

  return context

createBoard = -> 
  canvas = $("#board")[0]
  canvas.width = $("canvas").width()
  canvas.height = $("canvas").height()
  context = canvas.getContext('2d') 
  $("#board").css "position" : "absolute" 

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
    button.setAttribute "class", "board_tools_button "+name
    button.setAttribute "tool", name
    menu.appendChild button

    $(".board_tools_button."+name).css "background-image" : "url('/assets/buttons/"+name+".png')"  

  $(".board_tools_button").mousedown ->
    action = $(this).attr "tool"

    return false

drawPoint = (context, X1, Y1) ->  
  context.moveTo(X1-5, Y1)
  context.lineTo(X1+5, Y1)
  context.moveTo(X1, Y1-5)
  context.lineTo(X1, Y1+5) 

drawLine = (context, points, draw_points=false) -> 
  X1 = points[0][0]
  Y1 = points[0][1]

  X2 = points[1][0]
  Y2 = points[1][1] 

  context.beginPath()
  context.moveTo(X1, Y1)
  context.lineTo(X2, Y2)

  if draw_points 
    drawPoint(context, X1, Y1)
    drawPoint(context, X2, Y2) 

  context.stroke()
  context.closePath()

drawCircle = (context, points, draw_radius=false, draw_points=false) ->
  X1 = points[0][0]
  Y1 = points[0][1]

  X2 = points[1][0]
  Y2 = points[1][1] 

  radius = Math.sqrt((X1-X2)*(X1-X2) + (Y1-Y2)*(Y1-Y2))

  context.beginPath()  
  context.arc(X1, Y1, radius, 0, 2*Math.PI, false)

  if draw_radius
    context.moveTo(X1, Y1)
    context.lineTo(X2, Y2)

  if draw_points
    drawPoint(context, X1, Y1)
    drawPoint(context, X2, Y2)    
  
  context.stroke()
  context.closePath()

drawBezierCurve = (context, points, draw_points=false) ->
  X1 = points[0][0]
  Y1 = points[0][1]

  X2 = points[1][0]
  Y2 = points[1][1] 

  X3 = points[2][0]
  Y3 = points[2][1] 

  X4 = points[3][0]
  Y4 = points[3][1]  

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

drawQuadraticCurve = (context, points, draw_points=false) ->
  X1 = points[0][0]
  Y1 = points[0][1]

  X2 = points[1][0]
  Y2 = points[1][1] 

  X3 = points[2][0]
  Y3 = points[2][1] 

  context.beginPath() 
  context.moveTo(X1, Y1)
  context.quadraticCurveTo(X3, Y3, X2, Y2)
  
  if draw_points
    drawPoint(context, X1, Y1)
    drawPoint(context, X2, Y2)
    drawPoint(context, X3, Y3) 

  context.stroke()
  context.closePath()   

drawArc = (context, points, draw_radius=false, draw_points=false) ->    
  X1 = points[0][0]
  Y1 = points[0][1]

  X2 = points[1][0]
  Y2 = points[1][1] 

  X3 = points[2][0]
  Y3 = points[2][1] 

  radius = Math.sqrt((X1-X2)*(X1-X2) + (Y1-Y2)*(Y1-Y2))
  start_angle = 0.5*Math.PI - Math.atan2(X2-X1, Y2-Y1)
  end_angle = 0.5*Math.PI - Math.atan2(X3-X1, Y3-Y1)

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

drawEllipce = (context, points, draw_radius=false, draw_points=false) -> 
  X1 = points[0][0]
  Y1 = points[0][1]

  X2 = points[1][0]
  Y2 = points[1][1] 

  X3 = points[2][0]
  Y3 = points[2][1] 

  width = Math.sqrt((X1-X2)*(X1-X2) + (Y1-Y2)*(Y1-Y2))*1.33
  height = Math.sqrt((X1-X3)*(X1-X3) + (Y1-Y3)*(Y1-Y3))

  context.beginPath() 
  context.moveTo(X1, Y1 - height)
  context.bezierCurveTo(X1 + width, Y1 - height, X1 + width, Y1 + height, X1, Y1 + height)
  context.bezierCurveTo(X1 - width, Y1 + height, X1 - width, Y1 - height, X1, Y1 - height)

  if draw_radius
    context.moveTo(X1, Y1)
    context.lineTo(X1+width/1.33, Y1)

  if draw_points
    drawPoint(context, X1, Y1)
    drawPoint(context, X1+width/1.33, Y1) 
    drawPoint(context, X3, Y3)   

  context.stroke()
  context.closePath()

######################    

drawText = () ->
  return

######################    

clearBoard = (context) -> 
  width = $("canvas").width()
  height = $("canvas").height() 
  context.clearRect(0, 0, width, height)

canvasInit = -> 
  points = []
  mouseDown = false
  
  board = createBoard()
  fake = createFakeBoard()
  createMenu()

  $("canvas#fake_board").mousedown (p) ->
    if not points.length 
      points.push([p.offsetX, p.offsetY])

    mouseDown = true

  $("canvas#fake_board").mouseup (p) -> 
    points.push([p.offsetX, p.offsetY])

    switch action 
      when "line" 
        if 2 == points.length 
          drawLine(board, points)
          points = []
          clearBoard(fake)
      when "circle" 
        if 2 == points.length
          drawCircle(board, points)
          points = []
          clearBoard(fake)
      when "ellipse"
        if 3 == points.length  
          drawEllipce(board, points)
          points = []
          clearBoard(fake)
      when "curve"
        if 3 == points.length
          drawQuadraticCurve(board, points)
          points = []
          clearBoard(fake)
      when "arc"
        if 3 == points.length
          drawArc(board, points)
          points = []
          clearBoard(fake) 
      when "bezier"
        if 4 == points.length
          drawBezierCurve(board, points)
          points = []
          clearBoard(fake)    
    
    mouseDown = false

  $("canvas#fake_board").mousemove (p) ->
    if mouseDown
      clearBoard(fake)

      switch action
        when "line" then drawLine(fake, points.concat([[p.offsetX, p.offsetY]]), true)
        when "circle" then drawCircle(fake, points.concat([[p.offsetX, p.offsetY]]), true, true)
        when "curve" 
          switch points.length
            when 2 then drawQuadraticCurve(fake, points.concat([[p.offsetX, p.offsetY]]), true)
            else drawLine(fake, points.concat([[p.offsetX, p.offsetY]]), true)
        when "arc"
          switch points.length
            when 2 then drawArc(fake, points.concat([[p.offsetX, p.offsetY]]), true, true)
            else drawCircle(fake, points.concat([[p.offsetX, p.offsetY]]), true, true)
        when "bezier" 
          switch points.length
            when 3 then drawBezierCurve(fake, points.concat([[p.offsetX, p.offsetY]]), true)
            when 2 then drawBezierCurve(fake, points.concat([[p.offsetX, p.offsetY],[p.offsetX, p.offsetY]]), true)
            else drawLine(fake, points.concat([[p.offsetX, p.offsetY]]), true) 
        when "ellipse"
          switch points.length
            when 2 then drawEllipce(fake, points.concat([[p.offsetX, p.offsetY]]), true, true)
            else drawCircle(fake, points.concat([[p.offsetX, p.offsetY]]), true, true)

# Load

$ ->
  canvasInit()
