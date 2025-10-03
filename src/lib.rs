use std::collections::BTreeMap;

#[ocaml::sig]
pub struct T(pror::cdcl::Default);

ocaml::custom!(T);

#[ocaml::func]
#[ocaml::sig("unit -> t")]
pub fn create() -> ocaml::Pointer<T> {
    T(pror::cdcl::Default::create(vec![])).into()
}

#[ocaml::func]
#[ocaml::sig("int array array -> t")]
pub fn create_with_problem(problem: Vec<Vec<isize>>) -> ocaml::Pointer<T> {
    T(pror::cdcl::Default::create(problem)).into()
}

#[derive(ocaml::FromValue, ocaml::ToValue, Clone)]
#[ocaml::sig("Sat of (int * bool) list | UnsatCore of int list")]
pub enum SatResult {
    Sat(BTreeMap<usize, bool>),
    UnsatCore(Vec<isize>),
}

impl std::convert::Into<SatResult> for pror::sat::SatResult {
    fn into(self) -> SatResult {
        match self {
            pror::sat::SatResult::Sat(m) => SatResult::Sat(m),
            pror::sat::SatResult::UnsatCore(c) => SatResult::UnsatCore(c.into_iter().map(pror::sat::Literal::into).collect()),
        }
    }
}

#[ocaml::func]
#[ocaml::sig("t -> sat_result")]
pub fn run(mut t: ocaml::Pointer<T>) -> SatResult {
    t.as_mut().0.run().into()
}

#[ocaml::func]
#[ocaml::sig("t -> sat_result")]
pub fn run_with_assumptions(mut t: ocaml::Pointer<T>, assumptions: Vec<isize>) -> SatResult {
    t.as_mut().0.run_with_assumptions(&assumptions).into()
}

#[ocaml::func]
#[ocaml::sig("t -> unit")]
pub fn add_clause(mut t: ocaml::Pointer<T>, clause: Vec<isize>) {
    t.as_mut().0.add_clause(clause)
}