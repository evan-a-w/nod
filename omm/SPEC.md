# omm language spec

omm is a small, explicitly-typed, low-level language intended to be *easy to
lower into Nod IR* while still being ergonomic for writing programs that are
awkward to express directly in IR (control flow, structured data, named locals).

The surface syntax is ML/OCaml-inspired (keywords, `let`, `if/then/else`,
`while/do/done`), but the semantics are closer to “portable assembly”:
explicit loads/stores, explicit pointer arithmetic, C-like struct layout, and
no implicit allocation or garbage collection.

This document is a **draft**; it describes the minimum viable core plus a small
set of well-defined intrinsics.

## 1. Source files

- File extension: `.omm`
- A program is a sequence of **top-level items**:
  - struct type definitions
  - external declarations
  - function definitions
  - global definitions (optional; see §8.4)

## 2. Lexical conventions

### 2.1 Comments

- Line comment: `// ...` to end of line
- Block comment: `(* ... *)` (may be nested)

### 2.2 Identifiers

- Lowercase identifiers (`foo`, `my_struct`, `x1`) name values, fields, and
  types.
- Uppercase identifiers are reserved for future module/type constructor syntax
  and should not be used.

### 2.3 Keywords (reserved)

`type` `struct` `external` `let` `if` `then` `else` `while` `do` `done`
`begin` `end` `return`

### 2.4 Literals

- Integer literal: decimal (`0`, `42`, `-7`) or hex (`0x2a`)
  - Type: `i64` (always)
- Floating literal: decimal (`0.0`, `3.14`, `-1.0e-9`)
  - Type: `f64` (always)
- Unit literal: `()`
  - Type: `unit` (a predefined empty struct; see §3.4)

## 3. Types

omm has a small, nominal type system. There is no type inference for bindings:
every bound value must carry an explicit type annotation.

### 3.1 Built-in scalar types

- `i64` — 64-bit signed integer (two’s complement)
- `f64` — 64-bit floating-point (IEEE 754 binary64)

### 3.2 Pointer types

Pointer types are written postfix:

- `t ptr` — pointer to `t`
- Examples: `i64 ptr`, `f64 ptr`, `point ptr`, `i64 ptr ptr`

Pointers are *unmanaged*: no GC, no provenance tracking beyond what lowering
requires, and no bounds checks.

### 3.3 Struct types

Structs are nominal and resemble C structs: fields are laid out in order with
target-dependent alignment rules (see §7).

Definition form:

```
type point = struct {
  x : f64;
  y : f64;
}
```

Notes:

- Field names are unique within a struct.
- Recursive structs are allowed **only through pointers**, e.g. `next : node ptr`.
- Struct values are first-class: they can be passed/returned, stored/loaded, and
  nested as fields.

### 3.4 The predefined `unit` struct

omm provides a predefined empty struct type:

```
type unit = struct { }
```

The literal `()` has type `unit`. This supports statement-like intrinsics (e.g.
`store`) without introducing additional built-in types.

## 4. Type annotations (required)

Every value binding introduces a name together with its type:

```
let x : i64 = 0;
let p : i64 ptr = alloca<i64>();
```

Function parameters are always annotated:

```
let add(a : i64, b : i64) : i64 = ...
```

omm has **no pattern matching**: a binding introduces exactly one identifier.

`let` bindings may not omit the `: ty` annotation.

## 5. Expressions

omm distinguishes *expressions* (compute values) from *statements* (perform
effects / control flow). Many constructs exist in both expression and statement
positions (e.g. `if`).

### 5.1 Variables and literals

- `x` — variable reference
- `42` — `i64`
- `3.14` — `f64`
- `()` — `unit`

### 5.2 Struct literals and field selection

Struct literal:

```
let p : point = point { x = 1.0; y = 2.0 };
```

Field selection from a struct *value*:

```
let x : f64 = p.x;
```

### 5.3 Operators

Operators are *overloaded by operand type*; both operands must have the same
type unless otherwise specified.

Arithmetic:

- `+ - * /` on `i64` and `f64`
- `%` on `i64` only (remainder)

Comparisons:

- `= <> < <= > >=` on `i64` and `f64`
- Result type: `i64` (`0` for false, `1` for true)

