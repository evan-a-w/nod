pub fn main() -> std::io::Result<()> {
    ocaml_build::Sigs::new("src/pror_rs.ml").generate()
}
