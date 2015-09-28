# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# An example hack to log to the console when each text editor is saved.
#
# atom.workspace.observeTextEditors (editor) ->
#   editor.onDidSave ->
#     console.log "Saved! #{editor.getPath()}"
atom.commands.add 'atom-text-editor', 'ruby:find-class', ->
  return unless editor = atom.workspace.getActiveTextEditor()

  selection = editor.getLastSelection()
  selection.expandOverWord()
  className = selection.getText()
  className = className.replace(/([A-Z\d]+)([A-Z][a-z])/g,'$1_$2')
  className = className.replace(/([a-z\d])([A-Z])/g,'$1_$2')
  className = className.toLowerCase() + '.rb'
  selection.insertText(className)

atom.commands.add 'atom-text-editor', 'auto-indent-selected', ->
  editor = atom.workspace.getActivePaneItem()
  editor.autoIndentSelectedRows()
