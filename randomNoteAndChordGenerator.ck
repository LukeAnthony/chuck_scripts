// C - C#/Db - D - Eb - E - F - F#/Gb - G - G#/Ab - A - Bb - B - C
// 0    1.     2.  3.   4.  5.  6.      7.  8.      9.  10.  11. 12

// user will enter below keyboard keys to guess corresponding element in noteNames
// "Q",   "W",   "E", "R",  "A", "S",   "D",   "F",   "Z",   "X",  "C", "V"
[ "C", "C#/Db", "D", "Eb", "E", "F", "F#/Gb", "G", "G#/Ab", "A", "Bb", "B" ] @=> string noteNames[];
//"Q","W","E","R","A","S","D","F","Z","X","C","V"
[ 81, 87, 69, 82, 65, 83, 68, 70, 90, 88, 67, 86 ] @=> int asciiNumbersForKeyboardKeys[];


// setting up user input
HidMsg hidMessage;
Hid hid;
if( !hid.openKeyboard( 1 ) ) me.exit();

40 => int e2; // bass starts on E1 (midi 28), but that's too low to hear on my speakers

// plays a random note or chord in the specified octave range
// with octave 1 being E2-E3 (MIDI 40-52), 2 being E3-E4 (MIDI 52-64)...
fun string playRandom(string noteOrChord, int octave) {

    if(noteOrChord == "chord") {
        
    } 
    else if(noteOrChord == "note") {
        // set octave range 
        e2 + (12 * (octave - 1) ) => int lowestNote;
        lowestNote + 12 => int highestNote;
        // generate random Midi note
        Std.rand2(lowestNote, highestNote) => int randomMidi;
        // convert random midi to frequency
        Std.mtof(randomMidi) => float freq;
        SinOsc osc => getSinOsc();
        // play random frequency
        freq => osc.freq;
        2::second => now;
        // look up note of random frequency
        noteNames[randomMidi % 12] => string noteName;
        getUserInput() => string userGuess;
        <<< "You guessed: " + userGuess >>>;
        <<< "That note was: " + noteName>>>;
    }
    else {
     <<< "Enter 'note' or 'chord' next time" >>>;   
    }
    
    <<< "" >>>;
    <<< "" >>>;
    <<< "" >>>;
}

fun string getUserInput() {
    <<< "What note do you think that was?" >>>;
    <<< "Hit 'Q'->C, 'W'->C#/Db, 'E'->D, 'R'->Eb, 'A'->E, 'S'->F, 'D'->F#/Gb, 'F'->G, 'Z'->G#/Ab, 'X'->A, 'C'->Bb, 'V'->B" >>>;
    // wait to receive a message
    int asciiNumbersForKeyboardKeysIndex;
    hid => now;
    while( hid.recv(hidMessage) )  { 
        if( hidMessage.isButtonDown() ) {
            for( 0 => int i; i < asciiNumbersForKeyboardKeys.cap(); i++) {
                if( hidMessage.ascii == asciiNumbersForKeyboardKeys[i] ) {
                    i => asciiNumbersForKeyboardKeysIndex;
                    break;
                }
            }
        }
    }
    return noteNames[asciiNumbersForKeyboardKeysIndex];
}

fun SinOsc getSinOsc() {
    SinOsc osc => dac;
    0.5 => osc.gain;
    return osc;
}

0 => int correctGuesses;
0 => int totalAttempts;
0.00 => float percentCorrect;

while( true ) {
    string noteOrChord;
    int octaveSelection;
    <<< "Press N to hear a note or C to hear a chord?" >>>;
    // 67 = C, 78 = N
    hid => now;
    while( hid.recv(hidMessage) )  {
        if( hidMessage.isButtonDown() ) { 
            if( hidMessage.ascii == 67  ) {
                "chord" => noteOrChord;
            } else if (hidMessage.ascii == 78 ) {
                "note" => noteOrChord;
            }
        }
    }
    <<< "Press a number for the octave range, with 1->E1, 2->E2...." >>>;
    hid => now;
    while( hid.recv(hidMessage) )  {
        if( hidMessage.isButtonDown() ) { 
            hidMessage.ascii - 48 => octaveSelection;
        }
    }
    playRandom(noteOrChord, octaveSelection);

}

