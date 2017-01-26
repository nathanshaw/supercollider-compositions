//Define bow synthdef
s.boot();

(
SynthDef(\helpStkbowed,{arg out=0,freq=220,gate=1,amp=1,bowpressure = 64, bowposition = 17, vibfreq=50, vibgain=1, loudness=128;
	var sig,env;
	env = EnvGen.kr(Env.asr(0,1,0.1),gate,doneAction:2);
	sig = StkInst.ar(Stk.at("Bowed"),freq, gate, amp, 0.5,[2,bowpressure,4,bowposition,11,vibfreq,1,vibgain,128,loudness])*env;
	Out.ar(out, sig.dup);
}).add;
)

//Use it.
(
x.free();
x = Pbind(
    \instrument, \helpStkbowed,
    \dur , 0.025,
    \degree, Pseq([3,2,7+3], inf),
    \amp , Pseq([0.9,1.7,0.5],inf),
	\bowposition , Pseq([10,90,50,20,250,60],inf)
).play;
)

100.do({"Print this line over and over...".scramble.postln});

// QUICK RECORD
// Start recording:
s.record;
// Make some cool sound
{Saw.ar(LFNoise0.kr([2, 3]).range(100, 2000), LFPulse.kr([4, 5]) * 0.1)}.play;
// Stop recording:
s.stopRecording;
// Optional: GUI with record button, volume control, mute button:
s.makeWindow;

//--------------------------------------------------------
// Chapter 2
//--------------------------------------------------------


