class SidebarController extends ApplicationController
  layout: "sidebar/sidebar"
  secondaryView: true
  className: "iugu-main-sidebar"

  events:
    'click [data-action=dashboard]' : 'openDashboard'

  initialize: ->
    super

  openDashboard: (evt) ->
    app.rootWindow.closeSidebar()
    evt.preventDefault()
    Backbone.history.navigate app.routes['dashboard#index'], trigger: true

@SidebarController = SidebarController
