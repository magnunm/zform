include("src/allpass_first_order.jl")
include("src/allpass_second_order.jl")
include("src/bandpass.jl")
include("src/low_pass_butterworth.jl")
include("src/low_pass_biquad.jl")
include("src/phaser.jl")
include("src/plotting.jl")

import Plots
import Polynomials: Polynomial

import .AllpassFirstOrder
import .AllpassSecondOrder
import .Bandpass
import .LowPassButterworth
import .LowPassBiquad
import .Phaser
import .Plotting

function plot_pole_to_discontinuity()
  sample_rate = 44100.0

  f = v -> AllpassSecondOrder.discontinuity(v, sample_rate)

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

  Plots.savefig("plots/pole_to_discontinutiy.png")
end

function main()
  sample_rate = 44100.0

  plot_pole_to_discontinuity()

  second_order_pole = 0.9 * cis(pi / 128.0)
  second_order_allpass = AllpassSecondOrder.transfer(second_order_pole)
  phase_shift_frequency = AllpassSecondOrder.discontinuity(
    second_order_pole,
    sample_rate,
  )

  # A first-order all-pass reaches -90 degrees at this coefficient.  Matching
  # that midpoint to the second-order phase discontinuity aligns their visible
  # phase rotations in the Bode plots.
  first_order_coefficient = -tan(pi / 4.0 - pi * phase_shift_frequency / sample_rate)
  first_order_allpass = AllpassFirstOrder.transfer(first_order_coefficient)

  phaser_frequencies = [250.0, 500.0, 1000.0, 2000.0]
  first_order_coefficients = -tan.(pi / 4.0 .- pi .* phaser_frequencies ./ sample_rate)
  first_order_stages = AllpassFirstOrder.transfer.(first_order_coefficients)
  second_order_poles = ComplexF64.(0.9 .* cis.(2.0 * pi .* phaser_frequencies ./ sample_rate))
  second_order_stages = AllpassSecondOrder.transfer.(second_order_poles)
  first_order_phaser = Phaser.transfer(first_order_stages, mix=0.5, feedback=0.3)
  second_order_phaser = Phaser.transfer(second_order_stages, mix=0.5, feedback=0.3)
  bandpass_transfer = Bandpass.transfer(700.0, 20.0, sample_rate)
  low_pass_transfer = LowPassBiquad.transfer(700.0, 50.0, sample_rate)
  butterworth_transfer = LowPassButterworth.transfer(10, 500.0, sample_rate)

  Plotting.bode(first_order_allpass, sample_rate, "plots/allpass_first_order.png")
  Plotting.bode(second_order_allpass, sample_rate, "plots/allpass_second_order.png")
  Plotting.bode(first_order_phaser, sample_rate, "plots/phaser_first_order.png")
  Plotting.bode(second_order_phaser, sample_rate, "plots/phaser_second_order.png")
  Plotting.bode(bandpass_transfer, sample_rate, "plots/bandpass.png")
  Plotting.bode(low_pass_transfer, sample_rate, "plots/low_pass_biquad.png")
  Plotting.bode(butterworth_transfer, sample_rate, "plots/low_pass_butterworth.png")
end

main()
