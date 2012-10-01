# --------------------------------------------------------------------- 

sqr = (x) -> return x*x

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
  if points.length is 2 
    [X1, Y1] = points[0]
    drawEllipce(context, points.concat([[X1, Y1+10]]), draw_radius, draw_points)

  [[X1, Y1], [X2, Y2], [X3, Y3]] = points

  width = (X1 - X2) * 1.33
  height = Y1 - Y3

  context.beginPath() 
  context.moveTo(X1, Y1 - height)
  context.bezierCurveTo(X1 + width, Y1 - height, X1 + width, Y1 + height, X1, Y1 + height)
  context.bezierCurveTo(X1 - width, Y1 + height, X1 - width, Y1 - height, X1, Y1 - height)

  if draw_radius
    context.moveTo(X1, Y1)
    context.lineTo(X1 - width / 1.33, Y1)
    context.moveTo(X1, Y1)
    context.lineTo(X1, Y1 - height)

  if draw_points
    drawPoint(context, X1, Y1)
    drawPoint(context, X1 - width / 1.33, Y1) 
    drawPoint(context, X1, Y1 - height)   

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

drawText = (context, points, text) ->
  [[X1, Y1]] = points

  text = text.replace /^\s+/g, ""
  if text is "" then return

  context.fillText(text, X1, Y1)


# --------------------------------------------------------------------- 

draftDrawing = (action, context, points) -> 
  switch action
    when "line" then drawLine(context, points, true)
    when "circle" then drawCircle(context, points, true, true)
    when "curve" then drawQuadraticCurve(context, points, true)
    when "arc" then drawArc(context, points, true, true)
    when "bezier" then drawBezierCurve(context, points, true)
    when "ellipse" then drawEllipce(context, points, true, true)
    when "rectangle" then drawRect(context, points, true, true)

  return false  

finishDrawing = (action, context, points, text) -> 
  switch points.length       
    when 1
      switch action  
        when "text" then drawText(context, points, text)
        else return false
    when 2
      switch action 
        when "line" then drawLine(context, points)
        when "circle" then drawCircle(context, points)
        when "rectangle" then drawRect(context, points)
        else return false
    when 3
      switch action 
        when "ellipse" then drawEllipce(context, points)
        when "curve" then drawQuadraticCurve(context, points)
        when "arc" then drawArc(context, points)
        else return false
    when 4
      switch action 
        when "bezier" then drawBezierCurve(context, points)
        else return false 

  return true  

# ---------------------------------------------------------------------   

root = exports ? this
root.drawing = (action, context, points, others...) ->
  draft = false

  switch others.length
    when 1 
      switch typeof(others[0])
        when "string" then text = others[0]
        when "boolean" then draft = others[0]
        else return false
    when 2
      if (typeof(others[0]) is "string") and (typeof(others[1]) is "boolean") then text = others[0]
      else return false  

  if draft 
    return draftDrawing(action, context, points)
  else 
    return finishDrawing(action, context, points, text)      
  
  return false

