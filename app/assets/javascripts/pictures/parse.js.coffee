# ---------------------------------------------------------------------

parseCode = (context, text) ->  
  tmp = []
  points = []
  pos = 0

  loop
    tmp.push pos
    pos = text.indexOf ",", pos + 1 
    if pos < 0 then break
    tmp.push pos

  tmp.push text.length

  action = text[tmp[0]..tmp[1]-1]

  if action is "text"
    user_text = text[tmp[6]+1..text.length-1]
    tmp = tmp[0..5]

  points_count = tmp.length/2-1

  for i in [1..points_count] when i % 2
    X = text[tmp[i*2]+1..tmp[i*2+1]-1]
    Y = text[tmp[(i+1)*2]+1..tmp[(i+1)*2+1]-1]
    points.push([parseInt(X), parseInt(Y)])

  if action is "text"
    drawing(action, context, points, user_text)
  else 
    drawing(action, context, points) 

# ---------------------------------------------------------------------      

root = exports ? this
root.parseAndDraw = (context, text) ->
  length = text.length-2
  start = 0

  while finish isnt length
    finish = text.indexOf("\n", start+1)-1
    parseCode(context, text[start..finish])
    start = finish+2
 