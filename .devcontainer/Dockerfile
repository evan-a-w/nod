FROM --platform=linux/amd64 mcr.microsoft.com/devcontainers/base:ubuntu
RUN useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1001 ubuntu
USER ubuntu
WORKDIR /home/ubuntu
RUN sudo apt update
RUN sudo apt install -y build-essential
RUN sudo apt install -y opam
RUN sudo apt install -y autoconf
RUN opam init -y
RUN opam update --all
RUN opam switch create 5.2.0+ox --repos ox=git+https://github.com/oxcaml/opam-repository.git,default
RUN eval $(opam env --switch 5.2.0+ox)
RUN opam install -y ocamlformat merlin ocaml-lsp-server utop parallel core_unix
