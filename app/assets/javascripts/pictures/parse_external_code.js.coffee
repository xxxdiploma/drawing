last_point = [0, 0]

# ---------------------------------------------------------------------

parseLine = (text) ->
  command = text.match /(\D\d+)/g

  if not command then return

  tmp = text.match /[gG](\d+)/g
  if not tmp then return
  action = parseInt(tmp[0].match /(\d+)/g)

  tmp = text.match /[xX](\d+)/g
  if not tmp then return
  X = parseInt(tmp[0].match /(\d+)/g)

  tmp = text.match /[yY](\d+)/g
  if not tmp then return
  Y = parseInt(tmp[0].match /(\d+)/g)

  #---

  context = $("#board")[0].getContext('2d')  

  #---

  current_point = [X, Y]

  switch action
    when 0
      last_point = current_point
    when 1 
      drawing("line", context, [last_point, current_point])
      last_point = current_point
  

# ---------------------------------------------------------------------      

root = exports ? this
root.parseExternalCode = (text) ->
  tmp = text.match /(.*\n)|(.*$)/g

  if not tmp then return

  for str in tmp
    parseLine(str)

