reset = "\x1b[00m"
colors = require "./colors.json"


co8 = (text, color) ->
  "\x1b[#{colors["8"][color]}m#{text}#{reset}"


co256 = (text, color) ->
  ground = 48
  "\x1b[#{ground};05;#{colors["256"][color]}m#{text}#{reset}"


setColor = (text, color, mode) ->
  if mode is 256
    applyColor = co256
    hash = colors["256"]
  else
    applyColor = co8
    hash = colors["8"]

  if hash.hasOwnProperty color
    applyColor text, color
  else
    text


setWidth = (text, width) ->
  if text.length < width
    text += new Array(width - text.length + 1).join " "
  else if text.length > width
    text = text.substring 0, width

  text


stylesAPI = { setColor, setWidth }

module.exports = stylesAPI
