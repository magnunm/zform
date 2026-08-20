module LowPassBiquad

export transfer

include("rational.jl")

import Polynomials: Polynomial
import .RationalFunctions: RationalFunction, RationalFunctions

"""Discrete-time resonant low-pass biquad.

`frequency` is the cutoff frequency in Hz, `q` controls the resonance, and
`sample_rate` is in Hz. Values of `q` above approximately 0.707 produce a
peak near the cutoff frequency.
"""
function transfer(frequency::Float64, q::Float64, sample_rate::Float64)
  0.0 < frequency < sample_rate / 2 ||
    throw(ArgumentError("frequency must be between zero and the Nyquist frequency"))
  q > 0.0 || throw(ArgumentError("q must be positive"))

  omega = 2.0 * pi * frequency / sample_rate
  alpha = sin(omega) / (2.0 * q)
  cosine = cos(omega)
  a0 = 1.0 + alpha

  b0 = (1.0 - cosine) / (2.0 * a0)
  b1 = (1.0 - cosine) / a0
  b2 = b0
  a1 = -2.0 * cosine / a0
  a2 = (1.0 - alpha) / a0

  fraction = RationalFunction(
    Polynomial([b2, b1, b0]),
    Polynomial([a2, a1, 1.0]),
  )
  z -> RationalFunctions.evaluate(z, fraction)
end

end
