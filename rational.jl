module RationalFunctions

export RationalFunction, eval

import Polynomials: Polynomial

struct RationalFunction
  numerator::Polynomial
  denominator::Polynomial
end

function eval(z::ComplexF64, func::RationalFunction)
  func.numerator(z) / func.denominator(z)
end

end