Bitwise (`i64` only):

- `land lor lxor` (and/or/xor)
- `lsl lsr asr` (logical left, logical right, arithmetic right)

### 5.4 Function calls

Call syntax is C-like (parentheses + commas):

```
f(a, b)
```

Unlike OCaml, multi-argument functions are **not curried**: `let f(a:t, b:u)`
defines a single fixed-arity function taking two parameters.

For consistency, intrinsics and externs also use this call syntax.

### 5.5 Pointer, memory, and layout intrinsics

Pointer and memory operations are provided via *typed intrinsics* written as
function-like forms. These are part of the language core (not user-defined).

#### Allocation

- `alloca<t>() : t ptr`
  - Allocates stack storage for one `t`.
  - Lifetime: current function activation.

- `alloca_array<t>(n : i64) : t ptr`
  - Allocates stack storage for `n` contiguous `t` elements.

#### Loads/stores

- `load<t>(p : t ptr) : t`
- `store<t>(p : t ptr, v : t) : unit`

#### Pointer arithmetic and indexing

- `ptr_add<t>(p : t ptr, i : i64) : t ptr`
  - Returns `p + i * sizeof(t)`.
- Indexing sugar:
  - `p[i]` is syntax sugar for `ptr_add<_>(p, i)`

#### Struct field address

- `field_addr<s, t>(p : s ptr, field = x) : t ptr`
  - `x` is a **field identifier** (syntax), not a runtime value.
  - Returns the address of field `x` within the struct pointed to by `p`.
  - The `t` parameter must match the declared field type.
- Arrow sugar:
  - `p->x` is syntax sugar for `field_addr<s, _>(p, field = x)`
  - `p->x` has type `(field_type) ptr`

#### Type casts

- `f64_of_i64(x : i64) : f64` (signed conversion)
- `i64_of_f64(x : f64) : i64` (round-toward-zero; traps on NaN/overflow)
- `bitcast<u, v>(x : u) : v`
  - Reinterprets bits; only allowed when `sizeof(u) = sizeof(v)`.
- `ptr_cast<u, v>(p : u ptr) : v ptr`
  - Reinterprets a pointer type (no-op in machine code; affects typing only).

#### Layout queries (compile-time constants)

All layout queries produce an `i64` constant.

- `sizeof<t>() : i64`
- `alignof<t>() : i64`
- `offsetof<s>(x) : i64`
  - `x` is a **field identifier** (syntax), not a runtime value.

## 6. Statements and blocks

### 6.1 Blocks

Block syntax:

```
begin
  stmt1;
  stmt2;
  ...
end
```

Semicolons separate statements. A block is valid as a function body or as the
body of control-flow statements.

### 6.2 `let` bindings

Local binding statement:

```
let x : ty = expr;
```

Bindings are immutable. Shadowing is allowed.

There is no `let ... in` expression form; use `let ...;` to introduce locals in
blocks.

### 6.3 Conditionals

Expression form:

```
if c then e1 else e2
```

Statement form:

```
if c then begin ... end else begin ... end;
```

`c` must have type `i64`. Zero is false; non-zero is true.

### 6.4 Loops

```
while c do
  begin
    ...
  end
done;
```

`c` must have type `i64`. A `while` loop evaluates to `unit`.

### 6.5 Return

```
return expr;
```

Every control-flow path in a function body must end in `return`.

## 7. Memory model and layout

### 7.1 Target assumptions (current)

This draft assumes a 64-bit target:

- Pointer size: 8 bytes
- Endianness: little-endian
- `i64` alignment: 8
- `f64` alignment: 8
- `t ptr` alignment: 8

### 7.2 Struct layout

Structs are laid out like C:

- Fields appear in declaration order.
- Each field is placed at the next offset satisfying its alignment.
- The struct size is padded to a multiple of the struct’s alignment (max of
  field alignments).

`offsetof`, `sizeof`, and `alignof` follow these rules.

## 8. Top-level items

At top level, omm supports:

- struct type definitions
- external function declarations (for linking/interop)
- function definitions
- global variable definitions restricted to **top-level expressions** (§8.4)

### 8.1 Type definitions

```
type name = struct { ... }
```

### 8.2 External declarations

