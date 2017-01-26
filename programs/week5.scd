// week 4
// a routine is a thead that is running on its own time clock, they have access to the same variables
s.boot();
s.meter();
~duration = 0.2;
~clock = TempoClock.new();
~clock.tempo = 1; // 60 beats a minute
~clock.tempo = 120/60;//120 beats per minute


// TempoClock.help();
// there are several differnt types of clocks in supercollider
// there is the system clock, the global clock, most things run on the system clock you rarely work with it directly

// Tempo clock allows you to specify things according to beats, its a little more musical

// App clock is less acurate but calls coco primatives, it can interect with your gui elements

//coco is apples graphics for gui frameworks



// like in ChucK you spork a shred this forks a thread
{

}.fork();

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

// the .play() is what actually creates the synth

x = {SinOsc.ar(22)}.play();
(
// Constructor, changes will be reflected in new instances
//SynthDef(/sineSynth, { |freq=120,, amp=1|
// args can be accesed from outside of the synth while vars can not
SynthDef(\sineSynth, {arg freq=1200, amp=1;
	// note that all variables have to be declared at the top
	var sine = SinOsc.ar(freq);
	// print the values once a second
	// by default supercollider creates 8 busses, you can have more than 8 busses
	// but you have to create them yourself
	var env = EnvGen.ar(Env.perc(0.1, 3), doneAction:2);

	// takes in input
	// offsets automatically to take in input busses
	// var input = SoundIn.ar(0, 1);
	// Delay.ar(input, 1)
	Out.ar(0, sine * amp * env);
	// Poll.kr(Impulse.kr(1), sine);
	// this line in invalid because all variables have to be decalred at the top
	// var input = SoundIn.ar(0,1);
// .send will not initalize reflectance
// .add will add temporally but does allow for reflectance
// .store will keep it on the machine forever
}).store;
)

//~rocks = Synth(\sineSynth);
~pebbles = Synth(\sineSynth, [\amp, 0.1, \freq, 3000]);
~pebbles.free();

// rocks baby
~rocks = Synth(\sineSynth, [\amp, 0.1, \freq, 800]);
~rocks.free();
~rocks.set(\freq, 1877);

OSCdef(\hello, {
	rocks.free;
}, \chat).send(s);

// ================================= TIME ========================================


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