// Routines (timing and things like that)

// Synth arguments and SynthDefs
s.boot
s.meter
f = {arg freq=600, amp=0;

		SinOsc.ar(freq * (2.0).rand() ) * amp;
	};
(
	x.free;
	x = {arg freq=600, amp=0;

		SinOsc.ar(freq) * amp;
	}.play;
)

x.set(\freq, 200, \amp, 0.0);


// SynthDefs
(
	SynthDef(\ampModSynth, { arg freq=300;
		var freqRand = 200;

		var sine = SinOsc.ar(freq);
		var ampMod = LFTri.ar(2);


		Out.ar([0,1], sine * ampMod * 0.2);
	}).add();
)

(
	~sineSynth.free;
	~sineSynth = Synth(\ampModSynth);
)
(
	~sineSynth2.free;
	~sineSynth2 = Synth(\ampModSynth);
)
~sineSynth2.set(\freq, 500);
Synth.help
s.queryAllNodes

// TYPES
floats
integers
strings
symbols

p = ();
p[\hello] = 3l;
(
f = { arg something;
	something.postln;
};
)

f.value("popo");
f.value("momo");



// Routines - Routines are "yieldable" functions/streams
TempoClock
(
x = Routine({
	{
		{SinOsc.ar(200.0.rand+200) * EnvGen.ar(Env.perc(0.1,0.3), doneAction: 2) * 0.2 }.play;
		1.0.wait;
	}.loop();
});
)

x.play();

(
	y.free;
	y = {SinOsc.ar(x.next())}.play;
)




