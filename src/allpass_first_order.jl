module AllpassFirstOrder

export transfer

include("rational.jl")

import Polynomials: Polynomial
import .RationalFunctions: RationalFunction, RationalFunctions

"""Return a first-order discrete-time all-pass transfer function.

The transfer function is `(a + z^-1) / (1 + a * z^-1)`.  `coefficient` must
have an absolute value below one so that the pole at `-coefficient` is stable.
"""
function transfer(coefficient::Float64)
  abs(coefficient) < 1.0 || throw(ArgumentError("coefficient must be between -1 and 1"))

  # Multiplied by z compared to the difference equation definition.
  fraction = RationalFunction(
    Polynomial([1.0, coefficient]),
    Polynomial([coefficient, 1.0])
  )
  z -> RationalFunctions.evaluate(z, fraction)
end

end
