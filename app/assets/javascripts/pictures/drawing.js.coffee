# --------------------------------------------------------------------- 

root = exports ? this
demension = "xy"

# --------------------------------------------------------------------- 

sqr = (x) -> return x*x

# Get Demension -------------------------------------------------------

changeDemension = (points) -> 
  [X, Y, Z] = points

  X0 = X*Math.cos(Math.PI/6) - Y*Math.sin(Math.PI/3)
  Y0 = (X+Y)*Math.tan(Math.PI/6) + Z
  
  return [parseInt(X0), parseInt(Y0)]

getDemension = (points) ->
  new_points = []

  if demension.length is 2
    switch demension
      when "xy" then [a, b] = [0, 1]
      when "xz" then [a, b] = [0, 2]
      when "yz" then [a, b] = [1, 2]

    for i in points
      new_points.push([i[a], i[b]])
  else
    for i in points
      new_points.push(changeDemension(i))

  return new_points

# Drawing functions --------------------------------------------------- 

drawPoint = (context, X1, Y1) ->  
  context.moveTo(X1 - 5, Y1)
  context.lineTo(X1 + 5, Y1)
  context.moveTo(X1, Y1 - 5)
  context.lineTo(X1, Y1 + 5) 

drawLine = (context, points, draw_points = false) -> 
  [[X1, Y1], [X2, Y2]] = getDemension(points)

  context.beginPath()
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

  [[X1, Y1], [X2, Y2], [X3, Y3], [X4, Y4]] = getDemension(points)

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

  [[X1, Y1], [X2, Y2], [X3, Y3]] = getDemension(points)

  context.beginPath() 
  context.moveTo(X1, Y1)
  context.quadraticCurveTo(X3, Y3, X2, Y2)
  
  if draw_points
    drawPoint(context, X1, Y1)
    drawPoint(context, X2, Y2)
    drawPoint(context, X3, Y3) 

  context.stroke()
  context.closePath()     

#Только для плоскости ХУ
drawCircle = (context, points, draw_radius = false, draw_points = false) ->
  if demension is "xy"
    drawCircle2D(context, points, draw_radius, draw_points)
  else
    drawCircle3D(context, points)

#Только для плоскости ХУ
drawCircle3D = (context, points) ->
  [[X0, Y0, Z0], [X01, Y01, Z01]] = points

  R = Math.sqrt(sqr(X0-X01) + sqr(Y0-Y01) + sqr(Z0-Z01))

  modX = parseInt(R/1.42)
  modY = parseInt(R/1.42)
  mod = parseInt(R/2.5)

  [[X1, Y1, Z1], [X2, Y2, Z2], [X3, Y3, Z3], [X4, Y4, Z4]] = [
    [X0 + modX, Y0 - modY, Z0],
    [X0 + modX, Y0 + modY, Z0],
    [X0 - modX, Y0 + modY, Z0],
    [X0 - modX, Y0 - modY, Z0]] 

  drawBezierCurve(context, [[X1, Y1, Z1], [X2, Y2, Z2], [X1+mod, Y1+mod, Z1], [X2+mod, Y2-mod, Z2]])
  drawBezierCurve(context, [[X2, Y2, Z2], [X3, Y3, Z3], [X2-mod, Y2+mod, Z2], [X3+mod, Y3+mod, Z3]])
  drawBezierCurve(context, [[X3, Y3, Z3], [X4, Y4, Z4], [X3-mod, Y3-mod, Z3], [X4-mod, Y4+mod, Z4]])
  drawBezierCurve(context, [[X4, Y4, Z4], [X1, Y1, Z1], [X4+mod, Y4-mod, Z4], [X1-mod, Y1-mod, Z1]])

#Только для плоскости ХУ
drawCircle2D = (context, points, draw_radius = false, draw_points = false) ->
  [[X0, Y0], [X1, Y1]] = getDemension(points)

  R = parseInt(Math.sqrt(sqr(X0-X1) + sqr(Y0-Y1)))

  context.beginPath()  
  context.arc(X0, Y0, R, 0, 2 * Math.PI, false)  

  if draw_radius
    context.moveTo(X0, Y0)
    context.lineTo(X1, Y1)  

  if draw_points
    drawPoint(context, X0, Y0)
    drawPoint(context, X1, Y1)
  
  context.stroke()
  context.closePath()

#Только для плоскости ХУ
drawArc = (context, points, draw_radius = false, draw_points = false) ->
  if demension is "xy"
    drawArc2D(context, points, draw_radius, draw_points)
  else
    drawArc3D(context, points)

#Только для плоскости ХУ <-- ДОПИСАТЬ ----------------------------------------------------- <<
drawArc3D = (context, points) ->
  [[X0, Y0, Z0], [X01, Y01, Z01], [X02, Y02, Z02]] = points

  R = Math.sqrt(sqr(X0 - X01) + sqr(Y0 - Y01))
  
  a = Math.atan2(X02 - X01, Y02 - Y01)

  [[X1, Y1, Z1], [X2, Y2, Z2], [X3, Y3, Z3], [X4, Y4, Z4]] = [
    [X0+R*Math.sin(a), Y0+R*Math.cos(a), Z0],
    [X0-R*Math.sin(a), Y0-R*Math.cos(a), Z0],
    [X0+R*Math.cos(a), Y0+R*Math.sin(a), Z0],
    [X0-R*Math.cos(a), Y0-R*Math.sin(a), Z0]] 

  #drawLine(context, [[X0, Y0, Z0], [X1, Y1, Z1]])
  #drawLine(context, [[X0, Y0, Z0], [X2, Y2, Z2]])  
  #drawLine(context, [[X0, Y0, Z0], [X3, Y3, Z3]])
  #drawLine(context, [[X0, Y0, Z0], [X4, Y4, Z4]])

  drawLine(context, [[X01, Y01, Z01], [X4, Y4, Z4]])
  drawLine(context, [[X02, Y02, Z02], [X4, Y4, Z4]])  

  #drawCircle3D(context, [[X0, Y0, Z0], [X01, Y01, Z01]])

