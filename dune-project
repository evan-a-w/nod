(lang dune 3.16)

(name nod)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name")

(maintainers "Maintainer Name")

(license LICENSE)

(documentation https://url/to/documentation)

(pin
 (package
  (name feel)
  (version 2.0))
  (url git+https://github.com/evan-a-w/oxsat))

(package
 (name nod)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends ocaml dune core feel)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
