// C - C#/Db - D - Eb - E - F - F#/Gb - G - G#/Ab - A - Bb - B - C
// 0    1.     2.  3.   4.  5.  6.      7.  8.      9.  10.  11. 12

[ "C", "C#/Db", "D", "Eb", "E", "F", "F#/Gb", "G", "G#/Ab", "A", "Bb", "B" ] @=> string noteNames[];
[ "Q", "W", "E", "R", "A", "S", "D", "F", "Z", "X", "C", "V" ] @=> string keyboardKeysForNotes[]; 
[ 81, 87, 69, 82, 65, 83, 68, 70, 90, 88, 67, 86 ] @=> int asciiNumbersForKeyboardKeys[];

SinOsc osc => dac;
0.5 => osc.gain;

40 => int e2; // bass starts on E1 (midi 28), but that's too low to hear on my speakers

// plays a random note or chord in the specified octave range
// with octave 1 being E2-E3 (MIDI 40-52), 2 being E3-E4 (MIDI 52-64)...
fun string playRandom(string noteOrChord, int octave) {
    if(noteOrChord == "chord") {
        
    } 
    else if(noteOrChord == "note") {
        //
        e2 + (12 * (octave - 1) ) => int lowestNote;
        lowestNote + 12 => int highestNote;
        Std.rand2(lowestNote, highestNote) => int randomMidi;
        <<< randomMidi >>>;
        Std.mtof(randomMidi) => float freq;
        <<< freq >>>;
        freq => osc.freq;
        1::second => now;
        randomMidi % 12 => int noteName;
        <<< "That note was: " + noteNames[noteName]>>>;
    }
    else {
     <<< "Enter 'note' or 'chord' next time" >>>;   
    }
}



playRandom("note", 1);


