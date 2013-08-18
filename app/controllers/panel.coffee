Spine = require 'spine'

# Node-Webkit. IMPORTANT NOTE: USE WINDOW.REQUIRE
win = window.require('nw.gui').Window.get() if window.require

# Models
Note = require("../models/note.coffee")
Notebook = require("../models/notebook.coffee")
Modal = require("../controllers/modal.coffee")

class Panel extends Spine.Controller
  elements:
    "#noteControls": "noteControls"

  events:
    "click #decor img": "windowControl"
    "click #noteControls img": "noteControl"

  fullscreened: false

  maximized: false

  constructor: ->
    super
    Note.bind "changeNote", @toggle

  windowControl: (e) ->
    switch e.currentTarget.className
      when "close"
        win.close()
      when "minimize"
        win.minimize()
      when "maximize"
        win.maximize() unless @maximized is true
        win.unmaximize() unless @maximized is false
        @maximized = not @maximized
      when "fullscreen"
        @fullscreen()

  fullscreen: ->
    if @fullscreened is true
      win.leaveFullscreen()
      $('.maximize').show()
      $('.minimize').show()
    else
      win.enterFullscreen()
      $('.maximize').hide()
      $('.minimize').hide()
    @fullscreened = not @fullscreened

  noteControl: (e) ->
    switch e.currentTarget.id
      when "new"

        # Create the note meta
        note = Note.create
          name: "Untitled Note"
          excerpt: "lorem ipsum dol el emit"
          notebook: Notebook.current.id
          category: if Notebook.current.category is "all" then Notebook.find(Notebook.current.id).categories[0] else Notebook.find(Notebook.current.id).categories[Notebook.current.category]
          date: Math.round(new Date().getTime()/1000)

        # Set the content with the special function
        note.saveNote("lorem ipsum dol el emit swag fagg yolo dog")
      when "share"
        console.log("Sharing")
      when "del"
        Modal.get("delete").run()

  toggle: (note) =>
    if note isnt undefined
      @noteControls.removeClass("disabled")
    else
      @noteControls.addClass("disabled")


module.exports = Panel