include("butterworth.jl")

import Plots
import Polynomials: Polynomial

import .Butterworth

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

  # Transfer function
  h = Butterworth.transfer(10, 500.0, sample_rate)

  # Frequencies are perceived logarithmically
  freqs = logrange(start_freq, end_freq, length=500)
  freqs_in_z_domain = freqs ./ sample_rate
  zs = map(f -> cis(2.0 * pi * f), freqs_in_z_domain)
  hs = h.(zs)

  gains = abs.(hs)
  phase_shifts = angle.(hs)

  gain_plot = Plots.plot(
    freqs,
    db.(gains),
    xscale=:log10,
    minorgrid=true,
    xticks=logrange(start_freq, end_freq, length=5),
    xformatter=x -> string(round(Int, x)),
    ylabel="Gain (dB)"
  )
  phase_plot = Plots.plot(
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

  Plots.plot(gain_plot, phase_plot, layout=(2, 1), legend=false)

  # Switch to SVG for better scalability of graphic
  Plots.savefig("plot.png")
end

main()
