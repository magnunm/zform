module Phaser

export transfer

"""Return the transfer function of a dry/wet phaser.

`stages` contains the all-pass transfer functions to evaluate in series.  The
resulting chain is mixed with the original signal, producing notches where its
phase shift causes cancellation with the dry signal.  `feedback` feeds the wet
signal back through the chain; it must have an absolute value less than one for
the feedback loop to remain stable.
"""
function transfer(
  stages::AbstractVector{<:Function};
  mix::Float64=0.5,
  feedback::Float64=0.0,
)
  0.0 <= mix <= 1.0 || throw(ArgumentError("mix must be between 0 and 1"))
  abs(feedback) < 1.0 || throw(ArgumentError("feedback must be between -1 and 1"))

  z -> begin
    allpass_chain = prod(stage(z) for stage in stages)
    wet = allpass_chain / (1.0 - feedback * allpass_chain)
    (1.0 - mix) + mix * wet
  end
end

end
