{View, TextEditorView} = require 'atom-space-pen-views'

module.exports =
class OpenDialogView extends View
  @content: ->
    @div tabIndex: -1, class: 'atom-debugger', =>
      @div class: 'block', =>
        @label 'Atom Debugger'
        @subview 'targetEditor', new TextEditorView(mini: true, placeholderText: 'Target Binary File Path')
      @div class: 'checkbox', =>
        @input type: 'checkbox', checked: 'true', outlet: 'mainBreakCheckbox'
        @label class: 'checkbox-label', 'Add breakpoint in `main` function'
      @div class: 'block', =>
        @button class: 'inline-block btn', outlet: 'startButton', 'Start'
        @button class: 'inline-block btn', outlet: 'cancelButton', 'Cancel'

  initialize: (handler) ->
    @panel = atom.workspace.addModalPanel(item: this, visible: true)
    @targetEditor.focus()

    @cancelButton.on 'click', (e) => @destroy()
    @startButton.on 'click', (e) =>
      handler(@targetEditor.getText(), @mainBreakCheckbox.prop('checked'))
      @destroy()

  destroy: ->
    @panel.destroy()
