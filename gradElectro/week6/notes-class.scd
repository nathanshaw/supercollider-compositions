
s.boot;


~reverbBus = Bus.audio(s,2);
(
SynthDef(\ringMod, { | freq=600, gate=1, pan=0 |
	var out;

	var modulator = SinOsc.ar([20, 20*1.1]).unipolar * 200;
	var carrier = SinOsc.ar(freq + modulator);

	out = carrier * EnvGen.ar(Env.asr(0.001, 0.5, 0.25), gate: gate, doneAction:2);
	out = Pan2.ar(out, pan);

	Out.ar(~reverbBus, out * 0.45);

}).add;
)
(
	~reverb = {
		Out.ar(0, In.ar(~reverbBus,2) );
	}.play;
)

x = Synth(\ringMod);
x.set(\gate, 0);
x.free;
s.meter;



// Patterns
// Pbind
Pbind.help

// Pseq
a = Pseq([220, 150, 432], inf).asStream();
a = Pseries(start: 0, step: 2, length: inf).asStream();

a.next()

Pdefn(\durations, Prand([0.1, 1, 0.5], inf) * 0.1 );
// Pbind
(
	// Creates an Event that is played
	Pdef(\hello,
		Pbind(
			\instrument, \ringMod,
			\midinote, Pseq([60, 63, 67, Prand([120, 40], inf) ], inf) * Pseq([1,2],inf),
			\dur, Pdefn(\durations)
		)
	);
)

Pdef(\hello).play;
Pdef(\hello).stop;

x = {
	SinOsc.ar(220) * 0.6;
};

	Ndef(\otherSynth).clear;
(
	Ndef(\otherSynth, {
		SinOsc.ar([ 120, 120 ]) * SinOsc.ar(2) * 0.9;
	});

)

Ndef(\otherSynth).play();
Ndef(\otherSynth).stop();
