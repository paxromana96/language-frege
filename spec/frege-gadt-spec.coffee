describe 'GADT', ->
  grammar = null

  zip = () ->
    lengthArray = (arr.length for arr in arguments)
    length = Math.max(lengthArray...)
    for i in [0...length]
      arr[i] for arr in arguments

  check = (line, exp) ->
    for t,i in zip(line,exp)
      t[0] ?= {}
      t[1] ?= {}
      t[0].index=i
      t[1].index=i
      expect(t[0]).toEqual(t[1])

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-frege")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.frege")

  it 'understands GADT syntax', ->
    string = """
        data Term a where
          Lit :: Int -> Term Int
        """
    lines = grammar.tokenizeLines(string)
    exp = [[
          {
            value:'data',
            scopes:[
              'source.frege',
              'meta.declaration.type.data.frege',
              'keyword.other.data.frege'
            ]
          },
          {
            value:' ',
            scopes:[
              'source.frege',
              'meta.declaration.type.data.frege'
            ]
          },
          {
            value:'Term',
            scopes:[
              'source.frege',
              'meta.declaration.type.data.frege',
              'meta.type-signature.frege',
              'entity.name.type.frege'
            ]
          },
          {
            value:' ',
            scopes:[
              'source.frege',
              'meta.declaration.type.data.frege',
              'meta.type-signature.frege'
            ]
          },
          {
            value:'a',
            scopes:[
              'source.frege',
              'meta.declaration.type.data.frege',
              'meta.type-signature.frege',
              'variable.other.generic-type.frege'
            ]
          },
          {
            value:' ',
            scopes:[
              'source.frege'
              'meta.declaration.type.data.frege'
              'meta.type-signature.frege'
            ]
          },
          {
            value:'where',
            scopes:[
              'source.frege',
              'meta.declaration.type.data.frege',
              'keyword.other.frege'
            ]
          }
        ],
        [
          {
            value:'  ',
            scopes:[
              'source.frege',
              'meta.declaration.type.data.frege',
              'meta.ctor.type-declaration.frege'
            ]
          },
          {
            value:'Lit',
            scopes:[
              'source.frege',
              'meta.declaration.type.data.frege',
              'meta.ctor.type-declaration.frege',
              'entity.name.tag.frege'
            ]
          },
          {
            value:' ',
            scopes:[
              'source.frege',
              'meta.declaration.type.data.frege',
              'meta.ctor.type-declaration.frege'
            ]
          },
          {
            value:'::',
            scopes:[
              'source.frege',
              'meta.declaration.type.data.frege',
              'meta.ctor.type-declaration.frege',
              'keyword.other.double-colon.frege'
            ]
          },
          {
            value:' ',
            scopes:[
              'source.frege',
              'meta.declaration.type.data.frege',
              'meta.ctor.type-declaration.frege',
              'meta.type-signature.frege'
            ]
          },
          {
            value:'Int',
            scopes:[
              'source.frege',
              'meta.declaration.type.data.frege',
              'meta.ctor.type-declaration.frege',
              'meta.type-signature.frege',
              'entity.name.type.frege',
              'support.class.prelude.Int.frege'
            ]
          },
          {
            value:' ',
            scopes:[
              'source.frege',
              'meta.declaration.type.data.frege',
              'meta.ctor.type-declaration.frege',
              'meta.type-signature.frege'
            ]
          },
          {
            value:'->',
            scopes:[
              'source.frege',
              'meta.declaration.type.data.frege',
              'meta.ctor.type-declaration.frege',
              'meta.type-signature.frege',
              'keyword.other.arrow.frege'
            ]
          },
          {
            value:' ',
            scopes:[
              'source.frege',
              'meta.declaration.type.data.frege',
              'meta.ctor.type-declaration.frege',
              'meta.type-signature.frege'
            ]
          },
          {
            value:'Term',
            scopes:[
              'source.frege',
              'meta.declaration.type.data.frege',
              'meta.ctor.type-declaration.frege',
              'meta.type-signature.frege',
              'entity.name.type.frege'
            ]
          },
          {
            value:' ',
            scopes:[
              'source.frege',
              'meta.declaration.type.data.frege',
              'meta.ctor.type-declaration.frege',
              'meta.type-signature.frege'
            ]
          },
          {
            value:'Int',
            scopes:[
              'source.frege',
              'meta.declaration.type.data.frege',
              'meta.ctor.type-declaration.frege',
              'meta.type-signature.frege',
              'entity.name.type.frege',
              'support.class.prelude.Int.frege'
            ]
          }
        ]]
    for l in zip(lines, exp)
      check l[0], l[1]
