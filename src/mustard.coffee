fs = require "fs"
hogan = require "hogan.js"
{ setColor, setWidth } = require "./styles"

getApplyStyle = (style) ->
  applyStyle = (text, render) ->
    { color, width } = style

    text = render text

    text = setWidth(text, width) if width
    text = setColor(text, color, mustard.colors) if color

    text


iterateObject = (obj, fn) ->
  Object.keys(obj).forEach((key) ->
    fn obj[key], key
  )

inObject = (struct, key) ->
  Object.hasOwnProperty.call struct, key

applyStyles = (template, data, styles) ->

  addStyleToData = (style, name) ->
    applyStyle = getApplyStyle style

    if inObject data, name
      if data[name] and typeof data[name] is "string"
        data[name] = applyStyle
    else
      data[name] = applyStyle


  iterateObject styles, addStyleToData

  template.render data


addDirname = (template) ->
  if template.substring(0, 1) != "/" and mustard.templates
    template = mustard.templates + template

  template

addExtension = (template) ->
  if template.substr(-3, 3) != ".mu"
    template += ".mu"

  template

trimLines = (content) ->
  content.split("\n").map((v) ->
    v.trim()
  ).join("\n")


mustard = (template, data, styles) ->
  data ?= {}
  styles ?= {}

  templateData = fs.readFileSync addExtension addDirname template
  template = hogan.compile templateData.toString()

  content = applyStyles template, data, styles
  content = trimLines content

  content


mustard.templates = null
mustard.colors = 8


module.exports = mustard
