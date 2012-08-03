class Tower.Generator.ControllerGenerator extends Tower.Generator
  sourceRoot: __dirname

  run: ->
    @directory "app/controllers/#{@controller.directory}"
    @template "controller.coffee", "app/controllers/#{@controller.directory}/#{@controller.name}.coffee"
    @template "client/controller.coffee", "app/client/controllers/#{@controller.directory}/#{@controller.name}.coffee".replace(/\/+/g, "/")
    #@template "client/objectController.coffee", "app/client/controllers/#{@model.name}Controller.coffee".replace(/\/+/g, "/")
    @route '@resources "' + @model.paramNamePlural + '"'
    @navigation @model.namePlural, "urlFor(#{@app.namespace}.#{@model.className})"
    @locale /links: */, """\n    #{@model.namePlural}: "#{@model.humanNamePlural}"
"""
    @asset "/app/client/controllers/#{@controller.directory}/#{@controller.name}".replace(/\/+/g, "/")
    #@asset "/app/client/controllers/#{@controller.directory}/#{@model.name}Controller".replace(/\/+/g, "/")
    @generate "mocha:controller"

module.exports = Tower.Generator.ControllerGenerator