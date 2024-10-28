using Plots

struct DifferenceEquation
  feedforward_coeffs::Vector{Float64}  # Length N
  feedback_coeffs::Vector{Float64}  # Length N (first is always 1)
end

function polynomial(z::ComplexF64, coeffs::Vector{Float64})
  sum(i -> coeffs[i] * z ^ (i - 1), eachindex(coeffs))
end

function transfer_function(z::ComplexF64, de::DifferenceEquation)
  numerator = polynomial(z, reverse(de.feedforward_coeffs))
  denominator = polynomial(z, reverse(de.feedback_coeffs))
  return numerator / denominator
end

function main()
  de = DifferenceEquation([0.1, 0.2], [1.0, 0.5])
  tf = z -> transfer_function(z, de)

  zs = complex(range(-10, 10, length=200))
  plot(real.(zs), [real.(tf.(zs)), imag.(tf.(zs))])

  savefig("plot.png")
end

main()
