class DashboardController extends ApplicationController

@DashboardController = DashboardController

class DashboardIndex extends DashboardController
  layout: 'dashboard/index'

  initialize: ->
    super
    @load()
    @

  render: ->
    super

    @

DashboardRouter = Backbone.Router.extend
  
  initialize: ->
    app.routes['dashboard#index'] = ''

  routes:
    "" : "index"
    "/": "index"

  index: ->
    Events.trigger "navigation:go", "dashboard"
    app.rootWindow.pushRootView new DashboardIndex

$ ->
  app.registerRouter( DashboardRouter )
