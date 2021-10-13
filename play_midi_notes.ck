SinOsc osc => dac;
0.5 => osc.gain;

// C. Db. D.  Eb  E.  F.  Gb. G.  Ab. A.  Bb. B.  C
[ 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84 ] @=> int octave[];

for(0 => int i; i < octave.size(); i++) {
    octave[i] => int midiNote;
    Std.mtof(midiNote) => float note;
    <<< midiNote, note >>>;   
    note => osc.freq;
    500::ms => now;
}