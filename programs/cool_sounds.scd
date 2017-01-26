
s.boot();

// creepy
(
x.free();
x = {RLPF.ar(Dust.ar([MouseY.kr(10, 50), MouseX.kr(20, 220)]), LFNoise1.ar([2.4, 0.6]).range(MouseX.kr(50, 150), MouseY.kr(2000, 4000)), 0.1)}.play;
)
x.free();


RLPF.help()
Dust.help()

// additive synthesis
(
{
var sines = 5, speed =6;
	Mix.fill(sines,
		{arg x;
			Pan2.ar(SinOsc.ar(x+1*100,
				mul: max(0,
					LFNoise1.kr(Speed) +
					Line.kr(1, -1, 30)
)
), rand2(1.0))})/sines})
}.play();
)
// still needs some work, but uses the mouse x position
(
{
  var x = SinOsc.ar(MouseX.kr(1, 100));
	SinOsc.ar(30 * x + 400, 0, 0.1) * SinOsc.ar(4 * x + 3, 0, 10.1)
  +
	PinkNoise.ar(0.1 * x + 0.05 * MouseY.kr(0,1))
}.play();
)

// Simple synth definition using the Atari2600 UGen:
/*(
SynthDef(\atari2600, {|out= 0, gate= 1, tone0= 5,
tone1= 8, freq0= 10, freq1= 20, amp= 1, pan= 0|
  var e, z;
  e= EnvGen.kr(Env.asr(0.01, amp, 0.05), gate, doneAction:2);
  z= Atari2600.ar(tone0, tone1, freq0, freq1, 15, 15);
  Out.ar(out, Pan2.ar(z*e, pan));
}).store
)

// And a pattern to play it:
(
Pbind(
  \instrument, \atari2600,
  \dur, Pseq([0.25, 0.25, 0.25, 0.45], inf),
  \amp, 0.8,
  \tone0, Pseq([Pseq([2, 5], 32), Pseq([3, 5], 32)], inf),
  \tone1, 14,
  \freq0, Pseq([Pbrown(28, 31, 1, 32), Pbrown(23, 26, 3, 32)], inf),
  \freq1, Pseq([Pn(10, 16), Pn(11, 16)], inf)
).play
)*/

s.freeAll;

