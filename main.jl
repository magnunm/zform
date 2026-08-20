include("allpass.jl")
include("bandpass.jl")
include("butterworth.jl")
include("low_pass_biquad.jl")
include("plotting.jl")

import Plots
import Polynomials: Polynomial

import .Allpass
import .Bandpass
import .Butterworth
import .LowPassBiquad
import .Plotting

function plot_pole_to_discontinuity()
  sample_rate = 44100.0

  f = v -> Allpass.discontinuity(v, sample_rate)

  absolute_values = range(0.6, 0.99, length=200)
  angles = range(pi / 10000.0, pi / 4.0, length=200)

  plot1 = Plots.plot(
    absolute_values,
    f.(absolute_values .* cis(pi / 128.0)),
    minorgrid=true,
    xlabel="abs(pole)",
    ylabel="Freq",
  )
  plot2 = Plots.plot(
    angles,
    f.(0.9 * cis.(angles)),
    minorgrid=true,
    xlabel="angle(pole)",
    ylabel="Freq",
  )
  Plots.plot(plot1, plot2, layout=(2, 1), legend=false)

  Plots.savefig("pole_to_discontinutiy.png")
end

function main()
  sample_rate = 44100.0

  plot_pole_to_discontinuity()

  allpass_transfer = Allpass.transfer(0.9 * cis(pi / 128.0))
  bandpass_transfer = Bandpass.transfer(700.0, 20.0, sample_rate)
  low_pass_transfer = LowPassBiquad.transfer(700.0, 50.0, sample_rate)
  Plotting.bode(allpass_transfer, sample_rate)
  Plotting.bode(bandpass_transfer, sample_rate, "bandpass.png")
  Plotting.bode(low_pass_transfer, sample_rate, "low_pass_biquad.png")
end

main()
