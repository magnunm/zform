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

  # Transfer function
  # h = Butterworth.transfer(10, 500.0, sample_rate)
  h = Allpass.transfer(0.9 * cis(pi / 128.0))

  Plotting.bode(h, sample_rate)
end

main()
