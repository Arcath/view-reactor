fs = require 'fs'
assign = require 'object-assign'
os = require 'os'
React = require 'react'
path = require 'path'
webpack = require 'webpack'

module.exports =
  default_config:
    template: './template'

  init: (config) ->
    @config = assign(@default_config, config)

  clientFunctions: ->
    container = document.querySelector('#app')
    dataContainer = document.querySelector('#data')

    data = JSON.parse(dataContainer.innerHTML)

    React.render(React.createElement(component, data), container)

  renderClientFunctions: ->
    rendered = "(#{@clientFunctions.toString()})()"

  Engine: ->
    config = @config
    cf = @renderClientFunctions()
    (filePath, options, callback) ->
      try
        html = require config.template
        component = require filePath

        viewURI = filePath.replace(config.views_path, config.base_uri).replace(/\\/g, '/')
        viewMarkup = React.renderToStaticMarkup(React.createElement(component, options))

        htmlOptions = assign({viewMarkup: viewMarkup, viewReactor: cf, viewURI: viewURI, reactURL: config.reactURL}, options)
        htmlMarkup = React.renderToStaticMarkup(React.createElement(html, htmlOptions))

        callback(null, htmlMarkup)
      catch e
        callback(e)

  Middleware: ->
    config = @config

    (req, res, next) ->
      if req.url.match(new RegExp("^#{config.base_uri}"))
        filePath = req.url.replace(config.base_uri, config.views_path)

        outputPath = "#{os.tmpdir()}/view-reactor-#{process.pid}#{req.url}"

        if fs.existsSync("#{outputPath}/bundle.js")
          res.sendFile("#{outputPath}/bundle.js")
        else
          webpack({
              entry: filePath
              output: {
                path: outputPath
                library: 'component'
              },
              externals:{
                'react': 'React'
              }
          }, (err, stats) ->
            next(err) if err

            res.sendFile("#{outputPath}/bundle.js")
          )
      else
        next()
