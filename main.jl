using Plots

struct DifferenceEquation
  feedforward_coeffs::Vector{Float64}  # Length N
  feedback_coeffs::Vector{Float64}  # Length N (first is always 1)
end

function polynomial(z::ComplexF64, coeffs::Vector{Float64})
  sum(i -> coeffs[i] * z ^ (i - 1), eachindex(coeffs))
end

# This also works for analog filters in the s-plane
function transfer_function(z::ComplexF64, de::DifferenceEquation)
  numerator = polynomial(z, reverse(de.feedforward_coeffs))
  denominator = polynomial(z, reverse(de.feedback_coeffs))
  return numerator / denominator
end

# Bilinear transform from z to s plane
function z_to_s_plane(z::ComplexF64, sample_rate::Float64)
  return 2.0 * sample_rate * (z - 1) / (z + 1)
end

function db(gain::Float64)
  10 * log(10, gain)
end

function rad_to_deg(angle::Float64)
  (180 * angle) / pi
end

function main()
  # Typical sample rate for audio
  sample_rate = 44100.0

  # Around (sample rate / 2) the analysis breaks down and we get strange results
  # so end before that.
  start_freq = 26.0
  end_freq = sample_rate / 2 - 1050

  # TODO: This is supposed to be third order Butterworth, so something is not correct.
  # Maybe because this was taken from the analog version?

  # Analog Butterworth filter with transfer function defined in s-plane
  # From https://en.m.wikipedia.org/wiki/Butterworth_filter
  # To turn into digital filter difference equation apply bilinear transform analytically.
  #
  # Third order
  # de_butter_s = DifferenceEquation([1.0], [1.0, 2.0, 2.0, 1.0])
  #
  # Tenth order
  # TODO: Generate the coefficients
  # TODO: Find the difference equation for the discrete time variant after applying
  #       bilinear transform.
  de_butter_s_order_10 = DifferenceEquation([1.0], [1.0, 6.3925, 20.4317, 42.8021, 64.8824, 74.2334, 64.8824, 42.8021, 20.4317, 6.3925, 1.0])

  # The substitution s -> s / omega_c gives a Butterworth with a given cutoff freq
  cutoff_freq = 740.0
  cutoff_omega = cutoff_freq * 2.0 * pi

  h = z -> transfer_function(z_to_s_plane(z, sample_rate) ./ cutoff_omega, de_butter_s_order_10)

  # Frequencies are perceived logarithmically
  freqs = logrange(start_freq, end_freq, length=500)
  freqs_in_z_domain = freqs ./ sample_rate
  zs = map(f -> cis(2.0 * pi * f), freqs_in_z_domain)
  hs = h.(zs)

  gains = abs.(hs)
  phase_shifts = angle.(hs)

  gain_plot = plot(
    freqs,
    db.(gains),
    xscale=:log10,
    minorgrid=true,
    xticks=logrange(start_freq, end_freq, length=5),
    xformatter=x -> string(round(Int, x)),
    ylabel="Gain (dB)"
  )
  phase_plot = plot(
    freqs,
    rad_to_deg.(phase_shifts),
    xscale=:log10,
    minorgrid=true,
    ylims=(-180, 180),
    yticks=range(-180, 180, length=5),
    xticks=logrange(start_freq, end_freq, length=5),
    xformatter=x -> string(round(Int, x)),
    ylabel="Phase Shift (degrees)",
    xlabel="Frequency"
  )

  plot(gain_plot, phase_plot, layout=(2, 1), legend=false)

  # Switch to SVG for better scalability of graphic
  savefig("plot.png")
end

main()
