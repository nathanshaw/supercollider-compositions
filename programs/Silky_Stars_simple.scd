(
s.boot();
s.meter();
//s.plotTree();
~clock = TempoClock.new();
~slow = 30/60;
~fast = 210/60;
~clock.tempo = ~fast;
~scream_buf = Buffer.readChannel(s, "/Users/nathan/Music/samples/as_woman_scream.wav", channels:1);

~laugh_buf = Buffer.readChannel(s, "/Users/nathan/Music/samples/as_laugh.wav", channels:0);
//~laugh_buf.plot();
//~scream_buf.plot();
~mouseXBus = Bus.control(s, 1);
~mouseYBus = Bus.control(s, 1);
)
(
~mouseX.free();
~mouseY.free();
~mouseX = {Out.kr(~mouseXBus, MouseX.kr(0.5, 20));}.play();
~mouseY = {Out.kr(~mouseYBus, MouseY.kr(0.5, 20));}.play();
)
(
SynthDef(\screamMachine, {arg freq = 0.2, trigRate = 20, gain = 0.5, env=True;
	Out.ar(0, GrainBuf.ar(2, trigger:Impulse.kr(trigRate), dur:3.1, sndbuf:~scream_buf, rate:freq) * gain);
}).add();
//tchoose use me
// ~env;
SynthDef(\laughMachine, {arg freq = 0.2, trigRate = 20, duration = 3.1, gain = 0.005, env=False;
	//~env = EnvGen.kr(Env.new([0,1,0], [0.1, 2]), doneAction:2);
	{Out.ar(0, GrainBuf.ar(2, trigger:Impulse.kr(trigRate), dur:duration, sndbuf:~laugh_buf, rate:freq) * gain )

)}).add();

)
(
~soloInc = Pxrand([48,50,60,65,67,72, 60, 60, 67, 68, 72, 48], inf);
~melodyInc = Pseq([60,59,60,67,63,67,72,71,72,67,65,59,62,60], inf, 0);
~tinyInc = Pseries(0, 0.02, inf);
~medInc = Pseries(0, 0.25, inf);
~bigInc = Pseries(0, 1, inf);
~hugeInc = Pseries(0, 10, inf);
~tiny = ~tinyInc.asStream();
~med = ~medInc.asStream();
~big = ~bigInc.asStream();
~huge = ~hugeInc.asStream();
~melody = ~melodyInc.asStream();
~melody2 = ~melodyInc.asStream();
~solo = ~soloInc.asStream();
"_________________________________".postln;
)
// ------------ COMPOSITION --------------------------------

// intro
(
x.free();
y.free();
x = Synth(\screamMachine, [\freq, 2.5, \trigRate, 20, \duration, 2.0, \gain, 0.0042]);
y = Synth(\screamMachine, [\freq, 1.0, \trigRate, 100, \duration, 2.0, \gain, 0.0042]);
)
x.set(\freq, 3.0);
y.set(\freq, 0.75);
x.set(\freq, 3.0.rand);
y.set(\freq, 2.0.rand);
x.set(\trigRate, 100.0.rand);
y.set(\trigRate, 100.0.rand);

(
a.free();
b.free();
a = Synth(\laughMachine, [\freq, 3.0.rand, \trigRate, 200.rand + 10, \duration, 1.1, \env, False, \gain, 0.00292]);
b = Synth(\laughMachine, [\freq, 3.0.rand, \trigRate, 00.rand + 10, \duration, 1.1, \env, False, \gain, 0.00292]);
)

a.set(\freq, 4.0.rand);
b.set(\freq, 2.0.rand);
a.set(\freq, 0.25);
b.set(\freq, 5.5);
a.set(\trigRate, 100.0.rand);
b.set(\trigRate, 100.0.rand);
a.set(\trigRate, 10);
b.set(\trigRate, 100);

// solo
(
x.map(\freq, ~mouseXBus, \trigRate, ~mouseYBus);
y.map(\freq, ~mouseYBus, \trigrate, ~mouseXBus);
a.map(\freq, ~mouseXBus, \trigRate, ~mouseYBus);
b.map(\freq, ~mouseYBus, \trigrate, ~mouseXBus);
)

(
// tasks
~duration = 0.25;
t = Task({
	{

		// for wait is defaults back to the clock being passed into play
		// if we are using our custom clock then the 3 will now wait 3 beats instead of 3 seconds
		a.free();
		a = Synth(\laughMachine, [\freq, 3.0.rand, \trigRate, 200.rand + 10, \duration, 2.1]);
		"Laugh".postln;
		sleep(~duration);
	}.loop();
});
)
//quantize it to on the beat
t.play(~clock, quant:1);
t.stop();


// (
// ~tempMelody = ~melody.next();
// ~tempSolo = ~solo.next();
//
// x.set(\freq, ~tempMelody.midicps(), \trigRate, ~tempMelody.midicps());
// y.set(\freq, ~tempMelody.midicps()*0.5, \trigRate, ~tempMelody.midicps()*0.5);
// a.set(\freq, ~tempSolo.midicps()*2, \trigRate, ~tempSolo.midicps()*3);
// b.set(\freq, ~tempSolo.midicps()*1, \trigRate, ~tempSolo.midicps()*4);
// )


// Paterns - PBind specifically :
// paterns are abstracted automated routines - premade routines

// Pbind - way to connect a synthDef and a dictionary of sequences

(
// creates an event that is played
Pdef(\hello,
	Pbind(
		\instrument, \screamMachine,
		\freq, Pseq([0.7, 2, 20, 3], inf) * Prand([1,2], inf), // freq is argument for my synth def
		\dur, Pseq([0.1, 0.6, 1], inf), // this is built in to deal with timing

	);
)
Pdef(\hello).play();
Pdef(\hello).stop();

//look into NDef - read the help and use them if I can