
s.boot;
s.meter;


x.free;
x  = {SinOsc.ar(22)}.play;


(
	// Constructor function
SynthDef(\sineSynth, {
	arg freq=1200, amp = 1;

	var sine = SinOsc.ar(freq);
	//var input = SoundIn.ar(0, 1);

	var env = EnvGen.ar(Env.perc(0.1, 3), doneAction: 2);
	Out.ar(0, sine * amp * env);
	//freq = 200;
	//sine = SinOsc.ar(12);
	//Poll.kr(Impulse.kr(1), sine);


	//Out.ar(0, DelayL.ar(input, 1, 1) * amp);

}).store;
)
;

// SCOPE
(
var rocks = Synth(\synth); // local variable
// SOME BUTTON HERE that's action was to kill rocks
)



~flamino = Synth(\sineSynth, [\amp, 1.0, \freq, 800]);
~flamino.free;

~rocks = Synth(\sineSynth, [\amp, 0.1, \freq, 800]);
~rocks.free;

~rocks.set(\freq, 877);
~rocks.set(\amp, 0.8);

// TIME
// ROUTINES
s.boot
~clock = TempoClock.new();
~clock.tempo = 2.5;
TempoClock.help
(
	t = Task({
		{
			~duration = 0.25 + (5.0.rand);
			3.0.wait;
		}.loop;
	});
)
t.play(~clock, quant: 1);
t.stop

{

}.fork();

62.midicps;
(
r = Task({
	var freqs = [60, 62, 63];
	var index = 0;

	{
		Synth(\sineSynth, [\amp, 0.3, \freq, freqs[index].midicps * 3 ]);

		0.5.wait;

		index = (index + 1) % (freqs.size());
	}.loop();

});
)
r.play(~clock, quant: 1);
r.stop;
(
	~kick = Routine({
		{
			{SinOsc.ar(8000)!2 * EnvGen.ar(Env.perc(0.01, 0.2), doneAction:2)}.play;
			1.0.wait;
		}.loop;
	});
)
~kick.play(~clock);
~kick.stop;

r.reset;
r.play(~clock, quant: 1);
r.pause;
~rocks.free;

r.next();
Task // PAUSABLE Routine

Task.help



