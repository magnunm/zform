module Allpass

export transfer

include("rational.jl")

import Polynomials: Polynomial
import .RationalFunctions: RationalFunction, RationalFunctions

"""Discrete time transfer function for an all pass filter

All pass filter with a single pole and real coefficients. The location of the
pole determines the frequency where the phase shift occurs. Larger real part
moves the phase shift to lower frequencies and vice versa. Simultaneously
as the absolute value approaches 1 the magnitude of the phase shift decreases.

"""
function transfer(pole::ComplexF64)
  # Multiplied by z^2 in numerator and denominator compared to the difference
  # equation definition.
  fraction = RationalFunction(
    Polynomial([1.0, - 2.0 * real(pole), abs(pole)^2]),
    Polynomial([abs(pole)^2, - 2.0 * real(pole), 1.0])
  )
  z -> RationalFunctions.eval(z, fraction)
end

end
