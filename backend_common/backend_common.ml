open! Core
open! Import

module M (A : Arch.S) = struct
  module Util = Util.M (A)
  module Calc_liveness = Calc_liveness.M (A)
  module Reg_numbering = Calc_liveness.Reg_numbering
  module Interference_graph = Interference_graph.M (A)
  module Calc_clobbers = Calc_clobbers.M (A)
  module Assignment = Assignment.M (A.Reg)
end
