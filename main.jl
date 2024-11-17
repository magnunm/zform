include("butterworth.jl")
include("plotting.jl")

import Plots
import Polynomials: Polynomial

import .Butterworth
import .Plotting

function main()
  sample_rate = 44100.0

  # Transfer function
  h = Butterworth.transfer(10, 500.0, sample_rate)

  Plotting.bode(h, sample_rate)
end

main()
