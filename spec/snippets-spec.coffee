CSON = require 'season'

defs = CSON.readFileSync("#{__dirname}/../snippets/language-frege.cson")

describe "Snippets", ->
  [editorElement, editor, Snippets] = []

  simulateTabKeyEvent = ({shift} = {}) ->
    event = atom.keymaps.constructor.buildKeydownEvent('tab', {shift, target: editorElement})
    atom.keymaps.handleKeyboardEvent(event)

  sanitize = (body) ->
    parser = Snippets.getBodyParser()
    flatten = (obj) ->
      if typeof(obj) is "string"
        return obj
      else
        return obj.content.map(flatten).join('')
    parsed =
      parser.parse(body)
      .map(flatten)
      .join('')
      .replace /\t/g, ' '.repeat(editor.getTabLength())
    return parsed

  universalTests = ->
    it 'triggers snippets', ->
      expect((for name, {prefix, body} of defs['.source .frege']
        editor.setText("")
        editor.insertText(prefix)
        simulateTabKeyEvent()
        expect(editor.getText().trim()).toBe sanitize(body).trim()
      ).length).toBeGreaterThan 0
    it 'triggers non-comment snippets', ->
      expect((for name, {prefix, body} of defs['.source .frege:not(.comment)']
        editor.setText("")
        editor.insertText(prefix)
        simulateTabKeyEvent()
        expect(editor.getText().trim()).toBe sanitize(body).trim()
      ).length).toBeGreaterThan 0
    it 'triggers comment snippets', ->
      expect((for name, {prefix, body} of defs['.source .frege.comment']
        editor.setText("")
        editor.insertText("-- #{prefix}")
        simulateTabKeyEvent()
        expect(editor.getText().trim()).toBe "-- #{sanitize(body).trim()}"
      ).length).toBeGreaterThan 0
    it 'triggers empty-list snippets', ->
      expect((for name, {prefix, body} of defs['.source .frege.constant.language.empty-list']
        editor.setText("")
        editor.insertText("#{prefix}]")
        editor.getLastCursor().moveLeft()
        simulateTabKeyEvent()
        expect(editor.getText().trim()).toBe "#{sanitize(body).trim()}]"
      ).length).toBeGreaterThan 0
    it 'triggers type snippets', ->
      expect((for name, {prefix, body} of defs['.source .frege.meta.type']
        editor.setText("")
        editor.insertText("data Data = Constr #{prefix}")
        simulateTabKeyEvent()
        expect(editor.getText().trim()).toBe "data Data = Constr #{sanitize(body).trim()}"
      ).length).toBeGreaterThan 0

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-frege")
    waitsForPromise ->
      snippets = atom.packages.getLoadedPackage('snippets') ? \
        atom.packages.loadPackage("#{process.env.HOME}/.atom/packages/snippets")
      snippets.activate()
      .then ->
        Snippets = snippets.mainModule
        new Promise (resolve) ->
          Snippets.onDidLoadSnippets -> resolve()

  describe 'frege', ->
    beforeEach ->
      waitsForPromise ->
        atom.workspace.open('sample.fr')
      runs ->
        editor = atom.workspace.getActiveTextEditor()
        editorElement = atom.views.getView(editor)
    universalTests()
