// https://www.youtube.com/watch?v=-J80qAyz3BA&t=5s

SinOsc osc => dac;
0.5 => osc.gain;

[0,4,7] @=> int major[];
[0,3,7] @=> int minor[];

// position seems to control the note or the key
int position;
// offset seems to control the octave
48 => int offset;

150::ms => dur eighth;


for(0 => position; position < 13; position++) {
    
    for(0 => int i; i < 4; i++) {  
        for(0 => int j; j < 3; j++) {
            Std.mtof(major[j] + offset + position) => float freq;
            freq => osc.freq;
            <<< freq >>>;
            eighth => now;
        }   
        
        for(0 => int k; k < 3; k++) {
            Std.mtof(minor[k] + offset + position) => float freq;
            freq => osc.freq;
            <<< freq >>>;
            eighth => now;
        }          
    }

}