```
external name : (t1, t2, ... , tn) -> tr = "symbol_name"
```

The arrow type is *signature-only* syntax; externally declared functions are
still fixed-arity (not curried) and use the platform ABI selected by the
compiler/lowering pipeline.

### 8.3 Function definitions

```
let name(a : t1, b : t2) : tr =
  begin
    ...
    return expr;
  end
```

Zero-argument functions omit parameters:

```
let name() : tr =
  begin
    ...
    return expr;
  end
```

Recursion: functions may refer to themselves by name; no `rec` keyword is used.

### 8.4 Globals (restricted top-level expressions)

Top-level `let` may also define global variables, but the initializer is
restricted to a **top-level expression**:

```
let name : ty = top_expr;
```

`top_expr` is one of:

- a literal (`i64`, `f64`, `()`)
- a reference to another top-level variable
- a struct literal whose field expressions are themselves `top_expr`

No intrinsics (`alloca`, `load`, `store`, etc.), control flow, or pointer
operations are permitted in `top_expr`. This keeps globals purely declarative
and easy to lower.

## 9. Dynamic semantics (core rules)

### 9.1 Integer operations

- `i64` arithmetic wraps modulo 2^64 (two’s complement).
- `i64` division/mod by zero traps.
- Shifts mask the shift amount to `[0, 63]`.

### 9.2 Floating operations

- `f64` follows IEEE 754 semantics for `+ - * /`.
- Comparisons follow IEEE rules (notably, comparisons with NaN are false except
  `<>`, which is true).

### 9.3 Undefined behavior (UB)

The following are UB unless an intrinsic specifies otherwise:

- Loading from an invalid pointer (including null) or misaligned address
- Storing to an invalid pointer or misaligned address
- Pointer arithmetic that overflows the address space
- Using a `bitcast` between differently-sized types

An implementation may lower UB to traps, assume it never happens for
optimization, or propagate poison/undef in IR; the spec permits all of these.

## 10. Examples

### 10.1 Structs and stack allocation

```
type pair = struct { a : i64; b : i64; }

external print_i64 : (i64) -> i64 = "print_i64"

let main(u : unit) : i64 =
  begin
    let p : pair ptr = alloca<pair>();
    store<pair>(p, pair { a = 1; b = 2 });
    let a_ptr : i64 ptr = p->a;
    let b_ptr : i64 ptr = p->b;
    let s : i64 = load<i64>(a_ptr) + load<i64>(b_ptr);
    let _ : i64 = print_i64(s);
    return 0;
  end
```

### 10.2 While loop

```
external print_i64 : (i64) -> i64 = "print_i64"

let sum_to(n : i64) : i64 =
  begin
    let i : i64 ptr = alloca<i64>();
    let acc : i64 ptr = alloca<i64>();
    store<i64>(i, 0);
    store<i64>(acc, 0);
    while load<i64>(i) <= n do
      begin
        store<i64>(acc, load<i64>(acc) + load<i64>(i));
        store<i64>(i, load<i64>(i) + 1);
      end
    done;
    let result : i64 = load<i64>(acc);
    let _ : i64 = print_i64(result);
    return result;
  end
```

## 11. Grammar sketch (informative)

This is a sketch, not a complete parser spec.

```
program      ::= item*
item         ::= type_def | extern_decl | fun_def | global_def
type_def     ::= "type" ident "=" "struct" "{" field* "}"
field        ::= ident ":" type ";"
extern_decl  ::= "external" ident ":" sig "=" string_lit
sig          ::= "(" [type ("," type)*] ")" "->" type
fun_def      ::= "let" ident "(" [param ("," param)*] ")" ":" type "=" block
param        ::= ident ":" type
global_def   ::= "let" ident ":" type "=" top_expr ";"
block        ::= "begin" stmt* "end"
stmt         ::= let_stmt | if_stmt | while_stmt | return_stmt | expr_stmt
let_stmt     ::= "let" ident ":" type "=" expr ";"
return_stmt  ::= "return" expr ";"
expr_stmt    ::= expr ";"
type         ::= "i64" | "f64" | ident | type "ptr"
expr         ::= ... (see sections above)
top_expr     ::= literal | ident | struct_lit(top_expr)
```
