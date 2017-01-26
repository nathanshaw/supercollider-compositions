// What is SuperCollider?

s.boot;
//starts the server
// shift enter executes a single line of code
// cmd enter executes a block of code
// mono
(
x.free
x = { SinOsc.ar(200, 150, 0.2) }.play;
)
// stereo
x = { SinOsc.ar(220)!2 }.play;
// just pipes the signal out of two signals
x = (Out.ar([0,1], SinOsc.ar(220) )}.play;

x.free;
y.free;

// in general only execute blocks and set them up like this
(
x.free;
x = { SinOsc.ar(220)!2 }.play;
)

// you can create blocks by adding
(
x.free;
y.free;
)

currentEnviroment;
// give information about the current enviroment
s.freeAll;//stops all nodes
//cmd . is the keyboard shortcut for that
s.queryAllNodes(); // gets the server to replay back with everything that is running on the server
s.sendMsg(\n_free, 1001)

p = ();
p[] = "gumsticks"

g = currentEnviroment;
p.push;// activates a current enviroment

/////////////////////////////////////////////////////////////////////////////////////
// all of this will be on the server
/////////////////////////////////////////////////////////////////////////////////////

x = {"Tide".postln};//function b/c of curly brackets
x.value

f = {
	SinOsc.ar()320 + 300.0.rand()) * SinOsc.ar(2);
};

if(3 < 2, {if it is true}, {if it is false});

"Control Structures".help;
