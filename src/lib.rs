use std::collections::BTreeMap;

#[ocaml::sig]
#[repr(transparent)]
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
#[ocaml::sig("Sat of (int * bool) list | UnsatCore of int array")]
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
#[ocaml::sig("t -> int array -> sat_result")]
pub fn run_with_assumptions(mut t: ocaml::Pointer<T>, assumptions: Vec<isize>) -> SatResult {
    t.as_mut().0.run_with_assumptions(&assumptions).into()
}

#[ocaml::func]
#[ocaml::sig("t -> unit")]
pub fn add_clause(mut t: ocaml::Pointer<T>, clause: Vec<isize>) {
    t.as_mut().0.add_clause(clause)
}

#[ocaml::sig]
#[repr(transparent)]
pub struct Bitset(pror::fixed_bitset::BitSet);


ocaml::custom!(Bitset);

#[ocaml::func]
#[ocaml::sig("unit -> bitset")]
pub fn bitset_create() -> ocaml::Pointer<Bitset> {
    Bitset(pror::fixed_bitset::BitSet::new(0)).into()
}

#[ocaml::func]
#[ocaml::sig("bitset -> int -> unit")]
pub fn bitset_grow(mut bitset: ocaml::Pointer<Bitset>, bits: usize) {
    bitset.as_mut().0.grow(bits)
}

#[ocaml::func]
#[ocaml::sig("bitset -> int")]
pub fn bitset_capacity(bitset: ocaml::Pointer<Bitset>) -> usize {
    bitset.as_ref().0.capacity()
}

#[ocaml::func]
#[ocaml::sig("bitset -> unit")]
pub fn bitset_clear_all(mut bitset: ocaml::Pointer<Bitset>) {
    bitset.as_mut().0.clear_all()
}

#[ocaml::func]
#[ocaml::sig("bitset -> int -> unit")]
pub fn bitset_set(mut bitset: ocaml::Pointer<Bitset>, bit: usize) {
    bitset.as_mut().0.set(bit)
}

#[ocaml::func]
#[ocaml::sig("bitset -> int -> int -> unit")]
pub fn bitset_set_between(
    mut bitset: ocaml::Pointer<Bitset>,
    start_bit_incl: usize,
    end_bit_excl: usize,
) {
    bitset
        .as_mut()
        .0
        .set_between(start_bit_incl, end_bit_excl)
}

#[ocaml::func]
#[ocaml::sig("bitset -> int -> unit")]
pub fn bitset_clear(mut bitset: ocaml::Pointer<Bitset>, bit: usize) {
    bitset.as_mut().0.clear(bit)
}

#[ocaml::func]
#[ocaml::sig("bitset -> int -> bool")]
pub fn bitset_contains(bitset: ocaml::Pointer<Bitset>, bit: usize) -> bool {
    bitset.as_ref().0.contains(bit)
}

#[ocaml::func]
#[ocaml::sig("bitset -> int option")]
pub fn bitset_first_set(bitset: ocaml::Pointer<Bitset>) -> Option<usize> {
    bitset.as_ref().0.first_set()
}

#[ocaml::func]
#[ocaml::sig("bitset -> int option")]
pub fn bitset_first_unset(bitset: ocaml::Pointer<Bitset>) -> Option<usize> {
    bitset.as_ref().0.first_unset()
}

#[ocaml::func]
#[ocaml::sig("bitset -> int -> int option")]
pub fn bitset_first_set_ge(bitset: ocaml::Pointer<Bitset>, bit: usize) -> Option<usize> {
    bitset.as_ref().0.first_set_ge(bit)
}

#[ocaml::func]
#[ocaml::sig("bitset -> int -> int option")]
pub fn bitset_first_unset_ge(bitset: ocaml::Pointer<Bitset>, bit: usize) -> Option<usize> {
    bitset.as_ref().0.first_unset_ge(bit)
}

#[ocaml::func]
#[ocaml::sig("bitset -> bitset -> unit")]
pub fn bitset_union_with(
    mut bitset: ocaml::Pointer<Bitset>,
    other: ocaml::Pointer<Bitset>,
) {
    bitset.as_mut().0.union_with(&other.as_ref().0)
}

