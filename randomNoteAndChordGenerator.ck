// C - C#/Db - D - Eb - E - F - F#/Gb - G - G#/Ab - A - Bb - B - C
// 0    1.     2.  3.   4.  5.  6.      7.  8.      9.  10.  11. 12

// user will enter below keyboard keys to guess corresponding element in noteNames
// "Q",   "W",   "E", "R",  "A", "S",   "D",   "F",   "Z",   "X",  "C", "V"
[ "C", "C#/Db", "D", "Eb", "E", "F", "F#/Gb", "G", "G#/Ab", "A", "Bb", "B" ] @=> string noteNames[];
//"Q","W","E","R","A","S","D","F","Z","X","C","V"
[ 81, 87, 69, 82, 65, 83, 68, 70, 90, 88, 67, 86 ] @=> int asciiNumbersForKeyboardKeys[];

class RandomNote {
    int randomMidi;
    float randomFreq;
}

class RandomChord {
    // serves as root note
    int randomMidi;
    // array of chord tones
    float randomFreqs[];
}

SinOsc firstToneOsc => dac; 0 => firstToneOsc.freq;
// below will be used for chords
SinOsc secondToneOsc => dac; 0 => secondToneOsc.freq;
SinOsc thirdToneOsc => dac; 0 => thirdToneOsc.freq;
SinOsc fourthToneOsc => dac; 0 => fourthToneOsc.freq;
SinOsc fifthToneOsc => dac; 0 => fifthToneOsc.freq;

// setting up user input
HidMsg hidMessage;
Hid hid;
if( !hid.openKeyboard( 1 ) ) me.exit();

40 => int e2; // bass starts on E1 (midi 28), but that's too low to hear on my speakers

// returns a random note in the specified octave and range
// with octave 1 being E2-E3 (MIDI 40-52), 2 being E3-E4 (MIDI 52-64)...
// and range defining the number of random notes after the octave root to choose from
fun RandomNote getRandomNote(int octave, int range) {
    RandomNote randomNote;
    // set octave range 
    e2 + (12 * (octave - 1) ) => int lowestNote;
    lowestNote + range => int highestNote;
    // generate random Midi note
    Std.rand2(lowestNote, highestNote) => randomNote.randomMidi;
    // convert random midi to frequency
    Std.mtof(randomNote.randomMidi) => randomNote.randomFreq;
    return randomNote;
}

fun string getUserInput() {
    <<< "What note do you think this is?" >>>;
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
        100::ms => now;
    }
    return noteNames[asciiNumbersForKeyboardKeysIndex];
}

// TODO factor these in
0 => int correctGuesses;
0 => int totalAttempts;
0.00 => float percentCorrect;


fun void playRandomNote(RandomNote randomNote) {
    0.1 => firstToneOsc.gain;  
    randomNote.randomFreq => firstToneOsc.freq;
    5::second => now;
    // look up random note frequency
    noteNames[randomNote.randomMidi % 12] => string noteName;
    getUserInput() => string userGuess;
    <<< "You guessed: " + userGuess >>>;
    <<< "That note was: " + noteName>>>;
    // providing time to match the note before stopping it
    5::second => now;
    0 => firstToneOsc.freq;
}

    
while( true ) {
    // 0 = chord, 1 = true
    int note;
    int octaveSelection;
    
    // 67 = C, 78 = N
    <<< "Press N to hear a note or C to hear a chord?" >>>;
    hid => now;
    while( hid.recv(hidMessage) )  {
        if( hidMessage.isButtonDown() ) { 
            if( hidMessage.ascii == 67  ) {
                // TODO remove
                0 => note;;
                <<< "Chords not supported yet" >>>;
                me.exit();
            } else if (hidMessage.ascii == 78 ) {
                1 => note;
            } else {
                <<< "Don't recognize the input. Restart program and try again" >>>;
                me.exit();
            }
            100::ms => now;
        }
    }

    <<< "Press a number for the octave range, with 1->E1, 2->E2...." >>>;
    hid => now;
    while( hid.recv(hidMessage) )  {
        if( hidMessage.isButtonDown() ) { 
            hidMessage.ascii - 48 => octaveSelection;
        }
        100::ms => now;
    }
    
    // TODO getRandomChord
    if( 1 == note ) {
        // should just play E
        getRandomNote(octaveSelection, 0) @=> RandomNote randomNote;
        playRandomNote(randomNote);
    }
    
}

