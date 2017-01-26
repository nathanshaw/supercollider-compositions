// control busses

// Buffers
// highly optimized arrays that live on the server

s.boot();
s.sampleRate();
s.meter();
// an array
a = [23, 44, 55, 66 , 234 ,324];

// a buffer (read at audio rate)
// buffers are always floating point arrays
(
b = Buffer.alloc(s, s.sampleRate * 2, 2);
b.free();
)

//
~mouseXBus = Bus.control(s, 1);

(
~mouseX.free();
~mouseX = {
	Out.kr(~mouseXBus, MouseX.kr(0.5, 20));
}.play();
)


(
~player.free();
~player = {
	Out.ar(~reverbBus, PlayBuf.ar(b.numChannels, b, rate: 1, trigger = 1, startPos = 0, loop = 0));
}.play()
)

(
~pulseSynth.free();
~pulseSynth = {
	var sine = SinOsc(220, 0.3);
	var mouseX = MouseX.kr(0.2, 30);
	var impulse = Impulse.ar(mouseX) * 0.15;
	Out.ar(~reverbBus, sine * impulse);
}.play();
)

(
~player.free();
~player = {
	var output = Playbuf.ar(b.numChannels, bufNum: b, rate: [1,2], loop:1);
	var mouseX = in.kr(~MouseXBus, 1);
	output = output * Pulse.ar(mouseX, width: 0.5);
	var verb =  FreeVerb.ar(In.ar(~reverbBus));
	Out.ar(~reverbbuf, output);
}.play();

b = Buffer.loadDialog(s, "/Users/nathan/Music/dune_04.aif");
c = Buffer.readChannel(s, "/Users/nathan/Music/dune_04.aif", channels:1);
c.plot();

(
SynthDef(\whatever, { arg freq = 1;
	Out.ar(0, Grainbuf.ar(2, trigger: Impulse.kr(10), dur:0.2, sndBuf:c, rate:freq));
}).add;
)

(
SynthDef(\grainMachine, {arg freq = 0.2;
	Out.ar(0, GrainBuf.ar(2, trigger:Impulse.kr(10), dur:0.1, sndbuf:c, rate:freq));
}).add();
)

x.free();
x = Synth(\grainMachine);
s.set(\freq, 6);
x.map(\freq, ~mouseXBus);
x.map(\freq, ~otherBus);

~otherBus = Bus.control(s, 1);
(
~flo = {
	Out.kr(~otherBus, SinOsc.kr(0.3).unipoler );
}.play();
)