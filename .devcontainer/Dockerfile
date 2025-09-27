FROM --platform=linux/amd64 mcr.microsoft.com/devcontainers/base:ubuntu
RUN chsh -s /bin/zsh root
RUN apt update
RUN apt install -y build-essential
RUN apt install -y opam
RUN opam init -y
RUN opam update --all
RUN apt install -y autoconf
RUN opam switch create 5.2.0+ox --repos ox=git+https://github.com/oxcaml/opam-repository.git,default
RUN eval $(opam env --switch 5.2.0+ox)
RUN opam install -y ocamlformat merlin ocaml-lsp-server utop parallel core_unix