#[ocaml::func]
#[ocaml::sig("bitset -> bitset -> unit")]
pub fn bitset_intersect_with(
    mut bitset: ocaml::Pointer<Bitset>,
    other: ocaml::Pointer<Bitset>,
) {
    bitset.as_mut().0.intersect_with(&other.as_ref().0)
}

#[ocaml::func]
#[ocaml::sig("bitset -> bitset -> unit")]
pub fn bitset_difference_with(
    mut bitset: ocaml::Pointer<Bitset>,
    other: ocaml::Pointer<Bitset>,
) {
    bitset.as_mut().0.difference_with(&other.as_ref().0)
}

#[ocaml::func]
#[ocaml::sig("bitset -> bitset -> bitset -> unit")]
pub fn bitset_intersect(
    mut dest: ocaml::Pointer<Bitset>,
    a: ocaml::Pointer<Bitset>,
    b: ocaml::Pointer<Bitset>,
) {
    dest.as_mut().0.intersect(&a.as_ref().0, &b.as_ref().0)
}

#[ocaml::func]
#[ocaml::sig("bitset -> int option")]
pub fn bitset_pop_first_set(mut bitset: ocaml::Pointer<Bitset>) -> Option<usize> {
    let res = bitset.as_ref().0.first_set();
    if let Some(bit) = res {
        bitset.as_mut().0.clear(bit);
    }
    res
}

#[ocaml::func]
#[ocaml::sig("bitset -> int -> int option")]
pub fn bitset_nth(bitset: ocaml::Pointer<Bitset>, n: usize) -> Option<usize> {
    bitset.as_ref().0.nth(n)
}

#[ocaml::func]
#[ocaml::sig("bitset -> int")]
pub fn bitset_count(bitset: ocaml::Pointer<Bitset>) -> usize {
    bitset.as_ref().0.count()
}

#[ocaml::func]
#[ocaml::sig("bitset -> int array")]
pub fn bitset_iter(bitset: ocaml::Pointer<Bitset>) -> Vec<usize> {
    bitset.as_ref().0.iter().collect()
}

#[ocaml::func]
#[ocaml::sig("bitset -> bitset -> int array")]
pub fn bitset_iter_union(
    bitset: ocaml::Pointer<Bitset>,
    other: ocaml::Pointer<Bitset>,
) -> Vec<usize> {
    bitset.as_ref().0.iter_union(&other.as_ref().0).collect()
}

#[ocaml::func]
#[ocaml::sig("bitset -> bitset -> int array")]
pub fn bitset_iter_intersection(
    bitset: ocaml::Pointer<Bitset>,
    other: ocaml::Pointer<Bitset>,
) -> Vec<usize> {
    bitset
        .as_ref()
        .0
        .iter_intersection(&other.as_ref().0)
        .collect()
}

#[ocaml::func]
#[ocaml::sig("bitset -> bitset -> int array")]
pub fn bitset_iter_difference(
    bitset: ocaml::Pointer<Bitset>,
    other: ocaml::Pointer<Bitset>,
) -> Vec<usize> {
    bitset
        .as_ref()
        .0
        .iter_difference(&other.as_ref().0)
        .collect()
}

#[ocaml::func]
#[ocaml::sig("bitset -> bitset -> int option")]
pub fn bitset_intersect_first_set(
    bitset: ocaml::Pointer<Bitset>,
    other: ocaml::Pointer<Bitset>,
) -> Option<usize> {
    bitset.as_ref().0.intersect_first_set(&other.as_ref().0)
}

#[ocaml::func]
#[ocaml::sig("bitset -> bitset -> int -> int option")]
pub fn bitset_intersect_first_set_ge(
    bitset: ocaml::Pointer<Bitset>,
    other: ocaml::Pointer<Bitset>,
    ge: usize,
) -> Option<usize> {
    bitset
        .as_ref()
        .0
        .intersect_first_set_ge(&other.as_ref().0, ge)
}

#[ocaml::func]
#[ocaml::sig("bitset -> bool")]
pub fn bitset_is_empty(bitset: ocaml::Pointer<Bitset>) -> bool {
    bitset.as_ref().0.first_set().is_none()
}
