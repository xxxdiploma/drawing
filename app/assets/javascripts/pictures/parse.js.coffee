# ---------------------------------------------------------------------

parseLine = (text) ->  
  tmp = text.match /(\d+[,\-*\d+]+)/g
  action = (text.match /(\w+[a-z])/g).toString()
  points = []

  for str in tmp
    XY = str.match /(-*\d+)/g
    points.push([parseInt(XY[0]), parseInt(XY[1]), parseInt(XY[2])])

  return {"action": action, "points": points}

# ---------------------------------------------------------------------      

root = exports ? this
root.parseCode = (context, demension, text) ->
  tmp = text.match /(.*\n)/g

  if not tmp then return false

  if demension.length is 2
    for str in tmp
      param = parseLine(str, demension)   
      drawing2D(param["action"], context, demension, param["points"])   
  else
    for str in tmp
      param = parseLine(str, demension)   
      drawing3D(param["action"], context, param["points"])

  return true  
 