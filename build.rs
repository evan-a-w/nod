pub fn main() -> std::io::Result<()> {
    ocaml_build::Sigs::new("src/nod_rust.ml").generate()
}
