s.boot;


// BUSSES - Route signals
// Control busses, audio busses
s.meter;

~reverbBus = Bus.audio(s,2);
~reverbBus.index;
~reverbBus.free;
(
	~pulseSynth.free;
	~pulseSynth ={
		var mouseX = MouseX.kr(0.2, 30);
		var impulse = Impulse.ar([ mouseX, mouseX* 1.1 ]) * 0.15;

		Out.ar(~reverbBus, impulse);
	}.play;
)
(
	~otherSynth.free;
	~otherSynth={
		Out.ar(~reverbBus, SinOsc.ar(900) * LFPulse.ar(1, width: 0.15) * 0.12 );
	}.play;
)

s.queryAllNodes
s.plotTree;

(
	~reverb.free;
	~reverb = {
		var verb = FreeVerb.ar(In.ar(~reverbBus.index, 2) );

		Out.ar(0, verb );
	}.play;
)

a = [1,2,4,5,86,7,7,8,8];
a[2]
// CONTROL BUSSES
// Buffers
s.sampleRate
b = Buffer.alloc(s, s.sampleRate * 2, 1);
b.free;
Platform.resourceDir
b = Buffer.loadDialog(s);
b = Buffer.read(s, "/home/scott/MobileScores/Dingen/sounds/concreteNature.aiff");
b.bufnum
b.free;
b.plot;
b.numChannels;

// Create a control bus
~mouseXBus = Bus.control(s,1);

(
	~mouseX.free;
	~mouseX = {
		Out.kr(~mouseXBus, MouseX.kr(0.15, 3));
	}.play;
)
(
	~lfo2.free;
	~lfo2 = {
		Out.kr(~mouseXBus, Saw.kr(0.8).unipolar * 6 );
	}.play;
)
(
	~lfo.free;
	~lfo = {
		Out.kr(~mouseXBus, SinOsc.kr(0.2).unipolar * 6 );
	}.play;
)
(
	~player.free;
	~player = {
		var output = PlayBuf.ar(b.numChannels, bufnum: b, rate: [ 1, 9.1 ], loop: 1);
		var mouseX = In.kr(~mouseXBus, 1);

		output = output * Pulse.ar(mouseX, width: 0.5);
		Out.ar(~reverbBus, output );
	}.play;
)

(
	~reverb.free;
	~reverb = {
		var verb = FreeVerb.ar(In.ar(~reverbBus.index, 2) );

		Out.ar(0, verb );
	}.play;
)

c = Buffer.readChannel(s, "/home/scott/MobileScores/Dingen/sounds/concreteNature.aiff", channels:1);
c.plot;
(
	SynthDef(\whatever, { arg freq = 1;
		Out.ar(0, GrainBuf.ar(2, trigger: Impulse.kr(10),dur: 0.02, sndbuf:c, rate: freq*2 ) );
	}).add;
)

y.free;
x = Synth(\whatever);
x.set(\freq, 1.0);
x.map(\freq, ~mouseXBus);
x.map(\freq, ~otherBus);

y = Synth(\whatever);
y.map(\freq, ~otherBus);

~otherBus = Bus.control(s,1);
(
	~flo = {
		Out.kr( ~otherBus, SinOsc.kr(0.3).unipolar );
	}.play;
)



