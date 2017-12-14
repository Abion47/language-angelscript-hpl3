describe 'Language Angelscript (HPS - Soma) package', ->

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('language-angelscript-hpl3')

  describe 'HPS Grammar', ->
    grammar = null

    beforeEach ->
      runs ->
        grammar = atom.grammars.grammarForScopeName('source.hps')

    it 'parses the grammar', ->
      expect(grammar).toBeDefined()
      expect(grammar.scopeName).toBe 'source.hps'

    it 'tokenizes comments', ->
      {tokens} = grammar.tokenizeLine '// Line comment'

      expect(tokens[0]).toEqual value: '// Line comment', scopes: [ 'source.hps', 'comment.line.double-slash.angelscript' ]

      tokens = grammar.tokenizeLines """
      /*
      Block comment
      */
      """

      expect(tokens[0][0]).toEqual value: '/*',            scopes: [ 'source.hps', 'comment.block.angelscript', 'punctuation.definition.comment.angelscript' ]
      expect(tokens[1][0]).toEqual value: 'Block comment', scopes: [ 'source.hps', 'comment.block.angelscript' ]
      expect(tokens[2][0]).toEqual value: '*/',            scopes: [ 'source.hps', 'comment.block.angelscript', 'punctuation.definition.comment.angelscript' ]

    it 'tokenizes data types and literal values', ->
      {tokens} = grammar.tokenizeLine 'int i0 = 1;'
      expect(tokens[0]).toEqual value: 'int',            scopes: [ 'source.hps', 'storage.type.angelscript' ]
      expect(tokens[6]).toEqual value: '1',              scopes: [ 'source.hps', 'constant.language.angelscript' ]

      {tokens} = grammar.tokenizeLine 'int8 i1 = 2;'
      expect(tokens[0]).toEqual value: 'int8',           scopes: [ 'source.hps', 'storage.type.angelscript' ]
      expect(tokens[6]).toEqual value: '2',              scopes: [ 'source.hps', 'constant.language.angelscript' ]

      {tokens} = grammar.tokenizeLine 'int16 i2 = 3;'
      expect(tokens[0]).toEqual value: 'int16',          scopes: [ 'source.hps', 'storage.type.angelscript' ]
      expect(tokens[6]).toEqual value: '3',              scopes: [ 'source.hps', 'constant.language.angelscript' ]

      {tokens} = grammar.tokenizeLine 'int32 i3 = 4;'
      expect(tokens[0]).toEqual value: 'int32',          scopes: [ 'source.hps', 'storage.type.angelscript' ]
      expect(tokens[6]).toEqual value: '4',              scopes: [ 'source.hps', 'constant.language.angelscript' ]

      {tokens} = grammar.tokenizeLine 'int64 i4 = 5;'
      expect(tokens[0]).toEqual value: 'int64',          scopes: [ 'source.hps', 'storage.type.angelscript' ]
      expect(tokens[6]).toEqual value: '5',              scopes: [ 'source.hps', 'constant.language.angelscript' ]

    it 'tokenizes statements and expressions', ->
      {tokens} = grammar.tokenizeLine 'a = 3 + 5;'
      expect(tokens[0]).toEqual value: 'a',            scopes: [ 'source.hps', 'entity.name.object.angelscript' ]
      expect(tokens[2]).toEqual value: '=',            scopes: [ 'source.hps', 'keyword.operator.logical.angelscript' ]
      expect(tokens[4]).toEqual value: '3',            scopes: [ 'source.hps', 'constant.language.angelscript' ]
      expect(tokens[6]).toEqual value: '+',            scopes: [ 'source.hps', 'keyword.operator.logical.angelscript' ]
      expect(tokens[8]).toEqual value: '5',            scopes: [ 'source.hps', 'constant.language.angelscript' ]

      {tokens} = grammar.tokenizeLine 'b += 2;'
      expect(tokens[0]).toEqual value: 'b',            scopes: [ 'source.hps', 'entity.name.object.angelscript' ]
      expect(tokens[2]).toEqual value: '+=',            scopes: [ 'source.hps', 'keyword.operator.logical.angelscript' ]
      expect(tokens[4]).toEqual value: '2',            scopes: [ 'source.hps', 'constant.language.angelscript' ]

    it 'tokenizes function declarations', ->
      {tokens} = grammar.tokenizeLine 'void func() {}'
      expect(tokens[0]).toEqual value: 'void',        scopes: [ 'source.hps', 'meta.function.angelscript', 'storage.type.angelscript' ]
      expect(tokens[2]).toEqual value: 'func',        scopes: [ 'source.hps', 'meta.function.angelscript','entity.name.function.angelscript' ]

      tokens = grammar.tokenizeLines """
      void func()
      {
        int z = 0;
      }
      """

      expect(tokens[0][0]).toEqual value: 'void',        scopes: [ 'source.hps', 'meta.function.angelscript','storage.type.angelscript' ]
      expect(tokens[0][2]).toEqual value: 'func',        scopes: [ 'source.hps', 'meta.function.angelscript','entity.name.function.angelscript' ]

      {tokens} = grammar.tokenizeLine 'Object@ func(const tString &in asString, Object@ &out obj, int alInt) {}'
      expect(tokens[0]).toEqual value: 'Object@',         scopes: [ 'source.hps', 'meta.function.angelscript','storage.type.other.angelscript' ]
      expect(tokens[2]).toEqual value: 'func',            scopes: [ 'source.hps', 'meta.function.angelscript','entity.name.function.angelscript' ]
      expect(tokens[4]).toEqual value: 'const',           scopes: [ 'source.hps', 'meta.function.angelscript','storage.modifier.angelscript' ]
      expect(tokens[6]).toEqual value: 'tString',         scopes: [ 'source.hps', 'meta.function.angelscript','storage.type.other.angelscript' ]
      expect(tokens[8]).toEqual value: '&in',             scopes: [ 'source.hps', 'meta.function.angelscript','keyword.operator.logical.angelscript' ]
      expect(tokens[10]).toEqual value: 'asString',       scopes: [ 'source.hps', 'meta.function.angelscript','entity.name.object.angelscript' ]
      expect(tokens[13]).toEqual value: 'Object@',        scopes: [ 'source.hps', 'meta.function.angelscript','storage.type.other.angelscript' ]
      expect(tokens[15]).toEqual value: '&out',           scopes: [ 'source.hps', 'meta.function.angelscript','keyword.operator.logical.angelscript' ]
      expect(tokens[17]).toEqual value: 'obj',            scopes: [ 'source.hps', 'meta.function.angelscript','entity.name.object.angelscript' ]
      expect(tokens[20]).toEqual value: 'int',            scopes: [ 'source.hps', 'meta.function.angelscript','storage.type.angelscript' ]
      expect(tokens[22]).toEqual value: 'alInt',          scopes: [ 'source.hps', 'meta.function.angelscript','entity.name.object.angelscript' ]

      {tokens} = grammar.tokenizeLine 'void func() final {}'
      expect(tokens[5]).toEqual value: 'final',           scopes: [ 'source.hps', 'meta.function.angelscript','storage.modifier.angelscript' ]

      {tokens} = grammar.tokenizeLine 'void func() override {}'
      expect(tokens[5]).toEqual value: 'override',        scopes: [ 'source.hps', 'meta.function.angelscript','storage.modifier.angelscript' ]

    it 'tokenizes function calls', ->
      {tokens} = grammar.tokenizeLine 'func("string", obj, 5);'
      expect(tokens[0]).toEqual value: 'func',            scopes: [ 'source.hps', 'entity.name.function.angelscript' ]
      expect(tokens[3]).toEqual value: 'string',          scopes: [ 'source.hps', 'string.quoted.double.angelscript' ]
      expect(tokens[6]).toEqual value: 'obj',             scopes: [ 'source.hps', 'entity.name.object.angelscript' ]
      expect(tokens[8]).toEqual value: '5',               scopes: [ 'source.hps', 'constant.language.angelscript' ]

    it 'tokenizes class declarations', ->
      {tokens} = grammar.tokenizeLine 'class cNewClass {}'
      expect(tokens[0]).toEqual value: 'class',           scopes: [ 'source.hps', 'meta.class.angelscript', 'storage.type.class.angelscript' ]
      expect(tokens[2]).toEqual value: 'cNewClass',       scopes: [ 'source.hps', 'meta.class.angelscript', 'entity.name.type.class.angelscript' ]

      {tokens} = grammar.tokenizeLine 'class cNewClass : cBaseClass {}'
      expect(tokens[0]).toEqual value: 'class',           scopes: [ 'source.hps', 'meta.class.angelscript', 'storage.type.class.angelscript' ]
      expect(tokens[2]).toEqual value: 'cNewClass',       scopes: [ 'source.hps', 'meta.class.angelscript', 'entity.name.type.class.angelscript' ]
      expect(tokens[4]).toEqual value: 'cBaseClass',      scopes: [ 'source.hps', 'meta.class.angelscript', 'entity.other.inherited-class.angelscript' ]

      {tokens} = grammar.tokenizeLine 'final class cFinalClass {}'
      expect(tokens[0]).toEqual value: 'final',           scopes: [ 'source.hps', 'storage.modifier.angelscript' ]
      expect(tokens[4]).toEqual value: 'cFinalClass',     scopes: [ 'source.hps', 'meta.class.angelscript', 'entity.name.type.class.angelscript' ]

    it 'tokenizes generic objects', ->
      {tokens} = grammar.tokenizeLine 'array<int> vArray;'
      expect(tokens[0]).toEqual value: 'array',           scopes: [ 'source.hps', 'storage.type.angelscript' ]
      expect(tokens[2]).toEqual value: 'int',             scopes: [ 'source.hps', 'meta.generics.angelscript', 'storage.type.angelscript' ]
      expect(tokens[5]).toEqual value: 'vArray',          scopes: [ 'source.hps', 'entity.name.object.angelscript' ]

      {tokens} = grammar.tokenizeLine 'array<Object@> vArray;'
      expect(tokens[2]).toEqual value: 'Object@',         scopes: [ 'source.hps', 'meta.generics.angelscript', 'storage.type.other.angelscript' ]

    it 'tokenizes include directives', ->
      {tokens} = grammar.tokenizeLine '#include "helpers/helper_player.hps"'
      expect(tokens[1]).toEqual value: 'helpers/helper_player.hps', scopes: [ 'source.hps', 'directive.import.angelscript', 'module.import.name.angelscript' ]
