// https://www.youtube.com/watch?v=2BHP6oXbVfg

// array format = type varName[numberOfElements]

int numbers[10];

2 => numbers[0];

// should print 2
<<< numbers[0] >>>;
// should print 0 --> default value for int array entries is 0
<<< numbers[1] >>>;



// could initialize arrays like this
int frequencies[4];
440 => frequencies[0];
660 => frequencies[1];
880 => frequencies[2];
1320 => frequencies[3];

// or like this, with @ operator (@=>) 
[ 110, 220, 440, 660, 770, 880, 1320 ] @=> int frequenciesTwo[];

SinOsc osc => dac;
0.25 => osc.gain;

[60, 62, 64, 65, 67, 69, 71, 72] @=> int pitches[];

// .cap operator gives you the length
<<< pitches.cap() >>>;


for(0 => int i; i < pitches.cap(); i++) {
    // std = chuck standard library
    // calling the mtof function from the standard library, which converts a midi note to a frequency
    <<< Std.mtof(pitches[i]) >>>;
    Std.mtof(pitches[i]) => osc.freq;
    1::second => now;
}