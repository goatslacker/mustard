fs = require "fs"
path = require "path"
hogan = require "hogan.js"
{ setColor, setWidth } = require "./styles"


MustardString = (str) ->
  ms =
    toString: -> str
    valueOf: -> str

  un = str.replace /\u001b\[[0-9][0-9]m/g, ''
  Object.defineProperty ms, 'length', value: un.length

  ms


# if a property exists in an object.
iterateObject = (obj, fn) ->
  Object.keys(obj).forEach((key) ->
    fn obj[key], key
  )

inObject = (struct, key) ->
  Object.hasOwnProperty.call struct, key

# Retrieves the applyStlye function
getApplyStyle = (style) ->
  applyStyle = (text, render) ->
    { color, width } = style

    text = render text

    text = setWidth(text, width) if width
    text = setColor(text, color, mustard.colors) if color

    text

# Our utilty function for iterating and checking

# applyStlyes will apply the styles defined to the template
#
# It iterates through each property defined in the _styles_ Object
#
# For every method defined it will bind a function if that property
# exists in the _data_ Object and is a String.
#
# The function will then apply the styles colors or width to the text.
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


# addDirname is used to prefix defined `mustard.templates`
# if you haven't already passed in the template with __dirname
addDirname = (template) ->
  if template.substring(0, 1) != "/" and mustard.templates
    template = path.join mustard.templates, template

  template

# addExtension will add the .mu extension if it's missing
addExtension = (template) ->
  if template.substr(-3, 3) != ".mu"
    template += ".mu"

  template

# trimLines is meant to split the content
# by each line and trim any trailing whitespace
trimLines = (content) ->
  content.split("\n").map((v) ->
    v.trim()
  ).join("\n")


# mustard is our main function
#
# * __template__ _String_ the filename of the template
# * __data__ _Object_ the data that we'll pass to the template
# * __styles__ _Object_ the styles we will apply to the final output
#
# First we read the data from the file in the file system.
# Then we use hogan.js to compile the template.
# Afterwards we render the template and apply the styles to the template.
# The content is then trimmed and returned.
mustard = (template, data, styles) ->
  data ?= {}
  styles ?= {}

  templateData = fs.readFileSync addExtension addDirname template
  template = hogan.compile templateData.toString()

  content = applyStyles template, data, styles
  content = trimLines content

  MustardString content


# mustard.templates can be set to the prefix to all future templates
#
# For example:
#
# If you have all your templates in a `views/` directory and are
# parsing multiple templates you can do `mustard.templates = 'views'`
#
# This will turn `mustard('views/index.mu')` into `mustard('index.mu')`
mustard.templates = null

# mustard.colors is used to switch between 8 colors and 256 colors
#
# 256 color mode only works with terminals that support it (sorry Terminal.app)
mustard.colors = 8

# export to node.js
module.exports = mustard
