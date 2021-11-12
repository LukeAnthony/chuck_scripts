// make our patch
SinOsc s => dac;
0.1 => s.gain;
// time-loop, in which the Osc?s frequency is changed every 100 ms
while( true ) {
    1000::ms => now;
    Std.rand2f(30.0, 1000.0) => s.freq;
}