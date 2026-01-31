A backend I'm making for fun :)

We take in input not in ssa form, which looks kinda just like arm or something similar. This is then converted into ssa. Currently only very basic optimisations are done.

Currently we can compile to both x86_64 and aarch_64, and each backend is similarly functional. Regalloc is done through graph colouring using the sat solver in the oxsat submodule.