#Только для плоскости ХУ   
drawArc2D = (context, points, draw_radius = false, draw_points = false) ->
  if points.length is 2 then drawCircle(context, points, draw_radius, draw_points)

  [[X1, Y1], [X2, Y2], [X3, Y3]] = getDemension(points)

  R = Math.sqrt(sqr(X1 - X2) + sqr(Y1 - Y2))
  start_angle = 0.5 * Math.PI - Math.atan2(X2 - X1, Y2 - Y1)
  end_angle = 0.5 * Math.PI - Math.atan2(X3 - X1, Y3 - Y1)

  context.beginPath()  
  context.arc(X1, Y1, R, start_angle, end_angle, false)

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
  if demension is "xy"
    drawEllipce2D(context, points, draw_radius, draw_points)
  else
    drawEllipce3D(context, points)

drawEllipce3D = (context, points) ->
  [[X0, Y0, Z0], [X01, Y01, Z01], [X02, Y02, Z02]] = points

  width = Math.sqrt(sqr(X0-X01) + sqr(Y0-Y01) + sqr(Z0-Z01))
  height = Math.sqrt(sqr(X0-X02) + sqr(Y0-Y02) + sqr(Z0-Z02))

  modX = parseInt(width/1.73)
  modY = parseInt(height/1.73)

  width = parseInt(width)
  height = parseInt(height)

  [[X1, Y1, Z1], [X2, Y2, Z2], [X3, Y3, Z3], [X4, Y4, Z4]] = [
    [X0 - width, Y0, Z0],
    [X0, Y0 + height, Z0],
    [X0 + width, Y0, Z0],
    [X0, Y0 - height, Z0]] 

  drawBezierCurve(context, [[X1, Y1, Z1], [X2, Y2, Z2], [X1, Y1 + modY, Z1], [X2 - modX, Y2, Z2]]) 
  drawBezierCurve(context, [[X2, Y2, Z2], [X3, Y3, Z3], [X2 + modX, Y2, Z2], [X3, Y3 + modY, Z3]])
  drawBezierCurve(context, [[X3, Y3, Z3], [X4, Y4, Z4], [X3, Y3 - modY, Z3], [X4 + modX, Y4, Z4]])
  drawBezierCurve(context, [[X4, Y4, Z4], [X1, Y1, Z1], [X4 - modX, Y4, Z4], [X1, Y1 - modY, Z1]])

drawEllipce2D = (context, points, draw_radius = false, draw_points = false) -> 
  if points.length is 2 
    [X1, Y1] = points[0]
    drawEllipce(context, points.concat([[X1, Y1+10]]), draw_radius, draw_points)

  [[X1, Y1], [X2, Y2], [X3, Y3]] = getDemension(points)

  width  = X1 - X2
  height = Y1 - Y3

  modX = parseInt(width / 1.72)
  modY = parseInt(height / 1.72)

  context.beginPath() 
  context.moveTo(X1, Y1 - height)
  
  context.bezierCurveTo(X1 - modX, Y1 - height, X1 - width, Y1 - modY, X1 - width, Y1)
  context.bezierCurveTo(X1 - width, Y1 + modY, X1 - modX, Y1 + height, X1, Y1 + height) 
  context.bezierCurveTo(X1 + modX, Y1 + height, X1 + width, Y1 + modY, X1 + width, Y1)
  context.bezierCurveTo(X1 + width, Y1 - modY, X1 + modX, Y1 - height, X1, Y1 - height) 

  if draw_radius
    context.moveTo(X1, Y1)
    context.lineTo(X1 - width, Y1)
    context.moveTo(X1, Y1)
    context.lineTo(X1, Y1 - height)

  if draw_points
    drawPoint(context, X1, Y1)
    drawPoint(context, X1 - width, Y1) 
    drawPoint(context, X1, Y1 - height)   

  context.stroke()
  context.closePath()

drawRect = (context, points, draw_diag = false, draw_points = false) ->
  if demension.length is 2
    drawRect2D(context, points, draw_diag, draw_points)
  else
    drawRect3D(context, points)

#Только для ХУ
drawRect3D = (context, points) ->
  [[X1, Y1, Z1], [X3, Y3, Z3]] = points
  [[X2, Y2, Z2], [X4, Y4, Z4]] = [[X3, Y1, Z1], [X1, Y3, Z3]]

  drawLine(context, [[X1, Y1, Z1], [X2, Y2, Z2]])
  drawLine(context, [[X2, Y2, Z2], [X3, Y3, Z3]]) 
  drawLine(context, [[X3, Y3, Z3], [X4, Y4, Z4]]) 
  drawLine(context, [[X4, Y4, Z4], [X1, Y1, Z1]])  

drawRect2D = (context, points, draw_diag = false, draw_points = false) ->
  [[X1, Y1], [X3, Y3]] = getDemension(points)
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

finishDrawing = (action, context, points) -> 
  switch points.length       
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

root.drawing2D = (action, context, dem, points, draft = false) ->
  demension = dem

  if draft 
    return draftDrawing(action, context, points)
  else 
    return finishDrawing(action, context, points)      
  
  return false  

root.drawing3D = (action, context, points) ->
  demension = "xyz"
  return finishDrawing(action, context, points)         

