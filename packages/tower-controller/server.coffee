require './shared'
require './server/actions'
require './server/caching'
require './server/events'
require './server/net'
require './server/sockets'

Tower.Controller.include Tower.Controller.Actions
Tower.Controller.include Tower.Controller.Caching
Tower.Controller.include Tower.Controller.Events
Tower.Controller.include Tower.Controller.Net
Tower.Controller.include Tower.Controller.Sockets

Tower.Controller.reopenClass extended: ->
  object    = {}
  name      = @className()
  camelName = _.camelize(name, true)

  object[camelName] = Ember.computed(->
    Tower.Application.instance()[name].create()
  ).cacheable()

  Tower.Net.Connection.controllers.push(camelName)

  Tower.Net.Connection.reopen(object)

  @

require './server/renderers'
require './shared/tst'