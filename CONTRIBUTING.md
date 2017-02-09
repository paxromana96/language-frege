# ***DO NOT EDIT GRAMMAR CSON FILES DIRECTLY***

Some grammar files are generated based on common template. In particular,

- `grammars/frege.cson`
- `grammars/frege autocompletion hint.cson`
- `grammars/frege type hint.cson`
- `grammars/frege message hint.cson`
- `grammars/literate frege.cson`

are generated based on instructions in `src/frege.coffee`.

If you want to change those grammars, edit files in `src/include/` and then run `make` in the root of repository.
