describe "Language Angelscript (HPS - Soma) package", ->

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-angelscript-hpl3")

  describe "HPS Grammar", ->
    grammar = null

    beforeEach ->
      runs ->
        grammar = atom.grammars.grammarForScopeName('source.hps')

    it "parses the grammar", ->
      expect(grammar).toBeDefined()
      expect(grammar.scopeName).toBe "source.hps"

    it "parses comments", ->
      {tokens} = grammar.tokenizeLine "// Line comment"

      expect(tokens[0]).toEqual value: "// Line comment", scopes: [ 'source.hps', 'comment.line.double-slash.angelscript' ]

      tokens = grammar.tokenizeLines """
      /*
      Block comment
      */
      """

      expect(tokens[0][0]).toEqual value: '/*',            scopes: [ 'source.hps', 'comment.block.angelscript', 'punctuation.definition.comment.angelscript' ]
      expect(tokens[1][0]).toEqual value: 'Block comment', scopes: [ 'source.hps', 'comment.block.angelscript' ]
      expect(tokens[2][0]).toEqual value: '*/',            scopes: [ 'source.hps', 'comment.block.angelscript', 'punctuation.definition.comment.angelscript' ]

    it "parses data types and literal values", ->
      {tokens} = grammar.tokenizeLine "int i0 = 1;"
      expect(tokens[0]).toEqual value: "int",            scopes: [ 'source.hps', 'support.type.angelscript' ]
      expect(tokens[6]).toEqual value: "1",              scopes: [ 'source.hps', 'constant.language.angelscript' ]

      {tokens} = grammar.tokenizeLine "int8 i1 = 2;"
      expect(tokens[0]).toEqual value: "int8",           scopes: [ 'source.hps', 'support.type.angelscript' ]
      expect(tokens[6]).toEqual value: "2",              scopes: [ 'source.hps', 'constant.language.angelscript' ]

      {tokens} = grammar.tokenizeLine "int16 i2 = 3;"
      expect(tokens[0]).toEqual value: "int16",          scopes: [ 'source.hps', 'support.type.angelscript' ]
      expect(tokens[6]).toEqual value: "3",              scopes: [ 'source.hps', 'constant.language.angelscript' ]

      {tokens} = grammar.tokenizeLine "int32 i3 = 4;"
      expect(tokens[0]).toEqual value: "int32",          scopes: [ 'source.hps', 'support.type.angelscript' ]
      expect(tokens[6]).toEqual value: "4",              scopes: [ 'source.hps', 'constant.language.angelscript' ]

      {tokens} = grammar.tokenizeLine "int64 i4 = 5;"
      expect(tokens[0]).toEqual value: "int64",          scopes: [ 'source.hps', 'support.type.angelscript' ]
      expect(tokens[6]).toEqual value: "5",              scopes: [ 'source.hps', 'constant.language.angelscript' ]

    it "parses statements and expressions", ->
      {tokens} = grammar.tokenizeLine "a = 3 + 5;"
      expect(tokens[0]).toEqual value: "a",            scopes: [ 'source.hps', 'entity.name.object.angelscript' ]
      expect(tokens[2]).toEqual value: "=",            scopes: [ 'source.hps', 'keyword.operator.logical.angelscript' ]
      expect(tokens[4]).toEqual value: "3",            scopes: [ 'source.hps', 'constant.language.angelscript' ]
      expect(tokens[6]).toEqual value: "+",            scopes: [ 'source.hps', 'keyword.operator.logical.angelscript' ]
      expect(tokens[8]).toEqual value: "5",            scopes: [ 'source.hps', 'constant.language.angelscript' ]

      {tokens} = grammar.tokenizeLine "b += 2;"
      expect(tokens[0]).toEqual value: "b",            scopes: [ 'source.hps', 'entity.name.object.angelscript' ]
      expect(tokens[2]).toEqual value: "+=",            scopes: [ 'source.hps', 'keyword.operator.logical.angelscript' ]
      expect(tokens[4]).toEqual value: "2",            scopes: [ 'source.hps', 'constant.language.angelscript' ]
