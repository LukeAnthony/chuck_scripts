// https://www.youtube.com/watch?v=zSkbXPwMNcM
// ugen = unit generator.
// Chuck docs on ugens -->  https://chuck.cs.princeton.edu/doc/language/ugen.html

// Unit generators basically pass audio to/from one another.
// SinOsc and dac (digital audio converter) are unit generators
// When we write 'SinOsc osc => dac', we're directing the sine oscillator to pass audio to the digital audio converter


// here, we're dictating the flow of audio from the triangle oscillator to ADSR to the DAC
// ADSR = attack delay sustain release
//            Attack = amount of time it takes for the sound to fade in
//            Delay = how long it takes for the sound to get down to the level that it'll be sustained at
//            Sustain = how loud it is while it's sustained
//            Release = how long it takes to go down from sustain level to silence
TriOsc osc => ADSR env1 => dac;

0.2 => osc.gain;

[0,4,7,12] @=> int major[];
[0,3,7,12] @=> int minor[];

48 => int offset;
int position;

2::second => dur beat;

// setting adrs times
( beat/2, beat/2, 0, 1::ms ) => env1.set;


0 => position;
for(0 => int i; i < 4; i++) {
    Std.mtof(minor[0] + offset + position) => osc.freq;
    // keyOn turns on the adrs unit generator
    1 => env1.keyOn;
    beat / 2 => now;
}

-4 => position;
for(0 => int i; i < 4; i++) {
    Std.mtof(major[0] + offset + position) => osc.freq;
    1 => env1.keyOn;
    beat / 2 => now;
}

-2 => position;
for(0 => int i; i < 4; i++) {
    Std.mtof(major[0] + offset + position) => osc.freq;
    1 => env1.keyOn;
    beat / 2 => now;
}

-5 => position;
for(0 => int i; i < 4; i++) {
    Std.mtof(major[0] + offset + position) => osc.freq;
    1 => env1.keyOn;
    beat / 2 => now;
}