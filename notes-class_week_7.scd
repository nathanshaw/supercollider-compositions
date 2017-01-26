
s.boot;

// Quick Ndef talk

(
	x.free;
	x = {
		SinOsc.ar(260);
	}.play;
)

(
	Ndef(\mySynth, { | freq=250 |
		SinOsc.ar(freq);
	});
)

Ndef(\mySynth).play();
Ndef(\mySynth).stop();

Ndef(\mySynth).gui

(
	Ndef(\sawSynth, { | amp=0, freq=2000 |
		Saw.ar(freq) * amp;
	});

)

Ndef(\sawSynth).play();
Ndef(\sawSynth).gui;
Ndef(\sawSynth).stop();

m = NdefMixer.new(s);

(
	Ndef(\sineControl, {
		SinOsc.kr(1);
	});
)
(
	Ndef(\sineControl, {
		SinOsc.kr(17);
	});
)
(
	Ndef(\sineControl, {
		LFNoise1.kr(16);
	});
)
Ndef(\sineControl).clear
(
	Ndef(\sineControl, {
		LFNoise0.kr(MouseX.kr(1,132));
	});
)


(
	Ndef(\reverb, { | amp=0, freq=2000 |
		FreeVerb.ar(Ndef(\hello).ar + Ndef(\mySynth).ar );
	});

)

Ndef(\reverb).play();
Ndef(\reverb).stop();
(
	Ndef(\hello, { | amp=0, freq=2000 |
		GrainSin.ar(trigger: Impulse.kr(1), freq: freq + (Ndef(\sineControl) * 100) );
		//GrainSin.ar(trigger: Impulse.kr(6), freq: Line.kr(60, 9000, 120) );
		//WhiteNoise.ar() * Pulse.ar(1, width: 0.15) * amp;
	});

)

Ndef(\hello).play(); // MONITOR
Ndef(\hello).stop(); // MUTE

Ndef(\hello).fadeTime = 0;
Ndef(\hello).xset(\freq, 100);
Ndef(\hello).xset(\amp, 0.1);

// Patterns


~reverbOut = Bus.audio(s,2);
(
~reverb.free;
~reverb = {
	var in = In.ar(~reverbOut, 2);
	var out = FreeVerb.ar(in, mix: 0.5, room: 0.5);

	Out.ar(0, out );
}.play;
)

(
	SynthDef(\kik, { | amp=1, freq= 60 |
		var out = (SinOsc.ar([freq, freq*1.1]).clip(-1, 1) * EnvGen.ar(Env.perc(0.01, 0.02), doneAction: 2) * 0.4);

		Out.ar(0, (out * 4).tanh * amp);
	}).store;


	SynthDef(\bass, {

	}).store;

	SynthDef(\dominator, { |freq=440, amp=0.1, gate=1|
		var midfreqs, son, vibamount;

		// Portamento:
		freq = freq.lag(0.2, 0.6);
		// you could alternatively try:
		//  freq = Ramp.kr(freq, 0.2);

		// vibrato doesn't fade in until note is held:
		vibamount = EnvGen.kr(Env([0,0,1],[0.0,0.4], loopNode:1), HPZ1.kr(freq).abs);
		// Vibrato (slightly complicated to allow it to fade in):
		freq = LinXFade2.kr(freq, freq * LFPar.kr(3).exprange(0.98, 1.02), vibamount * 2 - 1);

		// We want to chorus the frequencies to have a period of 0.258 seconds
		// ie freq difference is 0.258.reciprocal == 3.87
		midfreqs = freq + (3.87 * (-2 .. 2));

		// Add some drift to the frequencies so they don't sound so digitally locked in phase:
		midfreqs = midfreqs.collect{|f| f + (LFNoise1.kr(2) * 3) };

		// Now we generate the main sound via Saw oscs:
		son = Saw.ar(midfreqs).sum
		// also add the subharmonic, the pitch-locked bass:
		+ SinOsc.ar(freq * [0.25, 0.5, 0.75], 0, [1, 0.3, 0.2] * 2).sum;

		// As the pitch scoops away, we low-pass filter it to allow the sound to stop without simply gating it
		son = RLPF.ar(son, freq * if(freq < 100, 1, 32).lag(0.01));

		// Add a bit more mid-frequency emphasis to the sound
		son = son + BPF.ar(son, 1000, mul: 0.5) + BPF.ar(son, 3000, mul: 0.3);

		// This envelope mainly exists to allow the synth to free when needed:
		son = son * EnvGen.ar(Env.asr, gate, doneAction:2);

		son = Pan2.ar(son * amp);

		son = FreeVerb.ar(son, room: 1);
		Out.ar(0, son)
	}).store;
)



Pbind // Standard sorta thing. Trigger, multiple instances of a Synth
Pmono // Mono synth

t = TempoClock.new();
t.tempo = 2.0;

(
	Pdef(\kikker,
		Pbind(
			\instrument, \kik,
			\freq, Pseq([50, 60], inf),
			\amp, 1,
			\dur, 1.0
		)
	);
)
Pdef(\kikker).stop();
Pdef(\kikker).play(t);
Pdef(\kikker).fadeTime = 5;

Pdefn(\bassFreqs, Pseq([Pn(150, 8), Pn(160, 8) * 1 ], inf) );
Pdefn(\bassFreqs, Pseq([150,160], inf) * 2 );
Pdefn(\bassMul, 0.5);

(
	Pdef(\bass,
		Pbind(
			\instrument, \kik,
			\dur, 0.25,
			\amp, 0.21,
			\freq, Pdefn(\bassFreqs) * Pdefn(\bassMul)
		)
	);
)

Pdef(\bass).play(t);
Pdef(\bass).stop;


Pdef(\domino,
	Pmono(\dominator,
		\amp, 0.15,
		\dur, 0.5,
		\midinote, Pseq([ 67, 64, 62, 62, 62, 62, 62, 40], inf)
	)
);
Pdef(\domino).play(t);
Pdef(\domino).stop;

(
Dialog.openPanel({ arg path;
	b = Buffer.read(s, path, action: { |buffer|
		"Loaded: ".post;
	});
});

)

(
	SynthDef(\sampler, { |amp=1, rate=1|
		var out = PlayBuf.ar(2, b, rate: rate, loop: 1);
		Out.ar(0, out * amp);
	}).store;
)

Pdefn(\bassMul, 0.15);
(
	Pdef(\samplePattern,
		Pmono(\sampler,
			\rate, Prand([1, 1.1, 6, 0.2, 0.01], inf),
			\amp, 1,
			\dur, Prand([0.1, 1, 0.5], inf) * Pdefn(\bassMul)
		)
	);
)
Pdef(\samplePattern).play;
Pdef(\samplePattern).stop;

(
AppClock.sched(60 * 40, {
	Pdef(\samplePattern).play;
});
)

AppClock.help







(
	SynthDef(\sampler, { | amp=1, rate = 1.1, overdrive = 1 |
		var out = PlayBuf.ar(1, b, rate * LFNoise1.kr(MouseY.kr(0.02,16), mul: 6, add: 0.15), loop: 1);
		Out.ar(~reverbOut, ( out* overdrive ).max!2 * amp * 6);
	}).store;
)


