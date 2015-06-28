{$} = require 'atom-space-pen-views'

module.exports =
class FunctionListView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('function-list')

    # Create message element
    message = document.createElement('div')
    message.textContent = "The FunctionList package is Alive! It's ALIVE!"
    message.classList.add('message')
    @element.appendChild(message)

    # atom.workspace.addLeftPanel(item: this)

    # @handleEvents()


  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  handleEvents: ->
    # @on 'dblclick', '.tree-view-resize-handle', =>
    #   @resizeToFitContent()
    $('li.function-list-element').on 'click', (e) =>
      # # This prevents accidental collapsing when a .entries element is the event target
      # return if e.target.classList.contains('entries')
      console.log "click"
      console.log "entry clicked: #{e}"
      @entryClicked(e) unless e.shiftKey or e.metaKey or e.ctrlKey
    # @on 'mousedown', '.entry', (e) =>
    #   @onMouseDown(e)

  entryClicked: (e) ->
    functionElement = e.currentTarget

    @gotoFunction(functionElement)

    # entry = e.currentTarget
    # isRecursive = e.altKey or false
    # switch e.originalEvent?.detail ? 1
    #   when 1
    #     @selectEntry(entry)
    #     @openSelectedEntry(false) if entry instanceof FileView
    #     entry.toggleExpansion(isRecursive) if entry instanceof DirectoryView
    #   when 2
    #     if entry instanceof FileView
    #       @unfocus()
    #     else if DirectoryView
    #       entry.toggleExpansion(isRecursive)
    #
    # false


  # Move focus to selected function
  #
  gotoFunction: (functionElement) ->
    console.log "#{functionElement.textContent}"

    editor = atom.workspace.getActiveTextEditor()
    start = [0,0]
    end = [editor.getLastBufferRow(), 0]
    searchRange = [[0,0], [editor.getLastBufferRow(), 0]]
    console.log "Suche in #{searchRange}"

    searchWord = functionElement.textContent.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&")
    # searchWord = searchWord.replace(' ', '(\s+)')
    searchWord = searchWord.replace(/;/, '[\s\n]*{')
    searchWord = new RegExp(searchWord, 'g')
    console.log "Regex für Suche: #{searchWord}"
    editor.scanInBufferRange searchWord, searchRange, ({range}) =>
      # newMarkers.push(@createMarker(range))
      console.log "suche nach: #{functionElement.textContent}"
      console.log "gefunden: , an: #{range}"
      gotoPosition = range.start
      console.log "gehe nach: #{gotoPosition}"
      editor.setCursorBufferPosition(gotoPosition)


  setCount: (count) ->
    displayText = "There are #{count} words."
    @element.children[0].textContent = displayText

  setFunctionList: (functions) ->
    console.log "setFunctionList called"
    # Remove old function list
    # TODO

    functionList = document.createElement('ul')
    functionList.classList.add('functions')

    if functions
      for method in functions
        functionElement = document.createElement('li')
        functionElement.classList.add('function-list-element')
        functionElement.textContent = "#{method}"
        functionList.appendChild(functionElement)
        # displayText += "\n #{method}"
    #@element.children[0].textContent = displayText
    @element.appendChild(functionList)

    # Add event listener
    @handleEvents()
