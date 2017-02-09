{grammarExpect, customMatchers} = require './util'

describe "Language-Frege", ->
  grammar = null

  beforeEach ->
    @addMatchers(customMatchers)
    waitsForPromise ->
      atom.packages.activatePackage("language-frege")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.frege")

  describe "identifiers", ->
    it 'tokenizes identifiers', ->
      {tokens} = grammar.tokenizeLine('aSimpleIdentifier')
      expect(tokens).toEqual [
        { value : 'aSimpleIdentifier', scopes : [ 'source.frege', 'identifier.frege' ] }
      ]
    it 'tokenizes identifiers with module names', ->
      {tokens} = grammar.tokenizeLine('Some.Module.identifier')
      expect(tokens).toEqual [
        { value : 'Some.Module.', scopes : [ 'source.frege', 'identifier.frege', 'support.other.module.frege' ] }
        { value : 'identifier', scopes : [ 'source.frege', 'identifier.frege' ] }
      ]
    it 'tokenizes type constructors', ->
      {tokens} = grammar.tokenizeLine('SomeCtor')
      expect(tokens).toEqual [
        { value : 'SomeCtor', scopes : [ 'source.frege', 'entity.name.tag.frege' ] }
      ]
    it 'tokenizes type constructors with module names', ->
      {tokens} = grammar.tokenizeLine('Some.Module.SomeCtor')
      expect(tokens).toEqual [
        { value : 'Some.Module.', scopes : [ 'source.frege', 'entity.name.tag.frege', 'support.other.module.frege' ] }
        { value : 'SomeCtor', scopes : [ 'source.frege', 'entity.name.tag.frege' ] }
      ]
    it 'tokenizes identifiers with numeric parts', ->
      {tokens} = grammar.tokenizeLine('numer123ident')
      expect(tokens).toEqual [
        { value : 'numer123ident', scopes : [ 'source.frege', 'identifier.frege' ] }
      ]
      {tokens} = grammar.tokenizeLine('numerident123')
      expect(tokens).toEqual [
        { value : 'numerident123', scopes : [ 'source.frege', 'identifier.frege' ] }
      ]
      {tokens} = grammar.tokenizeLine('123numerident')
      expect(tokens).toEqual [
        { value : '123', scopes : [ 'source.frege', 'constant.numeric.decimal.frege' ] }
        { value : 'numerident', scopes : [ 'source.frege', 'identifier.frege' ] }
      ]
    it 'doesnt confuse identifiers starting with type (issue 84)', ->
      g = grammarExpect grammar, 'typeIdentifier'
      g.toHaveTokens [['typeIdentifier']]
      g.toHaveScopes [['source.frege', 'identifier.frege']]
    it 'doesnt confuse identifiers starting with data', ->
      g = grammarExpect grammar, 'dataIdentifier'
      g.toHaveTokens [['dataIdentifier']]
      g.toHaveScopes [['source.frege', 'identifier.frege']]
    it 'doesnt confuse identifiers starting with newtype', ->
      g = grammarExpect grammar, 'newtypeIdentifier'
      g.toHaveTokens [['newtypeIdentifier']]
      g.toHaveScopes [['source.frege', 'identifier.frege']]
