# ---------------------------------------------------------------------

last_point = [0, 0, 0] #X, Y, Z

# ---------------------------------------------------------------------

sqr = (x) -> 
  return x*x   

# ---------------------------------------------------------------------

#перемещение
G00 = (current_point) ->
  last_point = current_point

#линия
G01 = (current_point) ->
  printFigureCode("line", [last_point, current_point])  
  last_point = current_point

#дуга по часовой стрелке
#G02 = (current_point, R) ->
#  radius_point = getRadiusPoint(R, current_point, true)
#  printFigureCode("arc", [radius_point, last_point, current_point])
#  last_point = current_point      

#дуга против часовой стрелки
#G03 = (current_point, R) ->
#  radius_point = getRadiusPoint(R, current_point, false)
#  printFigureCode("arc", [radius_point, current_point, last_point])
#  last_point = current_point    

#сверление
#G81 = (current_point, R) -> 
#  radius_point = [current_point[0] + R, current_point[1]]
#  printFigureCode("circle", [current_point, radius_point])
#  last_point = current_point  

# ---------------------------------------------------------------------

printFigureCode = (action, points) ->
  text = $("#picture_code")
  old_text = text.val().replace /^\s+/g, ""
  text.val(old_text + action + " " + points.join(" ") + "\n")

# ---------------------------------------------------------------------  

getRadiusPoint = (R, point, ckw) ->
  [X, Y] = point
  [X0, Y0] = last_point 

  mod = 1
  if ckw then mod = -1 

  Cx = (X0 - X)/2 + X
  Cy = (Y0 - Y)/2 + Y

  d = Math.sqrt(sqr(X0 - X) + sqr(Y0 - Y)) 
  h = Math.sqrt(sqr(R) - sqr(d/2))
  
  Rx = parseInt(Cx - mod*h*(X0 - Y)/d)
  Ry = parseInt(Cy + mod*h*(Y0 - X)/d)

  return [Rx, Ry]

# ---------------------------------------------------------------------

changeDemension = (X, Y, Z) -> 
  X0 = X*Math.cos(Math.PI/6) - Y*Math.sin(Math.PI/3)
  Y0 = (X+Y)*Math.tan(Math.PI/6) + Z
  
  return [parseInt(X0), parseInt(Y0)]

# ---------------------------------------------------------------------

parseLine = (text) ->
  R = 0

  tmp = text.match /[gG](\d+)/g
  if not tmp then return
  action = parseInt(tmp[0].match /(\d+)/g)

  tmp = text.match /[xX](\d+)/g
  if not tmp 
    X = last_point[0]
  else
    X = parseInt(tmp[0].match /(\d+)/g)

  tmp = text.match /[yY](\d+)/g
  if not tmp 
    Y = last_point[1]
  else  
    Y = parseInt(tmp[0].match /(\d+)/g)

  tmp = text.match /[zZ](\d+)/g
  if not tmp 
    Z = last_point[2]
  else  
    Z = parseInt(tmp[0].match /(\d+)/g)    

  tmp = text.match /[rR](\d+)/g
  if tmp then R = parseInt(tmp[0].match /(\d+)/g)    

  current_point = [X, Y, Z]

  switch action
    when 0 then G00(current_point)
    when 1 then G01(current_point)   
    when 2 then G02(current_point, R)    
    when 3 then G03(current_point, R) 
    when 40 then G40()
    when 41 then G41()
    when 42 then G42()
    when 81 then G81(current_point, R)

# ---------------------------------------------------------------------      

root = exports ? this
root.parseExternalCode = (text) ->
  tmp = text.match /(.*\n)|(.*$)/g

  if not tmp then return

  for str in tmp
    parseLine(str)

