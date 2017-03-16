TrussConsoleView = require './truss-console-view'
{CompositeDisposable} = require 'atom'
InfoView = require './console-info-view'

module.exports = TrussConsole =
  trussConsoleView: null
  modalPanel: null
  subscriptions: null
  ink: null
  cons: null
  client: null

  activate: (state) ->
    @trussConsoleView = new TrussConsoleView(state.trussConsoleViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @trussConsoleView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'truss-console:toggle': => @toggle()
    console.log "activated?"

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @trussConsoleView.destroy()

  serialize: ->
    trussConsoleViewState: @trussConsoleView.serialize()

  toggle: ->
    console.log 'TrussConsole was toggled!'

    @cons?.open
      split: 'right'
      searchAllPanes: true

  testOutput: (ncons) ->
    # do stuff?
    eh = new InfoView("Vector", [{k: "x", v: 12},
                                 {k: "y", v: 13},
                                 {k: "z", v: 14}])

    ncons.output({
      type: 'result',
      icon: 'circuit-board',
      result: eh.getTreeView(@ink)
    })

  evalInput: (s, ncons) ->
    console.log 'Would have evaluated: ' + s
    if @client?
      ncons.stdout("[evaluated]")
    else
      ncons.info('[no client connected]')
      @testOutput ncons

  consumeInk: (ink) ->
    @ink = ink
    console.log 'Got ink?'
    @cons = ink.Console.fromId 'truss-console'
    @cons.setModes [{grammar: 'source.lua'}]
    ncons = @cons
    @cons.onEval ({editor}) =>
      ncons.logInput()
      ncons.done()
      tt = editor.getText()
      @evalInput tt, ncons
      ncons.input()
