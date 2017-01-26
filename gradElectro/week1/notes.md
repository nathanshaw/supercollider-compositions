
### SUPERCOLLIDER

### Introduction

### What is SuperCollider
* SuperCollider is a language based on concepts from SmallTalk
	* Object-oriented
		* What is object-oriented?
	* Everything is an object
	* Loosely typed
		* typical types
		* functions
		* Integers
		* Floating point
		* SYMBOL
			* unique name
	* Real-time
		* CROSS-FADING CODE!
		* Awesome for live coding

* Client and Server
	* Built-in network capabilities
		* By default network ready
	* sclang vs scsynth
	* scsynth
		* Where ALL audio processing happens
		* This includes any high-performance audio-specific objects such as buffers
		* Maintains a UGen graph
			* What is a UGen
				* Usually written in C/C++
				* Generates a stream of data
				* Can generate an audio rate, or control rate stream, or both
		* Two different types
			* local
				* Uses a separate address space. Runs over TCP/IP
			* internal
				* Uses same memory space
				* Sometimes this is necessary for specific plugins and Classes but very rarely
	* sclang
		* control devices
		* variables, environment
		* Time based patterns, sequences, etc.

### Language Basics
* Comments
* Execution of code
	* blocks
	* lines
* Variables in SC
	* Local
	* Environment variables

* Control Structures in SC
	* Logic
		* If statements
			* ALSO object-oriented
		* switch / case 
			* switch is for equivalence only
	* Loops
		* while
		* for(start, end, func(i))
		* do(coll, func(item, i) )
	* Syntactic sugar

* The help system
* GUI system
	* Fully featured
	* scoping
	* FreqAnalyzer

### Basic soundmaking
* Hello world SinOsc.ar
* Amplitude modulation
* Additive synthesis
* Using Synth Definitions
* Additive synthesis through sclang
