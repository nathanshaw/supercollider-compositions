s.boot();

// if statements
s.freeAll();
(
x.free();
y.free();
if( [true, false].choose,
	{x = {SinOsc.ar(200, 0, 0.2)}.play()},
	{y = {SinOsc.ar(50.rand + 175, 0, 0.2)}.play()})
)

// while loop
(
var frequency = 100;
oscNode = {osc = SinOsc.ar(frequency,0,0.5,0).play()};
while({frequency < 300},{frequency = frequency + 1; osc.freq = frequency;})
)

// for loop
// for ( startValue, endValue, function )
// startValue.for( endValue, function)
(
"for loops yay!".postln;
for(1, 10, {arg i; i.post});
10.for(1, {arg i; i.post});
)

// forBy loop
// for loop with variable step size
(
"ForBy Loops".postln;
forBy(0, 10, 2, {arg i; i.post});
0.forBy(20, 4, {arg i; i.post});
)

// do loops - iterate over a collection
// if called on another type of object then the object
// passes itself to a function over time
// do(collection, function)
(
"Do loop for iterating over collection".postln();
do(["Hello ", "World"], {arg i; i.postln()});
["Hello", " World!"].do({arg i; i.postln()});
"Do loop for calling something over time".postln;
do("Hello World!", {arg i; i.postln()});
do(5, {arg i; i.post()});
"".postln();
(8..20).do({arg i; (" " + i).post()});
(5,8..20).do({arg i; (" " + i).post()});
)

// switch
(
var x, y;
y = [0,1,2];
x = y.choose;
switch(x,
	0,{"0 SELECTED".postln()},
	1, {"1 SELECTED".postln()},
	{"Default Argument"});
)

// case
(
var i, x ,z;
z = [1, 0, 2];
i = z.choose;
x = case
    { i == 0} {\no_0}
    { i == 1} {\no_1}
    { i == 2} {\yes_2};
x.postln();
)
