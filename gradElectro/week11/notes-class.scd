s.boot;
s.quit;

NetAddr.langPort

MIDIdef


// OSC
// UDP


s.boot;



a.free;
a = {Crackle.ar(1.9) * 0.5}.play;

n.sendMsg(\n_free, 1024);

127.0.0.1 // LOOPBACK
n = NetAddr("10.40.130.236", 57120);

10.40.130.236

n.sendMsg(\chat, "hello", "blah");

10.40.130.236



(
	OSCdef(\class, { |  msg, time, addr,recvPort |
		msg.postln;

		~sineyScale = msg[1].asFloat;


	}, \chat);
)


// 57120
// 57110
(
	Ndef(\listener, {
		//var noise = LFNoise1.kr(3);
		var audioIn = SoundIn.ar(0);
		var hasPitch, freq;

		# freq, hasPitch = Pitch.kr(audioIn);

		SendReply.kr(Impulse.kr(55), '/pitch', audioIn);
		//SendTrig
		
	});
)

(
	OSCdef(\listenerThing, { |msg |
		var freq = msg[3].asFloat,
			modFreq = 12;
			msg.postln;

			if(freq < 1000, {

				{ SinOsc.ar(freq * Saw.ar(modFreq, mul:100) ) * 0.2
				* EnvGen.ar(Env.perc(0.1, 0.25), doneAction: 2)
			}.play;
		});

	}, '/pitch');
)

OSCdef.help
(
	// Lives on sclang (port 57120)
	OSCdef(\receiverThing, { | msg |
		var freq, modFreq;

		msg.postln;
		freq = msg[1].asFloat;
		modFreq = msg[2].asFloat;

		{ SinOsc.ar(freq * Saw.ar(modFreq, mul:100) ) * 0.2
			* EnvGen.ar(Env.perc(0.1, 3), doneAction: 2)
		}.play;
	}, \chat);
)


~sineyVolBus = Bus.control(s, 1);




~sineyVol = 0;
~sineyScale = 1;

// MIDI
MIDIClient.init;
MIDIIn.connectAll;

~midiDevice = MIDIOut.newByName("DS1-DS1 MIDI 1", "DS1-DS1 MIDI 1");

(
MIDIdef.cc(\livid, { | val, num, chan, src |
	var scaledVal = val/127;
	[val, num, chan, src].postln;

	switch( num,
		1, {
			Ndef(\sine).set(\freq, val);
			~sineyScale = (scaledVal * 5) + 0.1;
		},
		41, {
			//Ndef(\sine).set(\amp, (val/127)**3 );
			//~sineyVol = scaledVal;
			~sineyVolBus.set(scaledVal);
		}

	);
});
)


(
	Ndef(\sine, { | amp=0, freq=12 |
		SinOsc.ar(600 + SinOsc.kr(freq, mul: 500).unipolar) * Lag.kr(amp, 0.2);
	});

)

Ndef(\sine).play();
Ndef(\sine).stop(0);
Ndef(\sine).xset();



(
	SynthDef(\siney, {| amp=0, freq=12 |
		var out = SinOsc.ar(600 + SinOsc.kr(freq, mul: [ 500, 505 ]).unipolar) * Lag.kr(amp, 0.2);

		Out.ar(0, out * In.kr(~sineyVolBus));
	}).add;
)


(
	Pdef(\sineyPlayer,
		Pmono(\siney,
			\freq, Pseq([600, 700, 1350], inf) * Pfunc({~sineyScaleScott}) * Pfunc({~sineyScale}),
			\dur, Pfunc({~sineyDur}),
			\amp, 1;
		)
	);
)
Pdef(\sineyPlayer).play;
Pdef(\sineyPlayer).stop;

~sineyScaleScott = 4;
~sineyDur = 0.25;

(
	Tdef(\durThing, {

		{
			if(0.5.coin, {
				~sineyDur = 1;
			},
			{
				~sineyDur = 0.1;
			});

			"BEFORE GET".postln;
			~sineyVolBus.get({ | val |
				// POLLING
				val.postln;
				n.sendMsg(\processingMessage, val);
			});
			"AFTER GET".postln;
			"----------------------".postln;

			0.25.wait;
		}.loop;
	});
)

Tdef(\durThing).play;
Tdef(\durThing).stop;


