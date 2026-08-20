module RationalFunctions

export RationalFunction, evaluate

import Polynomials: Polynomial

struct RationalFunction
  numerator::Polynomial
  denominator::Polynomial
end

function evaluate(z::ComplexF64, func::RationalFunction)
  func.numerator(z) / func.denominator(z)
end

end
