###
global error handling

$(window).error (event) ->
  try
    App.errorHandler(event)
  catch error
    console.log(error)
###

class Tower.Application extends Tower.Engine
  @_callbacks: {}

  @before 'initialize', 'setDefaults'

  setDefaults: ->
    #Tower.Model.default "store", Tower.Store.Ajax
    #Tower.Model.field "id", type: "Id"

    true

  @instance: ->
    @_instance

  teardown: ->
    Tower.Route.reload()

  init: ->
    @_super arguments...

    throw new Error("Already initialized application") if Tower.Application._instance

    Tower.Application._instance = @

  ready: ->
    @_super arguments...

    #$("a").on 'click', ->
    #  Tower.get($(this).attr("href"))

  initialize: ->
    @extractAgent()
    @setDefaults()
    @

  extractAgent: ->
    Tower.cookies = Tower.Net.Cookies.parse()
    Tower.agent   = new Tower.Net.Agent(JSON.parse(Tower.cookies["user-agent"] || '{}'))

  listen: ->
    return if @listening
    @listening = true

    Tower.url ||= "#{window.location.protocol}//#{window.location.host}"
    # Clients can only be connected to 1 connection in certain browser, this is a known hack I guess!
    # see https://groups.google.com/forum/#!msg/socket_io/eNSAXgE9FjA/wv5zN0OpKpkJ
    Tower.socketUrl ||= "#{window.location.protocol}://io-#{Tower.port}.#{window.location.host}"
    
    Tower.Net.Connection.initialize()
    Tower.Net.Connection.listen(Tower.socketUrl)

    if Tower.history && Tower.history.enabled
      Tower.history.Adapter.bind global, "statechange", =>
        state     = Tower.history.getState()
        params    = _.extend(title: state.title, (state.data || {}))
        location  = new Tower.Net.Url(state.url)
        request   = new Tower.Net.Request(url: state.url, location: location, params: params)
        response  = new Tower.Net.Response(url: state.url, location: location)
        Tower.stateManager.handleUrl(location.path, params)
      $(global).trigger("statechange")
    else
      console.warn "History not enabled"

  run: ->
    @listen()

module.exports = Tower.Application