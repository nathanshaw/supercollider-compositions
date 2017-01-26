s.boot;



MIDIdef


// OSC
// UDP


s.boot;



a.free;
a = {Crackle.ar(1.9) * 0.5}.play;

s.sendMsg(\n_free, 1003);

127.0.0.1 // LOOPBACK
n = NetAddr("10.40.130.236", 57120);


n.sendMsg(\chat, 1004, "blah", "junk");

10.40.130.236


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

