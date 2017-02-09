describe 'Record', ->
  grammar = null

  zip = ->
    lengthArray = (arr.length for arr in arguments)
    length = Math.max(lengthArray...)
    for i in [0...length]
      arr[i] for arr in arguments

  check = (line, exp) ->
    for t, i in zip(line, exp)
      t[0] ?= {}
      t[1] ?= {}
      t[0].index = i
      t[1].index = i
      expect(t[0]).toEqual(t[1])

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-frege")

    runs ->
      grammar = atom.grammars.grammarForScopeName("source.frege")

  it 'understands record syntax', ->
    string = """
      data Car = Car {
          company :: String,
          model :: String,
          year :: Int
        } deriving (Show)
      """
    lines = grammar.tokenizeLines(string)
    # console.log JSON.stringify(lines, undefined, 2)
    exp = [
      [
        {
          "value": "data",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "keyword.other.data.frege"
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
          "value": "Car",
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
            "source.frege"
            "meta.declaration.type.data.frege"
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
          "value": "Car",
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
          "value": "{",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.declaration.type.data.record.block.frege",
            "keyword.operator.record.begin.frege"
          ]
        }
      ],
      [
        {
          "value": "    ",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.declaration.type.data.record.block.frege"
          ]
        },
        {
          "value": "company",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.declaration.type.data.record.block.frege",
            "meta.record-field.type-declaration.frege",
            "entity.other.attribute-name.frege"
          ]
        },
        {
          "value": " ",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.declaration.type.data.record.block.frege",
            "meta.record-field.type-declaration.frege"
          ]
        },
        {
          "value": "::",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.declaration.type.data.record.block.frege",
            "meta.record-field.type-declaration.frege",
            "keyword.other.double-colon.frege"
          ]
        },
        {
          "value": " ",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.declaration.type.data.record.block.frege",
            "meta.record-field.type-declaration.frege",
            "meta.type-signature.frege"
          ]
        },
        {
          "value": "String",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.declaration.type.data.record.block.frege",
            "meta.record-field.type-declaration.frege",
            "meta.type-signature.frege",
            'entity.name.type.frege',
            "support.class.prelude.String.frege"
          ]
        },
        {
          "value": ",",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.declaration.type.data.record.block.frege",
            "meta.record-field.type-declaration.frege",
            "meta.type-signature.frege"
          ]
        }
      ],
      [
        {
          "value": "    ",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.declaration.type.data.record.block.frege",
            "meta.record-field.type-declaration.frege",
            "meta.type-signature.frege"
          ]
        },
        {
          "value": "model",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.declaration.type.data.record.block.frege",
            "meta.record-field.type-declaration.frege",
            "entity.other.attribute-name.frege"
          ]
        },
        {
          "value": " ",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.declaration.type.data.record.block.frege",
            "meta.record-field.type-declaration.frege"
          ]
        },
        {
          "value": "::",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.declaration.type.data.record.block.frege",
            "meta.record-field.type-declaration.frege",
            "keyword.other.double-colon.frege"
          ]
        },
        {
          "value": " ",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.declaration.type.data.record.block.frege",
            "meta.record-field.type-declaration.frege",
            "meta.type-signature.frege"
          ]
        },
        {
          "value": "String",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.declaration.type.data.record.block.frege",
            "meta.record-field.type-declaration.frege",
            "meta.type-signature.frege",
            'entity.name.type.frege',
            "support.class.prelude.String.frege"
          ]
        },
        {
          "value": ",",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.declaration.type.data.record.block.frege",
            "meta.record-field.type-declaration.frege",
            "meta.type-signature.frege"
          ]
        }
      ],
      [
        {
          "value": "    ",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.declaration.type.data.record.block.frege",
            "meta.record-field.type-declaration.frege",
            "meta.type-signature.frege"
          ]
        },
        {
          "value": "year",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.declaration.type.data.record.block.frege",
            "meta.record-field.type-declaration.frege",
            "entity.other.attribute-name.frege"
          ]
        },
        {
          "value": " ",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.declaration.type.data.record.block.frege",
            "meta.record-field.type-declaration.frege"
          ]
        },
        {
          "value": "::",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.declaration.type.data.record.block.frege",
            "meta.record-field.type-declaration.frege",
            "keyword.other.double-colon.frege"
          ]
        },
        {
          "value": " ",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.declaration.type.data.record.block.frege",
            "meta.record-field.type-declaration.frege",
            "meta.type-signature.frege"
          ]
        },
        {
          "value": "Int",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.declaration.type.data.record.block.frege",
            "meta.record-field.type-declaration.frege",
            "meta.type-signature.frege",
            'entity.name.type.frege',
            "support.class.prelude.Int.frege"
          ]
        }
      ],
      [
        {
          "value": "  ",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.declaration.type.data.record.block.frege",
            "meta.record-field.type-declaration.frege",
            "meta.type-signature.frege"
          ]
        },
        {
          "value": "}",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.declaration.type.data.record.block.frege",
            "keyword.operator.record.end.frege"
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
          "value": "deriving",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.deriving.frege",
            "keyword.other.frege"
          ]
        },
        {
          "value": " (",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.deriving.frege"
          ]
        },
        {
          "value": "Show",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.deriving.frege",
            "entity.other.inherited-class.frege"
          ]
        },
        {
          "value": ")",
          "scopes": [
            "source.frege",
            "meta.declaration.type.data.frege",
            "meta.deriving.frege"
          ]
        }
      ]
    ]
    for l in zip(lines, exp)
      check l[0], l[1]

  it "understands comments in records", ->
    string = """
      data Car = Car {
          company :: String, -- comment
          -- model :: String, -- commented field
          year :: Int -- another comment
        }
      """
    lines = grammar.tokenizeLines(string)
    # console.log JSON.stringify(lines, undefined, 2)
    expect(lines).toEqual [
            [
              {
                "value": "data",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "keyword.other.data.frege"
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
                "value": "Car",
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
                "value": "Car",
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
                "value": "{",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege",
                  "keyword.operator.record.begin.frege"
                ]
              }
            ],
            [
              {
                "value": "    ",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege"
                ]
              },
              {
                "value": "company",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege",
                  "meta.record-field.type-declaration.frege",
                  "entity.other.attribute-name.frege"
                ]
              },
              {
                "value": " ",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege",
                  "meta.record-field.type-declaration.frege"
                ]
              },
              {
                "value": "::",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege",
                  "meta.record-field.type-declaration.frege",
                  "keyword.other.double-colon.frege"
                ]
              },
              {
                "value": " ",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege",
                  "meta.record-field.type-declaration.frege",
                  "meta.type-signature.frege"
                ]
              },
              {
                "value": "String",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege",
                  "meta.record-field.type-declaration.frege",
                  "meta.type-signature.frege",
                  'entity.name.type.frege',
                  "support.class.prelude.String.frege"
                ]
              },
              {
                "value": ", ",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege",
                  "meta.record-field.type-declaration.frege",
                  "meta.type-signature.frege"
                ]
              },
              {
                "value": "--",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege",
                  "meta.record-field.type-declaration.frege",
                  "meta.type-signature.frege",
                  "comment.line.double-dash.frege",
                  "punctuation.definition.comment.frege"
                ]
              },
              {
                "value": " comment",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege",
                  "meta.record-field.type-declaration.frege",
                  "meta.type-signature.frege",
                  "comment.line.double-dash.frege"
                ]
              },
              {
                "value": "",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege",
                  "meta.record-field.type-declaration.frege",
                  "meta.type-signature.frege",
                  "comment.line.double-dash.frege"
                ]
              }
            ],
            [
              {
                "value": "    ",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege",
                  "meta.record-field.type-declaration.frege",
                  "meta.type-signature.frege"
                ]
              },
              {
                "value": "--",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege",
                  "meta.record-field.type-declaration.frege",
                  "meta.type-signature.frege",
                  "comment.line.double-dash.frege",
                  "punctuation.definition.comment.frege"
                ]
              },
              {
                "value": " model :: String, -- commented field",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege",
                  "meta.record-field.type-declaration.frege",
                  "meta.type-signature.frege",
                  "comment.line.double-dash.frege"
                ]
              },
              {
                "value": "",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege",
                  "meta.record-field.type-declaration.frege",
                  "meta.type-signature.frege",
                  "comment.line.double-dash.frege"
                ]
              }
            ],
            [
              {
                "value": "    ",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege",
                  "meta.record-field.type-declaration.frege",
                  "meta.type-signature.frege"
                ]
              },
              {
                "value": "year",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege",
                  "meta.record-field.type-declaration.frege",
                  "entity.other.attribute-name.frege"
                ]
              },
              {
                "value": " ",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege",
                  "meta.record-field.type-declaration.frege"
                ]
              },
              {
                "value": "::",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege",
                  "meta.record-field.type-declaration.frege",
                  "keyword.other.double-colon.frege"
                ]
              },
              {
                "value": " ",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege",
                  "meta.record-field.type-declaration.frege",
                  "meta.type-signature.frege"
                ]
              },
              {
                "value": "Int",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege",
                  "meta.record-field.type-declaration.frege",
                  "meta.type-signature.frege",
                  'entity.name.type.frege',
                  "support.class.prelude.Int.frege"
                ]
              },
              {
                "value": " ",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege",
                  "meta.record-field.type-declaration.frege",
                  "meta.type-signature.frege"
                ]
              },
              {
                "value": "--",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege",
                  "meta.record-field.type-declaration.frege",
                  "meta.type-signature.frege",
                  "comment.line.double-dash.frege",
                  "punctuation.definition.comment.frege"
                ]
              },
              {
                "value": " another comment",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege",
                  "meta.record-field.type-declaration.frege",
                  "meta.type-signature.frege",
                  "comment.line.double-dash.frege"
                ]
              },
              {
                "value": "",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege",
                  "meta.record-field.type-declaration.frege",
                  "meta.type-signature.frege",
                  "comment.line.double-dash.frege"
                ]
              }
            ],
            [
              {
                "value": "  ",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege",
                  "meta.record-field.type-declaration.frege",
                  "meta.type-signature.frege"
                ]
              },
              {
                "value": "}",
                "scopes": [
                  "source.frege",
                  "meta.declaration.type.data.frege",
                  "meta.declaration.type.data.record.block.frege",
                  "keyword.operator.record.end.frege"
                ]
              }
            ]
          ]
  it "understands comments in start of records", ->
    string = """
      data Car = Car {
          -- company :: String
          , model :: String
        }
      """
    lines = grammar.tokenizeLines(string)
    # console.log JSON.stringify(lines, undefined, 2)
    expect(lines).toEqual [
        [
          {
            "value": "data",
            "scopes": [
              "source.frege",
              "meta.declaration.type.data.frege",
              "keyword.other.data.frege"
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
            "value": "Car",
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
            "value": "Car",
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
            "value": "{",
            "scopes": [
              "source.frege",
              "meta.declaration.type.data.frege",
              "meta.declaration.type.data.record.block.frege",
              "keyword.operator.record.begin.frege"
            ]
          }
        ],
        [
          {
            "value": "    ",
            "scopes": [
              "source.frege",
              "meta.declaration.type.data.frege",
              "meta.declaration.type.data.record.block.frege"
            ]
          },
          {
            "value": "--",
            "scopes": [
              "source.frege",
              "meta.declaration.type.data.frege",
              "meta.declaration.type.data.record.block.frege",
              "comment.line.double-dash.frege",
              "punctuation.definition.comment.frege"
            ]
          },
          {
            "value": " company :: String",
            "scopes": [
              "source.frege",
              "meta.declaration.type.data.frege",
              "meta.declaration.type.data.record.block.frege",
              "comment.line.double-dash.frege"
            ]
          },
          {
            "value": "",
            "scopes": [
              "source.frege",
              "meta.declaration.type.data.frege",
              "meta.declaration.type.data.record.block.frege",
              "comment.line.double-dash.frege"
            ]
          }
        ],
        [
          {
            "value": "    ",
            "scopes": [
              "source.frege",
              "meta.declaration.type.data.frege",
              "meta.declaration.type.data.record.block.frege"
            ]
          },
          {
            "value": ",",
            "scopes": [
              "source.frege",
              "meta.declaration.type.data.frege",
              "meta.declaration.type.data.record.block.frege",
              "punctuation.separator.comma.frege"
            ]
          },
          {
            "value": " ",
            "scopes": [
              "source.frege",
              "meta.declaration.type.data.frege",
              "meta.declaration.type.data.record.block.frege"
            ]
          },
          {
            "value": "model",
            "scopes": [
              "source.frege",
              "meta.declaration.type.data.frege",
              "meta.declaration.type.data.record.block.frege",
              "meta.record-field.type-declaration.frege",
              "entity.other.attribute-name.frege"
            ]
          },
          {
            "value": " ",
            "scopes": [
              "source.frege",
              "meta.declaration.type.data.frege",
              "meta.declaration.type.data.record.block.frege",
              "meta.record-field.type-declaration.frege"
            ]
          },
          {
            "value": "::",
            "scopes": [
              "source.frege",
              "meta.declaration.type.data.frege",
              "meta.declaration.type.data.record.block.frege",
              "meta.record-field.type-declaration.frege",
              "keyword.other.double-colon.frege"
            ]
          },
          {
            "value": " ",
            "scopes": [
              "source.frege",
              "meta.declaration.type.data.frege",
              "meta.declaration.type.data.record.block.frege",
              "meta.record-field.type-declaration.frege",
              "meta.type-signature.frege"
            ]
          },
          {
            "value": "String",
            "scopes": [
              "source.frege",
              "meta.declaration.type.data.frege",
              "meta.declaration.type.data.record.block.frege",
              "meta.record-field.type-declaration.frege",
              "meta.type-signature.frege",
              'entity.name.type.frege',
              "support.class.prelude.String.frege"
            ]
          }
        ],
        [
          {
            "value": "  ",
            "scopes": [
              "source.frege",
              "meta.declaration.type.data.frege",
              "meta.declaration.type.data.record.block.frege",
              "meta.record-field.type-declaration.frege",
              "meta.type-signature.frege"
            ]
          },
          {
            "value": "}",
            "scopes": [
              "source.frege",
              "meta.declaration.type.data.frege",
              "meta.declaration.type.data.record.block.frege",
              "keyword.operator.record.end.frege"
            ]
          }
        ]
      ]
