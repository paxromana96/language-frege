{include, makeGrammar} = require './syntax-tools'
_ = require 'underscore-plus'

makeGrammar "grammars/frege.cson",
  name: 'Frege'
  fileTypes: [ 'hs', 'cpphs' ]
  firstLineMatch: '^\\#\\!.*\\brunfrege\\b'
  scopeName: 'source.frege'

  macros: include 'macros'
  repository: include 'repository'
  patterns: include 'frege-patterns'

makeGrammar "grammars/frege autocompletion hint.cson",
  # name: 'Frege Autocompletion Hint'
  fileTypes: []
  scopeName: 'hint.frege'

  macros: include 'macros'
  patterns: [
      {include: '#function_type_declaration'}
      {include: '#ctor_type_declaration'}
  ]
  repository: include 'repository'

makeGrammar "grammars/frege type hint.cson",
  # name: 'Frege Type Hint'
  fileTypes: []
  scopeName: 'hint.type.frege'

  macros: include 'macros'
  patterns: [
      include: '#type_signature'
  ]
  repository: include 'repository'

makeGrammar "grammars/frege message hint.cson",
  # name: 'Frege Message Hint'
  fileTypes: []
  scopeName: 'hint.message.frege'

  macros: include 'macros'
  patterns: [
      match: /^[^:]*:(.+)$/
      captures:
        1:
          patterns: [
            include: 'source.frege'
          ]
    ,
      begin: /^[^:]*:$/
      end: /^(?=\S)/
      patterns: [
        include: 'source.frege'
      ]
    ,
      begin: /‘/
      end: /’/
      patterns: [
        include: 'source.frege'
      ]
  ]
  repository: include 'repository'
