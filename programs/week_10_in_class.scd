// MIDI

MIDIClient.init();


MIDIIn.connectAll;

~mididDevice = MIDIOut.newByName("IAC Driver", "Moppy Bus 1");

(
MIDIdef.cc (\MoppyDrive1,
	{ |val,  num, chan, src |
		[val,  num, chan, src].postln;

		switch(num,
			1, {Ndef(\sine).set(\freq, val* 10);},
			41, {Ndef(\sine).set(\freq, val/127);},



		);

	}
);

)

(
Ndef(\sine, ( |amp=0, freq=2432|
	SinOsc.ar(600 + SinOsc.kr(freq, mul:500).unipolar) * 0.34;
)
)
)


Ndef(\sine,).play();
Ndef(\sine,).stop();
Ndef(\sine,).xset();

	(
SynthDef(\siney, { |amp=0, freq=2432|
	var out = SinOsc.ar(600 + SinOsc.kr(freq, mul:500).unipolar) * 0.34;

			out.ar(0, out);
		}).add;

		Pdef(\sineyPlayer,
			Pmono(\siney,
				\freq, pSeq([600, 700, 1350,], inf),
				\dur, Pchoose([1, 0.25], inf)
			)
		);
	)

	Pdef(\sineyPlayer).play;

			)
		);
			)