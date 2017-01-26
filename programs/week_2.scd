"Tour of UGens".help


s.boot();

s.meter();
FreqScope.new();

(
y = {GreyNoise.ar()}.play();
)

x = Noise.ar();

(
   x.free;
   x = {
	// for 'mixing' two signals together
	var mix = WhiteNoise.ar() + SinOsc.ar();
	mix!2; // creates two channels of output audio
	out.ar([0, 1,3], mix);
   }
   x.play;
)

//MULTICHANNEL EXPANSION
(
SinOsc.ar(220) + SinOsc.ar(220);
SinOsc.ar([220, 650]);
var freq = 500;
SinOsc.ar([freq, freq*1.04]);
{}
)

SinOsc.help();

(
x.free();
x = {
	// LFO
	SinOsc.ar(900) * SinOsc.ar(2);
}.play();
)

(
x.free();
x = {
	SinOsc.ar( 200 + SinOsc.ar(MouseY.kr(12/2, [100, 500]).abs())) * Pulse.ar(MouseX.kr(1,19));
}.play();
)

// lag is a delay, it acts alomst like a low pass filter
(
x.free();
x = {
	SinOsc.ar(
		200 + LinLin.ar(SinOsc.ar(12/2, mul:500), -1, 1, 1, 500)
) * Lag.ar(Pulse.ar(MouseX.kr(0.2, 10), 0.5));
}.play();
)

(
{}.play();
)

//envelopes

s.scope();

EnvGen
(
f = Env.perc(0.1, 8);
f.plot;
x.free();
// the EnvGen actually impliments the envelope...
x = {
	SinOsc.ar(220) * EnvGen.ar(f, doneAction : 2);
}
32.do({

});
)

Env()