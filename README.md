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

### All-pass filter

![All-pass Bode plot](allpass.png)

### Band-pass filter

![Band-pass Bode plot](bandpass.png)

### Resonant low-pass biquad

![Resonant low-pass biquad Bode plot](low_pass_biquad.png)

### All-pass pole discontinuity

![All-pass pole discontinuity plot](pole_to_discontinutiy.png)
