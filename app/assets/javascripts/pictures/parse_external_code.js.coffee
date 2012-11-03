# ---------------------------------------------------------------------

root = exports ? this

last_point = [0, 0, 0] # [X, Y, Z]

# ---------------------------------------------------------------------

sqr = (x) -> 
  return x*x   

# ---------------------------------------------------------------------

#перемещение
G00 = (current_point) ->
  return null

#линия
G01 = (current_point) ->
  return [last_point, current_point]  

#дуга по часовой стрелке
G02 = (current_point, R) ->
  radius_point = getRadiusPoint(R, current_point, true)
  
  return [radius_point, last_point, current_point]   

#дуга против часовой стрелки
G03 = (current_point, R) ->
  radius_point = getRadiusPoint(R, current_point, false)

  return [radius_point, current_point, last_point]

#сверление
#G81 = (current_point, R) -> 
#  radius_point = [current_point[0] + R, current_point[1] + R, current_point[2]]
#  last_point = current_point  

  return [current_point, radius_point]
 
# ---------------------------------------------------------------------

setAction = (action) ->
  result = switch action
    when 0 then null
    when 1 then "line"
    when 2 then "arc"
    when 3 then "arc"

  return result  

printFigureCode = (param) ->
  action = param["action"]
  current_point = param["points"]
  radius = param["radius"]

  points = switch action
    when 0 then G00(current_point)
    when 1 then G01(current_point) 
    when 2 then G02(current_point, radius)
    when 3 then G03(current_point, radius)

  last_point = current_point    

  if points 
    action = setAction(action)
    text = $("#picture_code")
    old_text = text.val().replace /^\s+/g, ""
    text.val(old_text + action + " " + points.join(" ") + "\n")


# ---------------------------------------------------------------------  

getRadiusPoint = (R, point, ckw) ->
  [X1, Y1, Z1] = point
  [X0, Y0, Z0] = last_point 

  mod = 1
  if ckw then mod = -1 

  Cx = (X0 - X1)/2 + X1
  Cy = (Y0 - Y1)/2 + Y1
  Cz = (Z0 - Z1)/2 + Z1

  d = Math.sqrt(sqr(X0 - X1) + sqr(Y0 - Y1) + sqr(Z0 - Z1)) 
  h = Math.sqrt(sqr(R) - sqr(d/2))
  
  Rx = parseInt(Cx - mod*h*(X0 - Y1)/d)
  Ry = parseInt(Cy + mod*h*(Y0 - X1)/d)
  Rz = parseInt(Cz + h*(Z0 - Z1)/d)

  return [Rx, Ry, Rz]

# ---------------------------------------------------------------------

parseLine = (text) ->

  tmp = text.match /[gG](\d+)/g
  if not tmp then return null
  
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
  if not tmp 
    R = 0
  else
    R = parseInt(tmp[0].match /(\d+)/g)  
  
  return {"action": action, "points": [X, Y, Z], "radius": R}

# ---------------------------------------------------------------------      

root.parseExternalCode = (text) ->
  tmp = text.match /(.*\n)|(.*$)/g
  if not tmp then return false

  for str in tmp
    if param = parseLine(str) then printFigureCode(param)

   