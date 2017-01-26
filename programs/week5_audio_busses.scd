//week 6
s.boot();
s.meter();


n = NetAddr("ipaddr", portNum);

~reverbBus = Bus.audio(s, 1);
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
~reverb.free();
~reverb = {
	var verb =  GVerb.ar(In.ar(~reverbBus));
	Out.ar(0, verb);
}.play();
)

s.queryAllNodes();
s.plotTree;

(
~sineSynth.free();
sineSynth = {
	Out.ar(~reverbBus, SinOsc.ar(900) * LFPulse.ar(1, width:0.15) * 0.12);

).play();