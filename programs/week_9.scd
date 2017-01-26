
s.boot;

//buffer live on the server

(
Dialog.openPanel({ arg path;
	b = Buffer.read(s, path, action: { |buffer|
		"".postln();
		"Loaded: ".post;
		path.postln;
		"Channels: ".post;
		buffer.numChannels.postln;
	});

});
)

(
// we can't have buffers on SClang we can only store them in float buffers
b.loadToFloatArray(action: { | floatArray |
	var scrambledCollection = floatArray.clump(floatArray.size/1000).scramble.flatten();
	b = Buffer.loadCollection(s, scrambledCollection, numChannels:2, action:{
	"LOADED!".postln;
	});
});

)

b.plot();
b.size();

(
Ndef(\bufferPlayer, { | amp=0.5, rate= 0.225 |
	var sig = PlayBuf.ar(b.numChannels, b, rate, loop:1);
	sig*amp;
});
)

Ndef(\bufferPlayer).play();
Ndef(\bufferPlayer).stop();

Quarks.gui;

x = {SinOsc.ar(200)}.plot;
x.stop();
y = {LFTri.ar(200).tanh}.scope();
y.stop();