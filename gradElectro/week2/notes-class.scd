

"Control Structures".help;

Server vs SClang



"Tour of UGens".help
s.boot;
{};

if(1==2, {}, {}); // Callback functions


(
	x.free;
	x = {
		GrayNoise.ar();
	};
)

x.play;
(
	24;
)


(
{
	24.postln;
}
)

s.meter;

s.boot;
FreqScope.new();
(
	x.free;
x = {
	//var mix = SinOsc.ar(220) + SinOsc.ar(620);
	//Out.ar([0, 1, 6], mix);

	// MULTICHANNEL EXPANSION
	var freq = 600;
	SinOsc.ar(add: 1, freq: [ freq, freq*1.06], mul: [0.5, 0.25]) ;
}.play;
)

24.postln;

SinOsc.help
y.free;
y = {SinOsc.ar}.play;




(
	x.free;
	x = {
		SinOsc.ar(
			//200 + SinOsc.ar(MouseY.kr(2/2, [ 100, 200 ]/2), mul: 500).abs
			//200 + LinLin.kr(SinOsc.ar(12/2, mul: 500), -1, 1, 1, 500 )
			200 + SinOsc.ar(12/2, mul: 500).linlin( -1, 1, 1, 500 )
		)
		* Lag.ar(Pulse.ar( MouseX.kr(1,10), 0.5 ), 0.02);
	}.play;
)



// Envelopes
EnvGen

f = Env.perc(0.1, 1, curve: 8); // sclang
f.plot;


(
x.free;
x = {
	SinOsc.ar(220) * EnvGen.ar(Env.perc(0.1, 1, curve: 5), doneAction: 2);
}.play;
)

s.queryAllNodes

FreqScope.new
// CONTROL STRUCTURE
(
(900.rand).do({ arg index;
	{
		SinOsc.ar((MouseY.kr(60,[500, 520]) + 500.0.rand) * ( index+1 )) * EnvGen.ar(Env.perc(0.1, 5.0.rand, curve: 5), doneAction: 2) * 0.2;
	}.play;
});
)

















