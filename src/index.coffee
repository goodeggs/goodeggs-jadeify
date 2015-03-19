through = require "through"
jade = require "jade"

module.exports = (fileName) ->
  return through()  unless /\.jade$/i.test(fileName)
  inputString = ""
  through ((chunk) ->
    inputString += chunk
  ), ->
    renderedTemplate = undefined
    try
      renderedTemplate = jade.render(inputString, filename: fileName)
    catch e
      @emit "error", e
      return
    moduleBody = "module.exports = #{JSON.stringify(renderedTemplate)};"
    @queue moduleBody
    @queue null
