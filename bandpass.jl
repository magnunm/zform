module Bandpass

export transfer, poles, q_stability_ranges

include("rational.jl")

import Polynomials: Polynomial
import .RationalFunctions: RationalFunction, RationalFunctions

"""Return the pole radius for a center `frequency` in Hz and quality factor `q`."""
function radius(frequency::Float64, q::Float64, sample_rate::Float64)
  q > 0.0 || throw(ArgumentError("q must be positive"))
  sample_rate > 0.0 || throw(ArgumentError("sample_rate must be positive"))

  exp(-pi * frequency / (q * sample_rate))
end

"""Discrete-time band-pass transfer function centered at `frequency` in Hz.

The denominator is

`1 - 2r * cos(theta) * z^-1 + r^2 * z^-2`,

where `theta = 2pi * frequency / sample_rate` and
`r = exp(-pi * frequency / (q * sample_rate))`. This places the poles at the
requested frequency; `q` controls their distance from the unit circle.

This bandpass is stable across all positive freq and q
"""
function transfer(frequency::Float64, q::Float64, sample_rate::Float64)
  theta = 2.0 * pi * frequency / sample_rate
  r = radius(frequency, q, sample_rate)
  gain = (1.0 - r) / 2.0
  numerator = Polynomial([-gain, 0.0, gain])
  denominator = Polynomial([r^2, -2.0 * r * cos(theta), 1.0])
  fraction = RationalFunction(numerator, denominator)

  z -> RationalFunctions.evaluate(z, fraction)
end

end
