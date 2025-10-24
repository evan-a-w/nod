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



// pub trait BitSetT {
//     fn create() -> Self;
//     /// Ensure capacity for at least `bits` bits. Does not shrink.
//     fn grow(&mut self, bits: usize);
//     /// Total number of bits currently supported.
//     fn capacity(&self) -> usize;
//     /// Clear all bits to zero.
//     fn clear_all(&mut self);
//     /// Set a bit to 1, resizing if necessary.
//     fn set(&mut self, bit: usize);

//     fn set_between(&mut self, start_bit_incl: usize, end_bit_excl: usize);

//     /// Clear a bit to 0.
//     fn clear(&mut self, bit: usize);
//     /// Test if a bit is set.
//     fn contains(&self, bit: usize) -> bool;

//     /// Find the first set bit, or `None`.
//     fn first_set(&self) -> Option<usize>;
//     /// Find the first unset bit, or `None`.
//     fn first_unset(&self) -> Option<usize>;
//     /// Find the first set bit ≥ `bit`.
//     fn first_set_ge(&self, bit: usize) -> Option<usize>;
//     /// Find the first unset bit ≥ `bit`.
//     fn first_unset_ge(&self, bit: usize) -> Option<usize>;

//     /// In-place union: `self |= other`.
//     fn union_with(&mut self, other: &Self);

//     /// In-place intersection: `self &= other`.
//     fn intersect_with(&mut self, other: &Self);
//     /// In-place difference: `self &= !other`.
//     fn difference_with(&mut self, other: &Self);

//     fn pop_first_set(&mut self) -> Option<usize> {
//         let res = self.first_set()?;
//         self.clear(res);
//         Some(res)
//     }
//     fn intersect(&mut self, a: &Self, b: &Self);

//     fn nth(&self, n: usize) -> Option<usize>;

//     fn count(&self) -> usize;

//     fn iter(&self) -> impl Iterator<Item = usize> + '_ {
//         let mut after = 0;
//         iter::from_fn(move || {
//             let res = self.first_set_ge(after);
//             if let Some(res) = res {
//                 after = res + 1;
//                 Some(res)
//             } else {
//                 None
//             }
//         })
//     }

//     fn intersect_first_set_ge(&self, other: &Self, ge: usize) -> Option<usize> {
//         match (self.first_set_ge(ge), other.first_set_ge(ge)) {
//             (Some(a), Some(b)) if a == b => Some(a),
//             (Some(a), Some(b)) if a < b => self.intersect_first_set_ge(other, b),
//             (Some(a), Some(_)) => self.intersect_first_set_ge(other, a),
//             (Some(_), None) | (None, Some(_)) | (None, None) => None,
//         }
//     }

//     fn intersect_first_set(&self, other: &Self) -> Option<usize> {
//         self.intersect_first_set_ge(other, 0)
//     }

//     fn is_empty(&self) -> bool {
//         self.first_set().is_none()
//     }

//     fn iter_union<'a>(&'a self, other: &'a Self) -> impl Iterator<Item = usize> + 'a {
//         let mut next_idx = 0;
//         iter::from_fn(move || {
//             loop {
//                 // find next candidate in either set
//                 let a = self.first_set_ge(next_idx);
//                 let b = other.first_set_ge(next_idx);
//                 let bit = match (a, b) {
//                     (Some(x), Some(y)) => Some(x.min(y)),
//                     (Some(x), None) => Some(x),
//                     (None, Some(y)) => Some(y),
//                     (None, None) => None,
//                 };
//                 match bit {
//                     Some(i) => {
//                         next_idx = i + 1;
//                         return Some(i);
//                     }
//                     None => return None,
//                 }
//             }
//         })
//     }

//     fn iter_intersection<'a>(&'a self, other: &'a Self) -> impl Iterator<Item = usize> + 'a {
//         let mut next_idx = 0;
//         iter::from_fn(move || {
//             loop {
//                 // scan self for next set bit...
//                 if let Some(i) = self.first_set_ge(next_idx) {
//                     next_idx = i + 1;
//                     if other.contains(i) {
//                         return Some(i);
//                     } else {
//                         continue;
//                     }
//                 }
//                 return None;
//             }
//         })
//     }

//     fn iter_difference<'a>(&'a self, other: &'a Self) -> impl Iterator<Item = usize> + 'a {
//         let mut next_idx = 0;
//         iter::from_fn(move || {
//             loop {
//                 // scan self for next set bit not in other...
//                 if let Some(i) = self.first_set_ge(next_idx) {
//                     next_idx = i + 1;
//                     if !other.contains(i) {
//                         return Some(i);
//                     } else {
//                         continue;
//                     }
//                 }
//                 return None;
//             }
//         })
//     }
// }
