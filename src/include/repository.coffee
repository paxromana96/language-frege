prelude = require './prelude'
pragmas = require './pragmas'
{ balanced } = require './util'

module.exports=
  block_comment:
    patterns: [
        name: 'comment.block.haddock.frege'
        begin: /\{-\s*[|^]/
        end: /-\}/
        applyEndPatternLast: 1
        beginCaptures:
          0: name: 'punctuation.definition.comment.haddock.frege'
        endCaptures:
          0: name: 'punctuation.definition.comment.haddock.frege'
        patterns: [
            include: '#block_comment'
        ]
      ,
        name: 'comment.block.frege'
        begin: /\{-/
        end: /-\}/
        applyEndPatternLast: 1
        beginCaptures:
          0: name: 'punctuation.definition.comment.block.start.frege'
        endCaptures:
          0: name: 'punctuation.definition.comment.block.end.frege'
        patterns: [
            include: '#block_comment'
        ]
    ]
  comments:
    patterns: [
        begin: /({maybeBirdTrack}[ \t]+)?(?=--+\s+[|^])/
        end: /(?!\G)/
        patterns: [
            name: 'comment.line.double-dash.haddock.frege'
            begin: /(--+)\s+([|^])/
            end: /$/
            beginCaptures:
              1: name: 'punctuation.definition.comment.frege'
              2: name: 'punctuation.definition.comment.haddock.frege'
        ]
      ,
        ###
        Operators may begin with -- as long as they are not
        entirely composed of - characters. This means comments can't be
        immediately followed by an allowable operator character.
        ###
        begin: /({maybeBirdTrack}[ \t]+)?(?=--+(?!{operatorChar}))/
        end: /(?!\G)/
        patterns: [
            name: 'comment.line.double-dash.frege'
            begin: /--/
            end: /$/
            beginCaptures:
              0: name: 'punctuation.definition.comment.frege'
        ]
      ,
        include: '#block_comment'
    ]
  characters:
    patterns: [
        {match: '{escapeChar}', name: 'constant.character.escape.frege'}
        {match: '{octalChar}', name: 'constant.character.escape.octal.frege'}
        {match: '{hexChar}', name: 'constant.character.escape.hexadecimal.frege'}
        {match: '{controlChar}', name: 'constant.character.escape.control.frege'}
      ]
  infix_op:
    name: 'entity.name.function.infix.frege'
    match: /{operatorFun}/
  module_exports:
    name: 'meta.declaration.exports.frege'
    begin: /\(/
    end: /\)/
    applyEndPatternLast: 1
    patterns: [
        include: '#comments'
      ,
        include: '#function_name'
      ,
        include: '#type_name'
      ,
        include: '#comma'
      ,
        name: 'meta.other.constructor-list.frege'
        begin: /{rb}\s*\(/
        end: /\)/
        patterns: [
          { include: '#type_ctor' }
          { include: '#attribute_name' }
          { include: '#comma' }
          {
            match: /\.\./
            name: 'keyword.operator.wildcard.frege'
          }
        ]
      ,
        include: '#infix_op'
    ]
  module_name:
    name: 'support.other.module.frege'
    match: /{lb}{className}{rb}/
  module_name_prefix:
    name: 'support.other.module.frege'
    match: /{lb}{className}\./
  pragma:
    name: 'meta.preprocessor.frege'
    begin: /\{-#/
    end: /#-\}/
    patterns: [
        match: "{lb}(#{pragmas.join('|')}){rb}"
        name: 'keyword.other.preprocessor.frege'
    ]
  function_type_declaration:
    name: 'meta.function.type-declaration.frege'
    begin: /{indentBlockStart}{functionTypeDeclaration}/
    end: /{indentBlockEnd}/
    contentName: 'meta.type-signature.frege'
    beginCaptures:
      2:
        patterns: [
            {include: '#function_name'}
            {include: '#infix_op'}
        ]
      3: name: 'keyword.other.double-colon.frege'
    patterns: [
        include: '#type_signature'
    ]
  ctor_type_declaration:
    name: 'meta.ctor.type-declaration.frege'
    begin: /{indentBlockStart}{ctorTypeDeclaration}/
    end: /{indentBlockEnd}/
    contentName: 'meta.type-signature.frege'
    beginCaptures:
      2:
        patterns: [
            include: '#type_ctor'
          ,
            include: '#infix_op'
        ]
      3: name: 'keyword.other.double-colon.frege'
    patterns: [
        include: '#type_signature'
    ]
  record_field_declaration:
    name: 'meta.record-field.type-declaration.frege'
    begin: /{lb}{functionTypeDeclaration}/
    end: /(?={functionTypeDeclaration}|})/
    contentName: 'meta.type-signature.frege'
    beginCaptures:
      1:
        patterns: [
            include: '#attribute_name'
          ,
            include: '#infix_op'
        ]
      2: name: 'keyword.other.double-colon.frege'
    patterns: [
        include: '#type_signature'
    ]
  type_signature:
    patterns: [
      #TODO: Type operators, type-level integers etc
        include: '#pragma'
      ,
        include: '#comments'
      ,
        name: 'keyword.other.forall.frege'
        match: '{lb}forall{rb}'
      ,
        include: '#unit'
      ,
        include: '#empty_list'
      ,
        include: '#string'
      ,
        name: 'keyword.other.arrow.frege'
        match: '(?<!{operatorChar})(->|→)(?!{operatorChar})'
      ,
        name: 'keyword.other.big-arrow.frege'
        match: '(?<!{operatorChar})(=>|⇒)(?!{operatorChar})'
      ,
        include: '#operator'
      ,
        name: 'variable.other.generic-type.frege'
        match: /{lb}{functionName}{rb}/
      ,
        include: '#type_name'
    ]
  unit:
    name: 'constant.language.unit.frege'
    match: /\(\)/
  empty_list:
    name: 'constant.language.empty-list.frege'
    match: /\[\]/
  deriving:
    patterns: [
        {include: '#deriving_list'}
        {include: '#deriving_simple'}
        {include: '#deriving_keyword'}
    ]
  deriving_keyword:
    name: 'meta.deriving.frege'
    match: /{lb}(deriving){rb}/
    captures:
      1: name: 'keyword.other.frege'
  deriving_list:
    name: 'meta.deriving.frege'
    begin: /{lb}(deriving)\s*\(/
    end: /\)/
    beginCaptures:
      1: name: 'keyword.other.frege'
    patterns: [
        match: /{lb}({className}){rb}/
        captures:
          1: name: 'entity.other.inherited-class.frege'
    ]
  deriving_simple:
    name: 'meta.deriving.frege'
    match: /{lb}(deriving)\s*({className}){rb}/
    captures:
      1: name: 'keyword.other.frege'
      2: name: 'entity.other.inherited-class.frege'
  infix_function:
    name: 'keyword.operator.function.infix.frege'
    match: /(`){functionName}(`)/
    captures:
      1: name: 'punctuation.definition.entity.frege'
      2: name: 'punctuation.definition.entity.frege'
  quasi_quotes:
    begin: /(\[)({functionNameOne})(\|)/
    end: /(\|)(\])/
    beginCaptures:
      1: name: 'punctuation.definition.quasiquotes.begin.frege'
      2: name: 'entity.name.tag.frege'
    endCaptures:
      2: name: 'punctuation.definition.quasiquotes.end.frege'
    contentName: 'string.quoted.quasiquotes.frege'
  module_decl:
    name: 'meta.declaration.module.frege'
    begin: /{indentBlockStart}(module){rb}/
    end: /{lb}(where){rb}|{indentBlockEnd}/
    beginCaptures:
      2: name: 'keyword.other.frege'
    endCaptures:
      1: name: 'keyword.other.frege'
    patterns: [
        {include: '#comments'}
        {include: '#module_name'}
        {include: '#module_exports'}
        {include: '#invalid'}
    ]
  class_decl:
    name: 'meta.declaration.class.frege'
    begin: /{indentBlockStart}(class){rb}/
    end: /{lb}(where){rb}|{indentBlockEnd}/
    beginCaptures:
      2: name: 'keyword.other.class.frege'
    endCaptures:
      1: name: 'keyword.other.frege'
    patterns: [
        include: '#type_signature'
    ]
  instance_decl:
    name: 'meta.declaration.instance.frege'
    begin: /{indentBlockStart}(instance){rb}/
    end: /{lb}(where){rb}|{indentBlockEnd}/
    contentName: 'meta.type-signature.frege'
    beginCaptures:
      2: name: 'keyword.other.frege'
    endCaptures:
      1: name: 'keyword.other.frege'
    patterns: [
        {include: '#pragma'}
        {include: '#type_signature'}
    ]
  deriving_instance_decl:
    name: 'meta.declaration.instance.deriving.frege'
    begin: /{indentBlockStart}(deriving\s+instance){rb}/
    end: /{indentBlockEnd}/
    contentName: 'meta.type-signature.frege'
    beginCaptures:
      2: name: 'keyword.other.frege'
    patterns: [
        {include: '#pragma'}
        {include: '#type_signature'}
    ]
  foreign_import:
    name: 'meta.foreign.frege'
    begin: /{indentBlockStart}(foreign)\s+(import|export){rb}/
    end: /{indentBlockEnd}/
    beginCaptures:
      2: name: 'keyword.other.frege'
      3: name: 'keyword.other.frege'
    patterns:[
        match: /(?:un)?safe/
        captures:
          0: name: 'keyword.other.frege'
      ,
        include: '#function_type_declaration'
      ,
        include: '#frege_expr'
      ,
        include: '#comments'
    ]
  regular_import:
    name: 'meta.import.frege'
    begin: /{indentBlockStart}(import){rb}/
    end: /{indentBlockEnd}/
    beginCaptures:
      2: name: 'keyword.other.frege'
    patterns: [
        include: '#module_name'
      ,
        include: '#module_exports'
      ,
        match: /{lb}(qualified|as|hiding){rb}/
        captures:
          1: name: 'keyword.other.frege'
      ,
        include: '#comments'
    ]
  data_decl:
    name: 'meta.declaration.type.data.frege'
    begin: /{indentBlockStart}(data|newtype)\s+((?:(?!=|where).)*)/
    end: /{indentBlockEnd}/
    beginCaptures:
      2: name: 'keyword.other.data.frege'
      3:
        name: 'meta.type-signature.frege'
        patterns: [
          {include: '#family_and_instance'}
          {include: '#type_signature'}
        ]
    patterns: [
        include: '#comments'
      ,
        include: '#where'
      ,
        include: '#deriving'
      ,
        include: '#assignment_op'
      ,
        match: /{ctor}/
        captures:
          1: patterns: [include: '#type_ctor']
          2:
            name: 'meta.type-signature.frege'
            patterns: [include: '#type_signature']
      ,
        match: /\|/
        captures:
          0: name: 'punctuation.separator.pipe.frege'
      ,
        name: 'meta.declaration.type.data.record.block.frege'
        begin: /\{/
        beginCaptures:
          0: name: 'keyword.operator.record.begin.frege'
        end: /\}/
        endCaptures:
          0: name: 'keyword.operator.record.end.frege'
        patterns: [
            {include: '#comments'}
            {include: '#comma'}
            {include: '#record_field_declaration'}
        ]
      ,
        include: '#ctor_type_declaration' #GADT
    ]
  type_alias:
    name: 'meta.declaration.type.type.frege'
    begin: /{indentBlockStart}(type){rb}/
    end: /{indentBlockEnd}/
    contentName: 'meta.type-signature.frege'
    beginCaptures:
      2: name: 'keyword.other.type.frege'
    patterns: [
        {include: '#comments'}
        {include: '#family_and_instance'}
        {include: '#where'}
        {include: '#assignment_op'}
        {include: '#type_signature'}
    ]
  keywords: [
    name: 'keyword.other.frege'
    match: /{lb}(deriving|where|data|type|newtype){rb}/
  ,
    name: 'keyword.other.frege'
    match: /{lb}(data|type|newtype){rb}/
  ,
    name: 'keyword.operator.frege'
    match: /{lb}infix[lr]?{rb}/
  ,
    name: 'keyword.control.frege'
    match: /{lb}(do|if|then|else|case|of|let|in|default|mdo|rec|proc){rb}/
  ]
  c_preprocessor:
    name: 'meta.preprocessor.c'
    begin: /{maybeBirdTrack}(?=#)/
    end: '(?<!\\\\)(?=$)'
    patterns: [
      include: 'source.c'
    ]
  string:
    name: 'string.quoted.double.frege'
    begin: /"/
    end: /"/
    beginCaptures:
      0: name: 'punctuation.definition.string.begin.frege'
    endCaptures:
      0: name: 'punctuation.definition.string.end.frege'
    patterns: [
        include: '#characters'
      ,
        begin: /\\\s/
        end: /\\/
        beginCaptures:
          0: name: 'markup.other.escape.newline.begin.frege'
        endCaptures:
          0: name: 'markup.other.escape.newline.end.frege'
        patterns: [
            {include: '#invalid'}
        ]
    ]
  newline_escape:
    name: 'markup.other.escape.newline.frege'
    match: /\\$/
  quoted_character:
    name: 'string.quoted.single.frege'
    match: /(')({character})(')/
    captures:
      1: name: 'punctuation.definition.string.begin.frege'
      2:
        patterns:[
          include: '#characters'
        ]
      3: name: 'punctuation.definition.string.end.frege'
  scoped_type: [
    match: "\\((#{balanced 'paren', '\\(', '\\)'}{doubleColonOperator}#{balanced 'paren2', '\\(', '\\)'})\\)"
    captures:
      1: patterns: [
        include: '#frege_expr'
      ]
  ,
    match: '({doubleColonOperator})(.*?)(?=(?<!{operatorChar})(<-|=)(?!{operatorChar})|$)'
    captures:
      1: name: 'keyword.other.double-colon.frege'
      2: {name: 'meta.type-signature.frege', patterns: [include: '#type_signature']}
  ]
  scoped_type_override:
    match: '{indentBlockStart}{functionTypeDeclaration}(.*)(?<!{operatorChar})(<-|=)(?!{operatorChar})'
    captures:
      2: patterns: [include: '#identifier']
      3: name: 'keyword.other.double-colon.frege'
      4: {name: 'meta.type-signature.frege', patterns: [include: '#type_signature']}
      5: patterns: [
          {include: '#assignment_op'}
          {include: '#operator'}
      ]
  comma:
    name: 'punctuation.separator.comma.frege'
    match: /,/
  lit_num: [
    name: 'constant.numeric.hexadecimal.frege'
    match: '0[xX][0-9a-fA-F]+'
  ,
    name: 'constant.numeric.octal.frege'
    match: '0[oO][0-7]+'
  ,
    name: 'constant.numeric.float.frege'
    match: '[0-9]+(\\.[0-9]+[eE][+-]?|\\.|[eE][+-]?)[0-9]+'
  ,
    name: 'constant.numeric.decimal.frege'
    match: '[0-9]+'
  ]
  operator:
    name: 'keyword.operator.frege'
    match: /{operator}/
  identifier:
    match: '{lb}{functionName}{rb}'
    name: 'identifier.frege'
    captures: 0: patterns: [
      { include: '#module_name_prefix' }
      {
        name: 'support.function.prelude.$1.frege'
        match: "{lb}(#{prelude.funct.join('|')}){rb}"
      }
    ]
  type_name:
    name: 'entity.name.type.frege'
    match: /{lb}{className}{rb}/
    captures: 0: patterns: [
      { include: '#module_name_prefix' }
      {
          name: 'entity.other.inherited-class.prelude.$1.frege'
          match: "{lb}(#{prelude.classes.join('|')}){rb}"
      }
      {
          name: 'support.class.prelude.$1.frege'
          match: "{lb}(#{prelude.types.join('|')}){rb}"
      }
    ]
  type_ctor:
    name: 'entity.name.tag.frege'
    match: /{lb}{className}{rb}/
    captures: 0: patterns: [
      { include: '#module_name_prefix' }
      {
        name: 'support.tag.prelude.$1.frege'
        match: "{lb}(#{prelude.constr.join('|')}){rb}"
      }
    ]
  where:
    match: '{lb}where{rb}'
    name: 'keyword.other.frege'
  family_and_instance:
    match: '{lb}(family|instance){rb}'
    name: 'keyword.other.frege'
  invalid:
    match: /\S+/
    name: 'invalid.illegal.character-not-allowed-here.frege'
  function_name:
    name: 'entity.name.function.frege'
    match: /{lb}{functionName}{rb}/
  assignment_op:
    match: /=/
    captures:
      0: name: 'keyword.operator.assignment.frege'
  attribute_name:
    name: 'entity.other.attribute-name.frege'
    match: /{lb}{functionName}{rb}/
  liquidfrege_annotation:
    name: 'block.liquidfrege'
    contentName: 'block.liquidfrege.annotation'
    begin: '\\{-@(?!#)'
    end: '@-\\}'
    patterns: [
        include: '#frege_expr'
    ]
  shebang:
    name: 'comment.line.shebang.frege'
    match: '^\\#\\!.*\\brunfrege\\b.*$'
  frege_expr: [
    { include: '#infix_function' }
    { include: '#unit' }
    { include: '#empty_list' }
    { include: '#quasi_quotes' }
    { include: '#keywords' }
    { include: '#pragma' }
    { include: '#string' }
    { include: '#newline_escape' }
    { include: '#quoted_character' }
    { include: '#comments' }
    { include: '#infix_op' }
    { include: '#comma' }
    { include: '#lit_num' }
    { include: '#scoped_type' }
    { include: '#operator' }
    { include: '#identifier' }
    { include: '#type_ctor' }
  ]
  frege_toplevel: [
    { include: '#liquidfrege_annotation' }
    { include: '#class_decl' }
    { include: '#instance_decl' }
    { include: '#deriving_instance_decl' }
    { include: '#foreign_import' }
    { include: '#regular_import' }
    { include: '#data_decl' }
    { include: '#type_alias' } # TODO: review stopped here
    { include: '#c_preprocessor' }
    { include: '#scoped_type_override' }
    { include: '#function_type_declaration' }
    { include: '#frege_expr' }
  ]
  frege_source: [
    { include: '#shebang' }
    { include: '#module_decl' }
    { include: '#frege_toplevel' }
  ]
