s.boot();

// Quick Ndef talk

(
x.free();
x = {
	SinOsc.ar(220);
}.play();

)
(
Ndef(\mySynth, { |freq = 240|
	SinOsc.ar(freq);
});
)


Ndef(\mySynth).play();
Ndef(\mySynth).stop();
Ndef(\mySynth).gui();

(
Ndef(\sawSynth, { |amp=0.5, freq=200|
	Saw.ar(freq) * amp;
});

Ndef(\sawSynth).fadeTime = 10;

)

Ndef(\sawSynth).play(100);
Ndef(\sawSynth).stop(10);
Ndef(\sawSynth).gui();
Ndef(\sawSynth).set(\freq, 300.rand + 100);
Ndef(\sawSynth).xset(\freq, 900);

(

Ndef(\gainSynth, { |amp=0, freq=500|
	GrainSin.ar(trigger: Impulse.kr(2), freq:freq + (Ndef(\sineControl) * 100));
});
)

Ndef(\grainSynth).play(); // Monitor
Ndef(\grainSynth).stop(20); //Mute
Ndef(\grainSynth).gui();

m = NdefMixer.new(s);
(
Ndef(\sineControl).clear();
Ndef(\sineControl, {
	SinOsc.kr(130);
});
)
(
Ndef(\sineControl, {
	SinOsc.kr(7);
});
)
(
Ndef(\sineControl, {
	SinOsc.kr(LFNoise1.kr(16));
});
)


Ndef(\reverb, { |amp = 0.5, freq=200|
	FreeVerb.ar(Ndef(\sawSynth).ar);
});

Ndef(\reverb).play(); // Monitor
Ndef(\reverb).stop(0); //Mute
Ndef(\reverb).gui();

// Patterns

~reverbOut = Bus.audio(s, 2);

(
~reverb.free();
~reverb = {
	var in = In.ar(~reverbOut, 2);
	var out = FreeVerb.ar(in, mix: 0.5, room: 0.5);

	Out.ar(0, out);
}).play();


(
SynthDef(\kick, {|amp=1, freq = 120|
	var out = (SinOsc.ar([freq, freq*1.1].clip(-1,1) * EnvGen.ar(Env.perc(0.1, 0.2), doneAction: 2)* 0.8));
		Out.ar(0, (out * 4).tanh * amp);
	}).store;

)

Pbind // can trigger multiple instances of a synth
PMono // mono synth

t = TempoClock.new();
t.tempo = 120/60;

(
a.stop();
a = Pbind(
	\instrument, \kick,
	\freq, Pseq([50, 75, 200, 400, 323], inf),
	\amp, 1,
	\dur, 1/4
).play;
)

(
    Pdef(\kicker,
	    Pbind(
		    \instrument, \kick,
		    \freq, Pseq([60, 300, 2323, 200], inf),
		    \amp, 1,
		    \dur, 1/4
	    )
    );
)
Pdef(\kicker).stop()
Pdef(\kicker).play();

Pdefn(\bassFreqs, Pseq([Pn(150, 8), 400, 3000, 100], inf ));
(
Pdef(\bass,
	Pbind(
		\instrument, \kicker,
		\dur, 1/2,
		\freq, Pdefn(\bassFreqs)
	)
);
)

Pdef(\bass).play(t);
Pdef(\bass).stop();



// Buffer stuff with paterns

(
Dialog.openPanel
)

(
    SynthDef(\sampler,{|amp=2, rate=1|
	    var out = PlayBuf.ar(2, b, rate:1, loop:1);
	    Out.ar(0, out * amp);
    }).store;
)

(
Pdef(\samplePattern,
	Pmono(\sampler,
		\rate, Prand([1, 1.2, 6, 0.2], inf),
		\amp, 1
	)
);
)