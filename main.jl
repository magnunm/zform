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
  de = DifferenceEquation([1.0, 0.8, 0.5], [1.0, 0.2, 0.45])
  h = z -> transfer_function(z, de)

  freqs = range(0.0, 1.0, length=200)
  zs = map(f -> cis(2.0 * pi * f), freqs)
  hs = h.(zs)

  gains = abs.(hs)
  phase_shifts = angle.(hs)

  gain_plot = plot(freqs, gains, ylabel="Gain")
  phase_plot = plot(freqs, phase_shifts, ylabel="Phase Shift", xlabel="Frequency")

  plot(gain_plot, phase_plot, layout=(2, 1))

  savefig("plot.png")
end

main()
