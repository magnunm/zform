module Allpass

export transfer, discontinuity

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
  z -> RationalFunctions.evaluate(z, fraction)
end

"""Find the discontinuity of the allpass filter phase response.

The allpass filter in this module has a discontinuous jump from -180 to 180 at
some frequency determined by the pole of the filter. Find the location of that
jump for a given pole.

"""
function discontinuity(pole::ComplexF64, sample_rate::Float64)::Float64
  h = transfer(pole)

  start_freq = 26.0
  end_freq = sample_rate / 2 - 1050
  freqs = logrange(start_freq, end_freq, length=500)

  prev = 0.0
  for freq in freqs
    freq_z_domain = freq / sample_rate
    z = cis(2.0 * pi * freq_z_domain)
    phase_shift = angle(h(z))

    if phase_shift - prev >= pi
      return freq
    end

    prev = phase_shift
  end

  return 0.0
end

end
