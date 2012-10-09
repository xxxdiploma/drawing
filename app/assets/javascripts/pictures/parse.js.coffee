# ---------------------------------------------------------------------

parseLine = (context, text) ->  
  tmp = text.match /(\d+[,\d+]+)/g
  action = text.match /(\w+[a-z])/g
  points = []

  for str in tmp
    XY = str.match /(\d+)/g
    points.push([parseInt(XY[0]), parseInt(XY[1])])
  
  drawing(action.toString(), context, points) 

# ---------------------------------------------------------------------      

root = exports ? this
root.parseCode = (context, text) ->
  tmp = text.match /(.*\n)/g

  if not tmp then return

  for str in tmp
    parseLine(context, str)  
 