s.boot;

(
Dialog.openPanel({ arg path;
	b = Buffer.read(s, path, action: { |buffer| 
		"".postln;
		"Loaded: ".post;
		path.postln;
		"Channels: ".post;
		buffer.numChannels.postln;
	});
});
)

(
	b.loadToFloatArray(action: { | floatArray |
		var scrambledCollection = floatArray.clump(floatArray.size/20).scramble.flatten;

		b = Buffer.loadCollection(s, scrambledCollection, numChannels: 2, action: {
			"LOADED!".postln;
		});
	});

)
c.size/3.2
c.plot
c = c.clump(c.size/3).scramble.flatten;
c



[1, 2, 3, 4, 5, 6, 7].clump().postcs;

(
	Ndef(\bufferPlayer, { | amp=0.5, rate=2 |
		var sig = PlayBuf.ar(b.numChannels, b, rate, loop: 1);

		sig * amp;
	});

)

Ndef(\bufferPlayer).play();
Ndef(\bufferPlayer).stop();


x.free;
x = {SinOsc.ar(200, mul: 3).abs}.plot;
Quarks.gui

