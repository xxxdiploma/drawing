# Canvas test

createFakeBoard = ->
  canvas = document.createElement("canvas")
  canvas.id = "fake_board"
  canvas.width = $("canvas").width()
  canvas.height = $("canvas").height()

  $("#board")[0].parentNode.appendChild(canvas)
  $("#fake_board").css {"position" : "relative", "top" : -canvas.height-3}

  context = canvas.getContext('2d')
  context.strokeStyle = "#b2d179"

  return context


createBoard = ->
  canvas = $("#board")[0]
  canvas.width = $("canvas").width()
  canvas.height = $("canvas").height()
  context = canvas.getContext('2d')   

  return context


drawLine = (context, X1, Y1, X2, Y2) ->
  context.beginPath()  
  context.moveTo(X1, Y1)
  context.lineTo(X2, Y2)
  context.stroke()
  context.closePath()

  return false

clearBoard = (context) -> 
  width = $("canvas").width()
  height = $("canvas").height() 
  context.clearRect(0, 0, width, height)


canvasInit = ->
  mouseX = 0
  mouseY = 0
  mouseDown = false
  action = "line"

  board = createBoard()
  fake = createFakeBoard()

  $("canvas#fake_board").mousedown (p) ->
    mouseX = p.offsetX
    mouseY = p.offsetY
    mouseDown = true

  $("canvas#fake_board").mouseup (p) ->
    clearBoard(fake)

    drawLine(board, mouseX, mouseY, p.offsetX, p.offsetY)
    mouseDown = false

  $("canvas#fake_board").mousemove (p) ->
    clearBoard(fake)

    if mouseDown
      switch action
        when "line" then drawLine(fake, mouseX, mouseY, p.offsetX, p.offsetY)

  
  return false

# Load

$ ->
  canvasInit()
