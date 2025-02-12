// Create the pluck SynthDef
(
SynthDef("pluck", {arg amp = 0.1, freq = 440, decay = 5, mutedString = 0.1, rate = 1, delay = 0.1, reverbAmount = 0.5;
    var env, snd, trig, reverb;

    // Generate continuous trigger for infinite plucking
    trig = Impulse.kr(rate);  // Constant impulse for infinite triggering

    env = Env.linen(0, decay, 0).kr(doneAction: 2);  // Envelope

    snd = Pluck.ar(
        in: WhiteNoise.ar(amp),  // White noise as the input
        trig: trig,  // Continuous trigger from Impulse.kr
        maxdelaytime: 0.5,
        delaytime: freq.reciprocal + delay,  // Add the delay parameter here
        decaytime: decay,
        coef: mutedString
    );

    // Apply reverb to the pluck sound
    reverb = FreeVerb.ar(snd, reverbAmount, reverbAmount, 0.5);  // Reverb UGen

    // Output the sound
    Out.ar(0, [reverb, reverb]);  // Send the reverb sound to the output
}).add;
)

// Create a NodeProxy for the GUI and audio interaction
~np = NodeProxy.audio(s, 2);

// Create a GUI with sliders to control parameters
(
~np[0] = {|amp=0.1, freq=440, decay = 1000, mutedString=0.1, rate=1, delay=0.1, reverbAmount=0.5|
    var snd, env, trig, reverb;

    // Generate continuous trigger for infinite plucking
    trig = Impulse.kr(rate);  // Continuous impulse

    // Create the pluck SynthDef signal
    env = Env.linen(0, decay, 0).kr(doneAction: 2);  // Envelope
    snd = Pluck.ar(
        in: WhiteNoise.ar(amp),
        trig: trig,  // Continuous trigger from Impulse.kr
        maxdelaytime: 0.5,
        delaytime: freq.reciprocal + delay,  // Add the delay parameter here
        decaytime: decay,
        coef: mutedString
    );

    // Apply reverb to the pluck sound
    reverb = FreeVerb.ar(snd, reverbAmount, reverbAmount, 0.5);  // Reverb UGen

    // Output the sound
    Out.ar(0, [reverb, reverb]);  // Send the reverb sound to the output
};
)

// Create a GUI to control the parameters
~gui = ~np.gui;

(
    // Add sliders for interactive control
    ~gui.addControl(\amp, Slider, 0.0, 1.0, \default, 0.1); // slider for amplitude (volume)
    ~gui.addControl(\freq, Slider, 100, 1000, \default, 440); // slider for frequency (pitch)
    ~gui.addControl(\decay, Slider, 0.1, 10, \default, 5); // slider for decay time
    ~gui.addControl(\mutedString, Slider, 0.0, 1.0, \default, 0.1); // slider for mutedString (muting effect on pluck)
    ~gui.addControl(\rate, Slider, 0.1, 10, \default, 1); // slider for rate (how fast the pluck repeats)
    ~gui.addControl(\delay, Slider, 0.0, 1.0, \default, 0.1); // slider for delay time after pluck
    ~gui.addControl(\reverbAmount, Slider, 0.0, 1.0, \default, 0.5); // slider for reverb amount (wet/dry mix)
)