module Plotting

export bode

import Plots

function db(gain::Float64)
  20 * log(10, gain)
end

function rad_to_deg(angle::Float64)
  (180 * angle) / pi
end

"""Bode plot for a discrete time transfer function.

Plot the gain and phase response as a function of frequency for a given
transfer function in the z-domain. The transfer function is a complex function
of a single complex variable.

"""
function bode(
  transfer::Function,
  sample_rate::Float64,
  filename::String=joinpath(@__DIR__, "..", "plots", "plot.png"),
)
  # Around (sample rate / 2) the analysis breaks down and we get strange results
  # so end before that.
  start_freq = 26.0
  end_freq = sample_rate / 2 - 1050

  # Frequencies are perceived logarithmically
  freqs = logrange(start_freq, end_freq, length=500)
  freqs_in_z_domain = freqs ./ sample_rate
  zs = map(f -> cis(2.0 * pi * f), freqs_in_z_domain)
  hs = transfer.(zs)

  gains = abs.(hs)
  gains_db = db.(gains)
  phase_shifts = angle.(hs)

  # An all-pass filter has an exactly flat gain response.  Floating-point
  # round-off leaves a tiny non-zero range, which is too narrow for GR to
  # auto-scale reliably, so give every gain plot a sensible minimum padding.
  minimum_gain = minimum(gains_db)
  maximum_gain = maximum(gains_db)
  gain_padding = max(1.0, 0.1 * (maximum_gain - minimum_gain))

  gain_plot = Plots.plot(
    freqs,
    gains_db,
    xscale=:log10,
    minorgrid=true,
    xticks=logrange(start_freq, end_freq, length=5),
    xformatter=x -> string(round(Int, x)),
    ylabel="Gain (dB)",
    ylims=(minimum_gain - gain_padding, maximum_gain + gain_padding),
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

  Plots.plot(
    gain_plot,
    phase_plot,
    layout=(2, 1),
    legend=false,
    size=(800, 600),
    left_margin=12Plots.mm,
    bottom_margin=10Plots.mm,
  )

  # Switch to SVG for better scalability of graphic
  Plots.savefig(filename)
end

end
