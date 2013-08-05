@app.main = () ->
  app.rootWindow = new IuguUI.ResponsiveBox
    el: "#app"
    sidebar: new SidebarController
  
  if app.rootLoader
    app.rootLoader.remove()

  app.rootWindow.render()
