{grammarExpect, customMatchers} = require './util'

describe "Language-Frege", ->
  grammar = null

  beforeEach ->
    @addMatchers(customMatchers)
    waitsForPromise ->
      atom.packages.activatePackage("language-frege")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.frege")

  it "parses the grammar", ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe "source.frege"

  describe "chars", ->
    it 'tokenizes general chars', ->
      chars = ['a', '0', '9', 'z', '@', '0', '"']

      for scope, char of chars
        {tokens} = grammar.tokenizeLine("'" + char + "'")
        expect(tokens).toEqual [
          {value:"'", scopes: ["source.frege", 'string.quoted.single.frege', "punctuation.definition.string.begin.frege"]}
          {value: char, scopes: ["source.frege", 'string.quoted.single.frege']}
          {value:"'", scopes: ["source.frege", 'string.quoted.single.frege', "punctuation.definition.string.end.frege"]}
        ]

    it 'tokenizes escape chars', ->
      escapeChars = ['\\t', '\\n', '\\\'']
      for scope, char of escapeChars
        {tokens} = grammar.tokenizeLine("'" + char + "'")
        expect(tokens).toEqual [
          {value:"'", scopes: ["source.frege", 'string.quoted.single.frege', "punctuation.definition.string.begin.frege"]}
          {value: char, scopes: ["source.frege", 'string.quoted.single.frege', 'constant.character.escape.frege']}
          {value:"'", scopes: ["source.frege", 'string.quoted.single.frege', "punctuation.definition.string.end.frege"]}
        ]
    it 'tokenizes control chars', ->
      escapeChars = [64..95].map (x) -> "\\^#{String.fromCharCode(x)}"
      for scope, char of escapeChars
        g = grammarExpect grammar, "'#{char}'"
        g.toHaveTokens [["'", char, "'"]]
        g.toHaveScopes [['source.frege', "string.quoted.single.frege"]]
        g.tokenToHaveScopes [[ [1, ["constant.character.escape.control.frege"]] ]]

  describe "strings", ->
    it "tokenizes single-line strings", ->
      {tokens} = grammar.tokenizeLine '"abcde\\n\\EOT\\EOL"'
      expect(tokens).toEqual  [
        { value : '"', scopes : [ 'source.frege', 'string.quoted.double.frege', 'punctuation.definition.string.begin.frege' ] }
        { value : 'abcde', scopes : [ 'source.frege', 'string.quoted.double.frege' ] }
        { value : '\\n', scopes : [ 'source.frege', 'string.quoted.double.frege', 'constant.character.escape.frege' ] }
        { value : '\\EOT', scopes : [ 'source.frege', 'string.quoted.double.frege', 'constant.character.escape.frege' ] }
        { value : '\\EOL', scopes : [ 'source.frege', 'string.quoted.double.frege' ] }
        { value : '"', scopes : [ 'source.frege', 'string.quoted.double.frege', 'punctuation.definition.string.end.frege' ] }
      ]
    it "Regression test for 96", ->
      g = grammarExpect grammar, '"^\\\\ "'
      g.toHaveTokens [["\"", "^", "\\\\", " ", "\""]]
      g.toHaveScopes [['source.frege', "string.quoted.double.frege"]]
      g.tokenToHaveScopes [[ [2, ["constant.character.escape.frege"]] ]]
    it "Supports type-level string literals", ->
      g = grammarExpect grammar, ':: "type-level string"'
      g.toHaveTokens [["::", " ", "\"", "type-level string", "\""]]
      g.toHaveScopes [['source.frege']]
      g.tokenToHaveScopes [[ [3, ["string.quoted.double.frege"]] ]]


  describe "backtick function call", ->
    it "finds backtick function names", ->
      {tokens} = grammar.tokenizeLine("\`func\`")
      expect(tokens[0]).toEqual value: '`', scopes: ['source.frege', 'keyword.operator.function.infix.frege', 'punctuation.definition.entity.frege']
      expect(tokens[1]).toEqual value: 'func', scopes: ['source.frege', 'keyword.operator.function.infix.frege']
      expect(tokens[2]).toEqual value: '`', scopes: ['source.frege', 'keyword.operator.function.infix.frege', 'punctuation.definition.entity.frege']

  describe "keywords", ->
    controlKeywords = ['do', 'if', 'then', 'else', 'case', 'of', 'let', 'in', 'default', 'mdo', 'rec', 'proc']

    for scope, keyword of controlKeywords
      it "tokenizes #{keyword} as a keyword", ->
        {tokens} = grammar.tokenizeLine(keyword)
        expect(tokens[0]).toEqual value: keyword, scopes: ['source.frege', 'keyword.control.frege']

  describe "operators", ->
    it "tokenizes the / arithmetic operator when separated by newlines", ->
      lines = grammar.tokenizeLines """
        1
        / 2
      """
      expect(lines).toEqual  [
          [
            { value : '1', scopes : [ 'source.frege', 'constant.numeric.decimal.frege' ] }
          ],
          [
            { value : '/', scopes : [ 'source.frege', 'keyword.operator.frege' ] }
            { value : ' ', scopes : [ 'source.frege' ] }
            { value : '2', scopes : [ 'source.frege', 'constant.numeric.decimal.frege' ] }
          ]
        ]

  describe "ids", ->
    it 'handles type_ids', ->
      typeIds = ['Char', 'Data', 'List', 'Int', 'Integral', 'Float', 'Date']

      for scope, id of typeIds
        {tokens} = grammar.tokenizeLine(id)
        expect(tokens[0]).toEqual value: id, scopes: ['source.frege', 'entity.name.tag.frege']

  describe "identifiers", ->
    it 'doesnt highlight partial prelude names', ->
      g = grammarExpect(grammar, "top'n'tail")
      g.toHaveScopes [['source.frege', 'identifier.frege']]
      g.toHaveTokenScopes [
        [ "top'n'tail" : [ 'identifier.frege' ]]
      ]

  describe ':: declarations', ->
    it 'parses newline declarations', ->
      g = grammarExpect(grammar, 'function :: Type -> OtherType')
      g.toHaveScopes [['source.frege', 'meta.function.type-declaration.frege']]
      g.toHaveTokenScopes [
        [ 'function' : [ 'entity.name.function.frege' ]
        , ' '
        , '::' : [ 'keyword.other.double-colon.frege' ]
        , ' '
        , 'Type' : [ 'meta.type-signature.frege', 'entity.name.type.frege' ]
        , ' '
        , '->' : [ 'meta.type-signature.frege', 'keyword.other.arrow.frege' ]
        , ' '
        , 'OtherType' : [ 'meta.type-signature.frege', 'entity.name.type.frege' ]
        ]]

    it 'parses in-line parenthesised declarations', ->
      g = grammarExpect(grammar, 'main = (putStrLn :: String -> IO ()) ("Hello World" :: String)')
      g.toHaveScopes [['source.frege']]
      g.toHaveTokenScopes [
        [ "main" : ['identifier.frege']
        , " "
        , "=" : ['keyword.operator.frege']
        , " "
        , "("
        , "putStrLn" : ['support.function.prelude.putStrLn.frege' ]
        , " "
        , "::" : ['keyword.other.double-colon.frege']
        , " "
        , "String" : ['entity.name.type.frege', 'support.class.prelude.String.frege']
        , " "
        , "->" : ['keyword.other.arrow.frege']
        , " "
        , "IO" : ['entity.name.type.frege', 'support.class.prelude.IO.frege']
        , " "
        , "()" : ['constant.language.unit.frege' ]
        , ")"
        , " "
        , "("
        , "\""
        , "Hello World" : ['string.quoted.double.frege']
        , "\""
        , " "
        , "::" : ['keyword.other.double-colon.frege']
        , " "
        , "String" : ['entity.name.type.frege', 'support.class.prelude.String.frege']
        , ")"
        ]
      ]

    it 'doesnt get confused by quoted ::', ->
      g = grammarExpect(grammar, '("x :: String -> IO ()" ++ var)')
      g.toHaveScopes [['source.frege']]
      g.toHaveTokenScopes [
        [ "("
        , "\""
        , "x :: String -> IO ()" : ['string.quoted.double.frege']
        , "\""
        , " "
        , "++" : ['keyword.operator.frege']
        , " "
        , "var" : ['identifier.frege']
        , ")"
        ]
      ]

    it 'parses in-line non-parenthesised declarations', ->
      g = grammarExpect(grammar, 'main = putStrLn "Hello World" :: IO ()')
      g.toHaveScopes [['source.frege']]
      g.toHaveTokenScopes [
        [ 'main' : [ 'identifier.frege' ]
        , ' '
        , '=' : [ 'keyword.operator.frege' ]
        , ' '
        , 'putStrLn' : [ 'identifier.frege', 'support.function.prelude.putStrLn.frege' ]
        , ' '
        , {'"' : [ 'string.quoted.double.frege', 'punctuation.definition.string.begin.frege' ]}
        , {'Hello World' : [ 'string.quoted.double.frege' ]}
        , {'"' : [ 'string.quoted.double.frege', 'punctuation.definition.string.end.frege' ]}
        , ' '
        , '::' : [ 'keyword.other.double-colon.frege' ]
        , ' '
        , 'IO' : [ 'meta.type-signature.frege', 'entity.name.type.frege', 'support.class.prelude.IO.frege' ]
        , ' '
        , '()' : [ 'meta.type-signature.frege', 'constant.language.unit.frege' ]
        ]
      ]

  describe 'regression test for 65', ->
    it 'works with space', ->
      g = grammarExpect(grammar, 'data Foo = Foo {bar :: Bar}')
      g.toHaveScopes [['source.frege', 'meta.declaration.type.data.frege']]
      g.toHaveTokenScopes [
        [ 'data' : [ 'keyword.other.data.frege' ]
        , ' '
        , 'Foo' : [ 'meta.type-signature.frege', 'entity.name.type.frege' ]
        , ' ' : [ 'meta.type-signature.frege' ]
        , '=' : [ 'keyword.operator.assignment.frege' ]
        , ' '
        , 'Foo' : [ 'entity.name.tag.frege' ]
        , ' '
        , '{' : [ 'meta.declaration.type.data.record.block.frege', 'keyword.operator.record.begin.frege' ]
        , 'bar' : [ 'meta.record-field.type-declaration.frege', 'entity.other.attribute-name.frege' ]
        , ' '
        , '::' : [ 'keyword.other.double-colon.frege' ]
        , ' ' : [ 'meta.type-signature.frege' ]
        , 'Bar' : [ 'meta.type-signature.frege', 'entity.name.type.frege' ]
        , '}' : [ 'meta.declaration.type.data.record.block.frege', 'keyword.operator.record.end.frege' ]
        ]
      ]

    it 'works without space', ->
      data = 'data Foo = Foo{bar :: Bar}'
      {tokens} = grammar.tokenizeLine(data)
      expect(tokens).toEqual [
        { value : 'data', scopes : [ 'source.frege', 'meta.declaration.type.data.frege', 'keyword.other.data.frege' ] }
        { value : ' ', scopes : [ 'source.frege', 'meta.declaration.type.data.frege' ] }
        { value : 'Foo', scopes : [ 'source.frege', 'meta.declaration.type.data.frege', 'meta.type-signature.frege', 'entity.name.type.frege' ] }
        { value : ' ', scopes : [ 'source.frege', 'meta.declaration.type.data.frege', 'meta.type-signature.frege' ] }
        { value : '=', scopes : [ 'source.frege', 'meta.declaration.type.data.frege', 'keyword.operator.assignment.frege' ] }
        { value : ' ', scopes : [ 'source.frege', 'meta.declaration.type.data.frege' ] }
        { value : 'Foo', scopes : [ 'source.frege', 'meta.declaration.type.data.frege', 'entity.name.tag.frege' ] }
        { value : '{', scopes : [ 'source.frege', 'meta.declaration.type.data.frege', 'meta.declaration.type.data.record.block.frege', 'keyword.operator.record.begin.frege' ] }
        { value : 'bar', scopes : [ 'source.frege', 'meta.declaration.type.data.frege', 'meta.declaration.type.data.record.block.frege', 'meta.record-field.type-declaration.frege', 'entity.other.attribute-name.frege' ] }
        { value : ' ', scopes : [ 'source.frege', 'meta.declaration.type.data.frege', 'meta.declaration.type.data.record.block.frege', 'meta.record-field.type-declaration.frege' ] }
        { value : '::', scopes : [ 'source.frege', 'meta.declaration.type.data.frege', 'meta.declaration.type.data.record.block.frege', 'meta.record-field.type-declaration.frege', 'keyword.other.double-colon.frege' ] }
        { value : ' ', scopes : [ 'source.frege', 'meta.declaration.type.data.frege', 'meta.declaration.type.data.record.block.frege', 'meta.record-field.type-declaration.frege', 'meta.type-signature.frege' ] }
        { value : 'Bar', scopes : [ 'source.frege', 'meta.declaration.type.data.frege', 'meta.declaration.type.data.record.block.frege', 'meta.record-field.type-declaration.frege', 'meta.type-signature.frege', 'entity.name.type.frege' ] }
        { value : '}', scopes : [ 'source.frege', 'meta.declaration.type.data.frege', 'meta.declaration.type.data.record.block.frege', 'keyword.operator.record.end.frege' ] }
      ]

  it "properly highlights data declarations", ->
    data = 'data Foo = Foo Bar'
    {tokens} = grammar.tokenizeLine(data)
    # console.log JSON.stringify(tokens, undefined, 2)
    expect(tokens).toEqual [
        {
          "value": "data",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "keyword.other.data.frege"
          ]
        }
        {
          "value": " ",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege"
          ]
        },
        {
          "value": "Foo",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.type-signature.frege",
            "entity.name.type.frege"
          ]
        },
        {
          "value": " ",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.type-signature.frege"
          ]
        },
        {
          "value": "=",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "keyword.operator.assignment.frege"
          ]
        },
        {
          "value": " ",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege"
          ]
        },
        {
          "value": "Foo",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "entity.name.tag.frege"
          ]
        },
        {
          "value": " ",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege"
          ]
        },
        {
          "value": "Bar",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.type-signature.frege"
            "entity.name.type.frege"
          ]
        }
      ]
  describe "regression test for 71", ->
    it "<-", ->
      data = "x :: String <- undefined"
      {tokens} = grammar.tokenizeLine(data)
      expect(tokens).toEqual [
        { value : 'x', scopes : [ 'source.frege', 'identifier.frege' ] }
        { value : ' ', scopes : [ 'source.frege' ] }
        { value : '::', scopes : [ 'source.frege', 'keyword.other.double-colon.frege' ] }
        { value : ' ', scopes : [ 'source.frege', 'meta.type-signature.frege' ] }
        { value : 'String', scopes : [ 'source.frege', 'meta.type-signature.frege', 'entity.name.type.frege', 'support.class.prelude.String.frege' ] }
        { value : ' ', scopes : [ 'source.frege', 'meta.type-signature.frege' ] }
        { value : '<-', scopes : [ 'source.frege', 'keyword.operator.frege' ] }
        { value : ' ', scopes : [ 'source.frege' ] }
        { value : 'undefined', scopes : [ 'source.frege', 'identifier.frege', 'support.function.prelude.undefined.frege' ] }
        ]
    it "=", ->
      data = "x :: String = undefined"
      {tokens} = grammar.tokenizeLine(data)
      # console.log JSON.stringify(tokens, undefined, 2)
      expect(tokens).toEqual [
        { value : 'x', scopes : [ 'source.frege', 'identifier.frege' ] }
        { value : ' ', scopes : [ 'source.frege' ] }
        { value : '::', scopes : [ 'source.frege', 'keyword.other.double-colon.frege' ] }
        { value : ' ', scopes : [ 'source.frege', 'meta.type-signature.frege' ] }
        { value : 'String', scopes : [ 'source.frege', 'meta.type-signature.frege', 'entity.name.type.frege', 'support.class.prelude.String.frege' ] }
        { value : ' ', scopes : [ 'source.frege', 'meta.type-signature.frege' ] }
        { value : '=', scopes : [ 'source.frege', 'keyword.operator.assignment.frege' ] }
        { value : ' ', scopes : [ 'source.frege' ] }
        { value : 'undefined', scopes : [ 'source.frege', 'identifier.frege', 'support.function.prelude.undefined.frege' ] }
        ]
    it "still works for type-op signatures", ->
      data = "smth :: a <-- b"
      {tokens} = grammar.tokenizeLine(data)
      expect(tokens).toEqual [
        { value : 'smth', scopes : [ 'source.frege', 'meta.function.type-declaration.frege', 'entity.name.function.frege' ] }
        { value : ' ', scopes : [ 'source.frege', 'meta.function.type-declaration.frege' ] }
        { value : '::', scopes : [ 'source.frege', 'meta.function.type-declaration.frege', 'keyword.other.double-colon.frege' ] }
        { value : ' ', scopes : [ 'source.frege', 'meta.function.type-declaration.frege', 'meta.type-signature.frege' ] }
        { value : 'a', scopes : [ 'source.frege', 'meta.function.type-declaration.frege', 'meta.type-signature.frege', 'variable.other.generic-type.frege' ] }
        { value : ' ', scopes : [ 'source.frege', 'meta.function.type-declaration.frege', 'meta.type-signature.frege' ] }
        { value : '<--', scopes : [ 'source.frege', 'meta.function.type-declaration.frege', 'meta.type-signature.frege', 'keyword.operator.frege' ] }
        { value : ' ', scopes : [ 'source.frege', 'meta.function.type-declaration.frege', 'meta.type-signature.frege' ] }
        { value : 'b', scopes : [ 'source.frege', 'meta.function.type-declaration.frege', 'meta.type-signature.frege', 'variable.other.generic-type.frege' ] }
        ]

  describe "type operators", ->
    it "parses type operators", ->
      data = ":: a *** b"
      {tokens} = grammar.tokenizeLine(data)
      expect(tokens[4].value).toEqual '***'
      expect(tokens[4].scopes).toContain 'keyword.operator.frege'
    it "doesn't confuse arrows and type operators", ->
      g = grammarExpect(grammar, ":: a --> b")
      g.toHaveTokens [['::', ' ', 'a', ' ', '-->', ' ', 'b']]
      g.toHaveScopes [['source.frege']]
      g.tokenToHaveScopes [[[4, ['keyword.operator.frege', 'meta.type-signature.frege']]]]

      g = grammarExpect(grammar, ":: a ->- b")
      g.toHaveTokens [['::', ' ', 'a', ' ', '->-', ' ', 'b']]
      g.toHaveScopes [['source.frege']]
      g.tokenToHaveScopes [[[4, ['keyword.operator.frege', 'meta.type-signature.frege']]]]

      g = grammarExpect(grammar, ":: a ==> b")
      g.toHaveTokens [['::', ' ', 'a', ' ', '==>', ' ', 'b']]
      g.toHaveScopes [['source.frege']]
      g.tokenToHaveScopes [[[4, ['keyword.operator.frege', 'meta.type-signature.frege']]]]

      g = grammarExpect(grammar, ":: a =>= b")
      g.toHaveTokens [['::', ' ', 'a', ' ', '=>=', ' ', 'b']]
      g.toHaveScopes [['source.frege']]
      g.tokenToHaveScopes [[[4, ['keyword.operator.frege', 'meta.type-signature.frege']]]]

  describe "comments", ->
    it "parses block comments", ->
      g = grammarExpect grammar, "{- this is a block comment -}"
      g.toHaveTokens [['{-', ' this is a block comment ', '-}']]
      g.toHaveScopes [['source.frege', 'comment.block.frege']]
      g.tokenToHaveScopes [[[0, ['punctuation.definition.comment.block.start.frege']],
                            [2, ['punctuation.definition.comment.block.end.frege']]]]

    it "parses nested block comments", ->
      g = grammarExpect grammar, "{- this is a {- nested -} block comment -}"
      g.toHaveTokens [['{-', ' this is a ', '{-', ' nested ', '-}', ' block comment ', '-}']]
      g.toHaveScopes [['source.frege', 'comment.block.frege']]
      g.tokenToHaveScopes [[[0, ['punctuation.definition.comment.block.start.frege']]
                            [2, ['punctuation.definition.comment.block.start.frege']]
                            [4, ['punctuation.definition.comment.block.end.frege']]
                            [6, ['punctuation.definition.comment.block.end.frege']]]]

    it "parses pragmas as comments in block comments", ->
      g = grammarExpect grammar, '{- this is a {-# nested #-} block comment -}'
      g.toHaveTokens [['{-', ' this is a ', '{-', '# nested #', '-}', ' block comment ', '-}']]
      g.toHaveScopes [['source.frege', 'comment.block.frege']]
      g.tokenToHaveScopes [[[0, ['punctuation.definition.comment.block.start.frege']]
                            [2, ['punctuation.definition.comment.block.start.frege']]
                            [4, ['punctuation.definition.comment.block.end.frege']]
                            [6, ['punctuation.definition.comment.block.end.frege']]]]
  describe "instance", ->
    it "recognizes instances", ->
      g = grammarExpect grammar, 'instance Class where'
      g.toHaveTokens [['instance', ' ', 'Class', ' ', 'where']]
      g.toHaveScopes [['source.frege', 'meta.declaration.instance.frege']]
      g.tokenToHaveScopes [[[1, ['meta.type-signature.frege']]
                            [2, ['meta.type-signature.frege', 'entity.name.type.frege']]
                            [3, ['meta.type-signature.frege']]
                            [4, ['keyword.other.frege']]
                            ]]
    it "recognizes instance pragmas", ->
      for p in [ 'OVERLAPS', 'OVERLAPPING', 'OVERLAPPABLE', 'INCOHERENT' ]
        g = grammarExpect grammar, "instance {-# #{p} #-} Class where"
        g.toHaveTokens [['instance', ' ', '{-#', ' ', p, ' ', '#-}', ' ', 'Class', ' ', 'where']]
        g.toHaveScopes [['source.frege', 'meta.declaration.instance.frege']]
        g.tokenToHaveScopes [[[2, ['meta.preprocessor.frege']]
                              [3, ['meta.preprocessor.frege']]
                              [4, ['meta.preprocessor.frege', 'keyword.other.preprocessor.frege']]
                              [5, ['meta.preprocessor.frege']]
                              [6, ['meta.preprocessor.frege']]
                              ]]
  describe "module", ->
    it "understands module declarations", ->
      g = grammarExpect grammar, 'module Module where'
      g.toHaveTokens [['module', ' ', 'Module', ' ', 'where']]
      g.toHaveScopes [['source.frege', 'meta.declaration.module.frege']]
      g.tokenToHaveScopes [[[2, ['support.other.module.frege']]]]
    it "understands module declarations with exports", ->
      g = grammarExpect grammar, 'module Module (export1, export2) where'
      g.toHaveTokens [['module', ' ', 'Module', ' ', '(', 'export1', ',', ' ', 'export2', ')', ' ', 'where']]
      g.toHaveScopes [['source.frege', 'meta.declaration.module.frege']]
      g.tokenToHaveScopes [[[2, ['support.other.module.frege']]
                            [5, ['meta.declaration.exports.frege', 'entity.name.function.frege']]
                            [8, ['meta.declaration.exports.frege', 'entity.name.function.frege']]
                            ]]
    it "understands module declarations with operator exports", ->
      g = grammarExpect grammar, 'module Module ((<|>), export2) where'
      g.toHaveTokens [['module', ' ', 'Module', ' ', '(', '(<|>)', ',', ' ', 'export2', ')', ' ', 'where']]
      g.toHaveScopes [['source.frege', 'meta.declaration.module.frege']]
      g.tokenToHaveScopes [[[2, ['support.other.module.frege']]
                            [5, ['meta.declaration.exports.frege', 'entity.name.function.infix.frege']]
                            [8, ['meta.declaration.exports.frege', 'entity.name.function.frege']]
                            ]]
    it "understands module declarations with export lists", ->
      g = grammarExpect grammar, 'module Module (export1 (..), export2 (Something)) where'
      g.toHaveTokens [['module', ' ', 'Module', ' ', '(', 'export1', ' (' , '..', ')',
                       ',', ' ', 'export2', ' (', 'Something', ')', ')', ' ', 'where']]
      g.toHaveScopes [['source.frege', 'meta.declaration.module.frege']]
      g.tokenToHaveScopes [[[2, ['support.other.module.frege']]
                            [5, ['meta.declaration.exports.frege', 'entity.name.function.frege']]
                            [7, ['meta.declaration.exports.frege', 'meta.other.constructor-list.frege',
                                 'keyword.operator.wildcard.frege']]
                            [11, ['meta.declaration.exports.frege', 'entity.name.function.frege']]
                            [13, ['meta.declaration.exports.frege', 'meta.other.constructor-list.frege',
                                  'entity.name.tag.frege']]
                            ]]
  describe "regression test for comments after module name in imports", ->
    it "parses comments after module names", ->
      g = grammarExpect grammar, 'import Module -- comment'
      g.toHaveTokens [['import', ' ', 'Module', ' ', '--', ' comment', '']]
      g.toHaveScopes [['source.frege', 'meta.import.frege']]
      g.tokenToHaveScopes [[[2, ['support.other.module.frege']]
                            [4, ['comment.line.double-dash.frege', 'punctuation.definition.comment.frege']]
                            [5, ['comment.line.double-dash.frege']]
                            [6, ['comment.line.double-dash.frege']]
                            ]]
