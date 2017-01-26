// week 4
// a routine is a thead that is running on its own time clock, they have access to the same variables
s.boot();
s.meter();
~duration = 0.2;
~clock = TempoClock.new();
~clock.tempo = 1; // 60 beats a minute
~clock.tempo = 120/60;//120 beats per minute
// TempoClock.help();

(
t = Task({
	{
		~duration = 0.25 + (5.0.rand);
		// for wait is defaults back to the clock being passed into play
		// if we are using our custom clock then the 3 will now wait 3 beats instead of 3 seconds
		3.0.wait();
	}.loop();
});
)
//quantize it to on the beat
t.play(~clock, quant:1);
t.stop();

Env.adsr.help();

(
SynthDef(\fmSynth, {|freq1=1200.0, freq2=200.0, amp1=1.0, amp2=10.0|
	var sine1 = SinOsc.ar(freq1);
	var sine2 = SinOsc.ar(freq2);
	var env1 = EnvGen.ar(Env.adsr(1, 0.6, 2, amp1), doneAction:2);
	var env2 = EnvGen.ar(Env.adsr(2.2, 0.5, 1, amp2), doneAction:2);

	freq1.post;
	freq2.post;
	amp1.post;
	amp2.postln;

	Out.ar(0, (sine1 * env1)* (sine2 * env2));
	}).store;
)


(
~partyFoul.free();
~f1 = 400.0.rand();
~f2 = 1800.rand();
~a1 = 100.rand();
~a1.post;
" ".post;
~f1.post;
" ".post;
~f2.post();
" ".post;
~partyFoul = Synth(\fmSynth, [\freq1, ~f1, \freq2, ~f2, \amp1, ~a1, \amp2, 0.34]);
)

// ============== TIME ======================


// the only place where you can put a wait in a routine
//routines = yeildable functions
(
r = Routine({
	var index = 0;
	{
		index.yield();
		index = index + 1;
	}.loop();
});
)

r.next();

(
t = Routine({
	var index = 0;
	{
		~rocks.set(\freq, 400 + (200.0.rand()));
		0.1.wait;
		index = index + 1;
	}.loop();
});
)

t.reset();
t.play();
t.stop();
t.next();
~rocks.free();

e = Env.perc(0.1, 3, 5)//.plot()  //to see envelope


//pausable routine
(
s = Task ({
	var index = 0;

	{
		Synth(\sineSynth, [\amp, 0.1, \freq, 200 + (600.0.rand())]);

		~duration.wait();
	}.loop();

});
)

s.reset();
s.play(~clock, quant:1);
s.pause();
s.stop();
~rocks.free();

(
~kick = Routine({
	var freqs = [110,220,400,300,50];
	{
		{SinOsc.ar(freqs.choose())!2 * EnvGen.ar(Env.perc(0.01, 0.2), doneAction:2)}.play();
			1.0.wait();
		}.loop();
}).play(~clock, quant:1);
)

~kick.play(~clock, quant:1);
~kick.stop();

Pbind(\degree, Pseries(0, 1, 30), \dur, 0.05).play();
(
piano.kill()
Pbind(\degree, Pseries(0, 2, 4, 6, 8, 16), \dur, 0.004).play();
)