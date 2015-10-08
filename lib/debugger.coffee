OpenDialogView = require './open-dialog-view'
DebuggerView = require './debugger-view'
{CompositeDisposable} = require 'atom'
fs = require 'fs'

module.exports = Debugger =
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'debugger:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'core:close': =>
      @debuggerView?.destroy()
      @debuggerView = null
    @subscriptions.add atom.commands.add 'atom-workspace', 'core:cancel': =>
      @debuggerView?.destroy()
      @debuggerView = null

  deactivate: ->
    @subscriptions.dispose()
    @openDialogView.destroy()
    @debuggerView?.destroy()

  serialize: ->

  toggle: ->
    if @debuggerView and @debuggerView.hasParent()
      @debuggerView.destroy()
      @debuggerView = null
    else
      @openDialogView = new OpenDialogView (target, mainBreak) =>
        if fs.existsSync(target)
          @debuggerView = new DebuggerView(target, mainBreak)
        else
          atom.confirm
            detailedMessage: "Can't find file #{target}."
            buttons:
              Exit: =>
