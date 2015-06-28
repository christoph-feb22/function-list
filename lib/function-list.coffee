FunctionListView = require './function-list-view'
{CompositeDisposable} = require 'atom'

module.exports = FunctionList =
  functionListView: null
  modalPanel: null
  rightPanel: null
  subscriptions: null

  activate: (state) ->
    @functionListView = new FunctionListView(state.functionListViewState)
    # @modalPanel = atom.workspace.addModalPanel(item: @functionListView.getElement(), visible: false)
    @rightPanel = atom.workspace.addRightPanel(item: @functionListView.getElement(), visible: true)


    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'function-list:toggle': => @toggle()

    @subscriptions.add atom.commands.add 'atom-workspace', 'function-list:loadFunctions': => @loadFunctions()

    @subscriptions.add atom.workspace.onDidChangeActivePaneItem => @loadFunctions()

    @loadFunctions()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @functionListView.destroy()

  serialize: ->
    functionListViewState: @functionListView.serialize()

  loadFunctions: ->
    console.log "loadFunctions called"

    text = atom.workspace.getActiveTextEditor().getText()
    # functions = /[a-zA-Z]*:/.exec text
    coffeeFunctionRegex = /[a-zA-Z]+\:\s\-\>/g

    #cFunctionRegex = /(unsigned|signed)?\s+(void|int|char|short|long|float|double)\s+(\w+)\s*\([^)]*\)\s*\;/g
    cFunctionRegex = ///
                    (static\s+)?
                    ((unsigned|signed)\s+)?
                    (\w+)   # return type
                    \s+
                    (\w+)                                     # function name
                    \s*
                    \([^)]*\)                                 # function arguments
                    (\s|\n)*
                    \;
                    ///g


    functions = text.match(cFunctionRegex)
    # functions = text.match(/(a-zA-Z)+\:\s\-\>/i)
    console.log "#{functions}"
    @functionListView.setFunctionList functions
    # console.log "#{text}"

##
# ^
# \s*
# (unsigned|signed)?
# \s+
# (void|int|char|short|long|float|double)  # return type
# \s+
# (\w+)                                    # function name
# \s*
# \(
# [^)]*                                    # args - total cop out
# \)
# \s*
# ;
##

  toggle: ->
    console.log 'FunctionList was toggled!'

    if @rightPanel.isVisible()
      @rightPanel.hide()
    else
      # console.log 'X ' + functions
      @loadFunctions

      @rightPanel.show()
