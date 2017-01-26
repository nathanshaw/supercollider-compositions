// What is SuperCollider?
// WHY?
* Small talk based
* Object-oriented language
* Real-time
* Loosely typed
* By default, network based
* SPECIFICALLY designed for music making and sound generation
* syntactic sugar
* VERY CONFUSING

s.boot;

(
x = { Out.ar([0,1], SinOsc.ar(220)) }.play;
y = { Out.ar([0,1], SinOsc.ar(620)) }.play;
)


x = 5.0
y = 12.32;

x + y;

x.free;
y.free;



/*this is a
multiline comment*/


Server / Client
scsynth
sclang

Internal server
local server // default


UGen - Unit Generator
UGen graphs are maintained on the server



s.boot;

x
x = {SinOsc.ar(2220)}.play;
x = {SinOsc.ar(240)}.play;
x.free;
s.freeAll;
s.queryAllNodes();
s.sendMsg(\n_free, 1001);

(
x.free;
x = {SinOsc.ar(640)}.play;
)

a = 5;
(
var helloKitty = "HELLO!";

3.postln;
a.postln;
helloKitty.postln;
)


helloKitty.postln;

~helloKitty = 5;
~helloKitty.postln;
~blah = "DUMB";

currentEnvironment
// VARIABLES
* Local // Only exists inside of blocks of code
* Environment // Specified by ~
* Global




p = ();
p[\helloKitty] = "gumstix";
p

currentEnvironment
g = currentEnvironment;
p.push;
g.push;

~helloKitty.postln;



~synth = { SinOsc.ar(220) }.play;
~synth.free;

s = 56;

s.boot;
s = Server.internal;
s.boot

"Control Structures".help;


x = {"tide".postln;};
x.value
x
if(3 < 2, {/*if it is true*/}, {});

x = { SinOsc.ar(220) };
y = x.play();

x = { SinOsc.ar(440) }.play();

f = 32 / 16;

f = {
	SinOsc.ar(320 + 600.0.rand) * SinOsc.ar(2);
};

g = f.play;
x = f.play();
h = f.play();

g.free;
x.free;
h.free;









