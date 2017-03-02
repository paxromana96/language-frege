# Frege support in Atom

Adds syntax highlighting and snippets to Frege files in Atom.

Forked from the package [language-haskell](https://github.com/atom-haskell/language-haskell), since Frege is a Haskell for the JVM.

Grammars:

* Frege (\*.fr)

![image](https://cloud.githubusercontent.com/assets/7275622/8120540/f16d7ee6-10a8-11e5-9b9d-223ff05a54c6.png)

Based on [Haskell TextMate bundle](https://github.com/textmate/haskell.tmbundle).

# Auto-indent

If you don't like current auto-indentation settings, you can define your own regexp in `config.cson` (Edit -> Open Your Config), or disable it altogether, e.g.

To disable auto-indent:

```cson
".frege.source":
  editor:
    increaseIndentPattern: ''
```

Note that regexp expression is using oniguruma for parsing, and it needs to be a string, not a javascript regexp. You'll also have to escape `\`.

By default, `increaseIndentPattern` has the following value:

```cson
".frege.source":
  editor:
    increaseIndentPattern: '(((=|\\bdo|\\bwhere|\\bthen|\\belse|\\bof)\\s*)|(\\bif(?!.*\\bthen\\b.*\\belse\\b.*).*))$'
```

# Configuring highlighting

Note, you may need to reopen currently opened files (or restart Atom) for your new stylesheet to be applied.

## Module names

`language-frege` uses `support.other.module.frege` scope for module names, both in `import` statements and when using qualified identifiers (like `Prelude.foldl`). Your syntax theme might not support this scope. If you want to highlight module names in this case, you can add the following to your stylesheet (Edit → Stylesheet...):

```less
// pre Atom 1.13
atom-text-editor::shadow, ide-frege-panel {
  .support.other.module.frege {
    color: #C0A077; //or whatever color you like
  }
}
// post Atom 1.13
.syntax--support.syntax--other.syntax--module.syntax--frege {
  color: #C0A077; //or whatever color you like
}
```

## Operators and infix function application

`language-frege` uses `keyword.operator.frege` scope for operators and `keyword.operator.infix.frege` for infix function application, e.g.

```frege
negate `map` [1..10]
```

Not all syntax themes support these scopes (almost none support `keyword.operator.infix` particularly)

If you want to higlight operators and infix function applications you can add the following to your stylesheet (Edit → Stylesheet...):

```less
// pre Atom 1.13
atom-text-editor::shadow, ide-frege-panel {
    .keyword.operator.frege {
      color: #CF8C00; // or whatever color you like
    }
    .keyword.operator.infix.frege {
      color: #CC77AC; // if you want to highlight infix application differently
    }
}
// post Atom 1.13
.syntax--keyword.syntax--operator.syntax--frege {
  color: #CF8C00; // or whatever color you like
}
.syntax--keyword.syntax--operator.syntax--infix.syntax--frege {
  color: #CC77AC; // if you want to highlight infix application differently
}
```

## Special `Prelude` treatment

For historical and other reasons (see #85 for discussion), `Prelude` identifiers (functions, types, etc) are treated slightly differently and, depending on your highlighting theme, can be highlighted differently.

Scopes that are used:

* `support.function.prelude.frege` for functions and values
* `support.class.prelude.frege` for types
* `entity.other.inherited-class.prelude.frege` for typeclasses
* `support.tag.prelude.frege` for type constructors

If you want `Prelude` identifiers highlighted differently from all the rest, you can define different colors for all or some of those, f.ex. by adding something like this to your stylesheet (Edit → Stylesheet...):

```less
// pre Atom 1.13
atom-text-editor::shadow, ide-frege-panel {
    .support.function.prelude.frege {
      color: #56b6c2; // or whatever color you like
    }
    .support.tag.prelude.frege {
      color: #e9969d;
    }
}
// post Atom 1.13
.syntax--support.syntax--function.syntax--prelude.syntax--frege {
  color: #56b6c2; // or whatever color you like
}
.syntax--support.syntax--tag.syntax--prelude.syntax--frege {
  color: #e9969d;
}
```

If you don't want `Prelude` identifiers highlighted differently, you can override it by adding something like this to your stylesheet (Edit → Stylesheet...):

```less
// pre Atom 1.13
atom-text-editor::shadow, ide-frege-panel {
  .prelude.frege {
    color: inherit;
  }
}
// post Atom 1.13
.syntax--prelude.syntax--frege {
  color: inherit;
}
```

Note, you may need to reopen currently opened files (or restart Atom) for your new stylesheet to be applied.

### Different highlighting for different Prelude identifiers

Since language-frege v1.12.0 every Prelude identifier has a scope corresponding to its name added, so you can add special highlighting to particular identifiers only.

For example, if you would like to highlight `undefined` and `error` in angry bold red, you can add something like this to your stylesheet:

```less
// pre Atom 1.13
atom-text-editor::shadow, ide-frege-panel {
  .support.function.prelude.frege {
    &.undefined, &.error {
      color: red;
      font-weight: bold;
    }
  }
}
// post Atom 1.13
.syntax--support.syntax--function.syntax--prelude.syntax--frege {
  &.syntax--undefined, &.syntax--error {
    color: red;
    font-weight: bold;
  }
}
```

All identifier scopes are case-sensitive, so, if you want to highlight, f.ex. `IO`, you would use `support.class.prelude.IO.frege` scope.

# Contributing

See [CONTRIBUTING.md](https://github.com/atom-frege/language-frege/blob/master/CONTRIBUTING.md)

# License

Copyright © 2015 Atom-Frege

Contributors (by number of commits):
* Nikolay Yakimov
* Jared Roesch
* Matthew Griffith
* samuela
* Ross Ogilvie
* Rob Rix
* Ranjit Jhala
* Michael Rawson
* mdgriffith
* Jesse Cooke
* Ian D. Bollinger
* JJ Brown

See the [LICENSE.md][LICENSE] for details.

[LICENSE]: https://github.com/atom-frege/language-frege/blob/master/LICENSE.md
