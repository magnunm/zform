include("allpass.jl")
include("butterworth.jl")
include("plotting.jl")

import Plots
import Polynomials: Polynomial

import .Allpass
import .Butterworth
import .Plotting

function main()
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

main()
