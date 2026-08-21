module AllpassSecondOrder

export transfer, discontinuity

include("rational.jl")

import Polynomials: Polynomial
import .RationalFunctions: RationalFunction, RationalFunctions

"""Return a second-order discrete-time all-pass transfer function.

The complex `pole` represents a conjugate pole pair, keeping the coefficients
real.  Its angle sets the frequency of the phase rotation and its radius
controls how concentrated that rotation is.
"""
function transfer(pole::ComplexF64)
  # Multiplied by z^2 in numerator and denominator compared to the difference
  # equation definition.
  fraction = RationalFunction(
    Polynomial([1.0, -2.0 * real(pole), abs(pole)^2]),
    Polynomial([abs(pole)^2, -2.0 * real(pole), 1.0])
  )
  z -> RationalFunctions.evaluate(z, fraction)
end

"""Find the discontinuity of the all-pass filter phase response."""
function discontinuity(pole::ComplexF64, sample_rate::Float64)::Float64
  h = transfer(pole)

  start_freq = 26.0
  end_freq = sample_rate / 2 - 1050
  freqs = logrange(start_freq, end_freq, length=500)

  prev = 0.0
  for freq in freqs
    z = cis(2.0 * pi * freq / sample_rate)
    phase_shift = angle(h(z))

    if phase_shift - prev >= pi
      return freq
    end

    prev = phase_shift
  end

  return 0.0
end

end
