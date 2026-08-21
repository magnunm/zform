# Zform

Some simple Julia scripts to analyze and plot the behaviour of different
digital filters.

## Run

Install dependencies:
```
julia --project=.
```

Then in the repl press `]` to go to `pkg` and then:

```
instantiate
```

Or `update` to update deps.

Run the script with:

```
julia --project=. main.jl
```

## Example plots

### First-order all-pass filter

![First-order all-pass Bode plot](plots/allpass_first_order.png)

### Second-order all-pass filter

![Second-order all-pass Bode plot](plots/allpass_second_order.png)

### First-order all-pass phaser

![First-order all-pass phaser Bode plot](plots/phaser_first_order.png)

### Second-order all-pass phaser

![Second-order all-pass phaser Bode plot](plots/phaser_second_order.png)

### Band-pass filter

![Band-pass Bode plot](plots/bandpass.png)

### Resonant low-pass biquad

![Resonant low-pass biquad Bode plot](plots/low_pass_biquad.png)

### Butterworth low-pass filter

![Butterworth low-pass Bode plot](plots/low_pass_butterworth.png)

### All-pass pole discontinuity

![All-pass pole discontinuity plot](plots/pole_to_discontinutiy.png)
