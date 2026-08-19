module Butterworth

export transfer

include("rational.jl")

import Polynomials: Polynomial
import .RationalFunctions: RationalFunction, RationalFunctions

"""Butterworth polynomial coefficients of a given order (> 0).

Using the product formula from
https://en.m.wikipedia.org/wiki/Butterworth_filter

"""
function butterworth(order::Int)
  gamma = pi / (2.0 * order)
  res = fill(1.0, order + 1)

  # Since a_k = a_(n - k) we only need to iterate to n/2
  # In a 0-indexed language substitute k -> k - 1 inside [...]
  for k = 1:round(Int, order / 2)
    coeff = (cos((k - 1) * gamma) / sin(k * gamma)) * res[k]
    res[k + 1] = coeff
    res[order - k + 1] = coeff
  end
  res
end

function z_to_s_plane(z::ComplexF64, sample_rate::Float64)
  # Bilinear transform from z to s plane
  2.0 * sample_rate * (z - 1) / (z + 1)
end

"""Discrete-time transfer function for a Butterworth filter

With a given order, cutoff in hz and sample rate returns the transfer function
as a function of a single complex variable.

Based on the analog Butterworth filter with transfer function defined in
s-plane from https://en.m.wikipedia.org/wiki/Butterworth_filter. To turn into
an equivalent digital filter we apply a bilinear transform. Do the same
analytically to get the difference equation coefficients for an implementation.

"""
function transfer(order::Int, cutoff::Float64, sample_rate::Float64)
  fraction = RationalFunction(Polynomial([1.0]), Polynomial(butterworth(order)))
  cutoff_omega = cutoff * 2.0 * pi
  z -> RationalFunctions.evaluate(z_to_s_plane(z, sample_rate) ./ cutoff_omega, fraction)
end

end
