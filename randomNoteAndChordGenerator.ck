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
    int randomRootMidi;
    // array of chord tones
    float randomFreqs[];
    // will serve to look up chord tone note names
    int randomChordToneMidis[];
    // 0 = minor, 1 = major
    int majorOrMinor;
    // 0 = triad, 1 = seventh
    int triadOrSeventh;
}

// TODO factor these in
0.00 => float correctGuesses;
0.00 => float totalAttempts;
0.00 => float percentCorrect;

SinOsc firstToneOsc => dac; 0 => firstToneOsc.freq;
// below will be used for chords
SinOsc secondToneOsc => dac; 0 => secondToneOsc.freq;
SinOsc thirdToneOsc => dac; 0 => thirdToneOsc.freq;
SinOsc fourthToneOsc => dac; 0 => fourthToneOsc.freq;

// setting up user input
HidMsg hidMessage;
Hid hid;
if( !hid.openKeyboard( 1 ) ) me.exit();

40 => int e2; // bass starts on E1 (midi 28), but that's too low to hear on my speakers

// TODO add more than major or minor type chords (dominant, augmented, suspended, etc...)
fun RandomChord getRandomChord(int octave, int range) {
    RandomChord randomChord;
    // set octave range 
    e2 + (12 * (octave - 1) ) => int randomFloor;
    randomFloor + range => int randomCeiling;
    // generate random Midi note that will be the root of the chord
    Std.rand2(randomFloor, randomCeiling) => randomChord.randomRootMidi;
    int thirdMidi;
    int fifthMidi;
    int seventhMidi;
    // maybe generates a random value of 0 or 1. 0 = minor, 1 = major,
    maybe => int majorOrMinor;
    // 0 = triad, 1 = 7th
    maybe => int seventhChord;
    // if major
    if( majorOrMinor ) {
        // major chord = root, major 3rd, perfect 5th, (major 7th)
        randomChord.randomRootMidi + 4 => thirdMidi;
        randomChord.randomRootMidi + 7 => fifthMidi;
        if(seventhChord) {
            randomChord.randomRootMidi + 11 => seventhMidi;
            1 => randomChord.triadOrSeventh;
        }
        1 => randomChord.majorOrMinor;
    }
    // if minor
    else {
        // minor chord = root, minor 3rd, perfect 5th, (minor 7th)
        randomChord.randomRootMidi + 3 => thirdMidi;
        randomChord.randomRootMidi + 7 => fifthMidi;
        if(seventhChord) {
            randomChord.randomRootMidi + 10 => seventhMidi;
            1 => randomChord.triadOrSeventh;
        }
        0 => randomChord.majorOrMinor;
    }
    [ Std.mtof(randomChord.randomRootMidi), Std.mtof(thirdMidi), Std.mtof(fifthMidi), Std.mtof(seventhMidi) ] @=> randomChord.randomFreqs;
    [ randomChord.randomRootMidi, thirdMidi, fifthMidi, seventhMidi ] @=> randomChord.randomChordToneMidis;
    return randomChord;
}

// returns a random note in the specified octave and range
// with octave 1 being E2-E3 (MIDI 40-52), 2 being E3-E4 (MIDI 52-64)...
// and range defining the number of random notes after the octave root to choose from
fun RandomNote getRandomNote(int octave, int range) {
    RandomNote randomNote;
    // set octave range 
    e2 + (12 * (octave - 1) ) => int randomFloor;
    randomFloor + range => int randomCeiling;
    // generate random Midi note
    Std.rand2(randomFloor, randomCeiling) => randomNote.randomMidi;
    // convert random midi to frequency
    Std.mtof(randomNote.randomMidi) => randomNote.randomFreq;
    return randomNote;
}

fun string getUserGuess() {
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

// TODO guess major or minor
fun void playRandomChord(RandomChord randomChord) {
    0.1 => firstToneOsc.gain;  0.1 => secondToneOsc.gain;  0.1 => thirdToneOsc.gain;  0.1 => fourthToneOsc.gain;  
    randomChord.randomFreqs[0] => firstToneOsc.freq; randomChord.randomFreqs[1] => secondToneOsc.freq;
    randomChord.randomFreqs[2] => thirdToneOsc.freq; randomChord.randomFreqs[3] => fourthToneOsc.freq;
    string chordToneNames[];
    // if triad
    if( randomChord.triadOrSeventh) {
        [ noteNames[randomChord.randomChordToneMidis[0] % 12], noteNames[randomChord.randomChordToneMidis[1] % 12], 
        noteNames[randomChord.randomChordToneMidis[2] % 12] ] @=> chordToneNames;
    }
    // if seventh
    else {
        [ noteNames[randomChord.randomChordToneMidis[0] % 12], noteNames[randomChord.randomChordToneMidis[1] % 12], 
        noteNames[randomChord.randomChordToneMidis[2] % 12], noteNames[randomChord.randomChordToneMidis[3] % 12] ] @=> chordToneNames;
    }
    2::second => now;
    <<< "What note do you think the root of this chord is?" >>>;
    getUserGuess() => string userGuess;
    <<< "You guessed: " + userGuess >>>;
    <<< "That root note was: " + chordToneNames[0] >>>;
    // if triad
    if( randomChord.triadOrSeventh) { 
        <<<  "The other tones were: " + chordToneNames[1] + " " + chordToneNames[2] >>>;
        <<< "The chord was a triad" >>>;
    } 
    // if seventh
    else {
        <<< "The other tones were: " + chordToneNames[1] + " " + chordToneNames[2] + " " + chordToneNames[3] >>>;
        <<< "The chord was a seventh" >>>;
    }
    
    if( randomChord.majorOrMinor ) {
        <<< "The chord was major " >>>;
    } else {
     <<< "The chord was minor" >>>;    
    }
    if( userGuess == chordToneNames[0] ) {
        1.00 + correctGuesses => correctGuesses;   
    }
    5::second => now;
    0 => firstToneOsc.freq; 0 => secondToneOsc.freq;
    0 => thirdToneOsc.freq; 0 => fourthToneOsc.freq;
}

fun void playRandomNote(RandomNote randomNote) {
    0.1 => firstToneOsc.gain;  
    randomNote.randomFreq => firstToneOsc.freq;
    2::second => now;
    // look up random note frequency
    noteNames[randomNote.randomMidi % 12] => string noteName;
    <<< "What note do you think this is?" >>>;
    getUserGuess() => string userGuess;
    <<< "You guessed: " + userGuess >>>;
    <<< "That note was: " + noteName>>>;
    if( userGuess == noteName ) {
     1.00 + correctGuesses => correctGuesses;   
    }
    // providing time to match the note before stopping it
    5::second => now;
    0 => firstToneOsc.freq;
}
    
while( true ) {
    if( me.args() == 0 ) {
        <<< "Need to specify the following command line arguments: random note range" >>>;
        me.exit();   
    }
    <<< "Corect Guesses: " + correctGuesses >>>;
    <<< "Total Attempts: " + totalAttempts >>>;
    <<< "Percent Correct: " + percentCorrect + "%" >>>;
    // 0 = chord, 1 = true
    int note;
    int octave;
    // a random note will be selected between the octave and the octave + range
    Std.atoi(me.arg(0)) => int range;
    
    // 67 = C, 78 = N
    <<< "Press N to hear a note or C to hear a chord?" >>>;
    hid => now;
    while( hid.recv(hidMessage) )  {
        if( hidMessage.isButtonDown() ) { 
            if( hidMessage.ascii == 67  ) {
                0 => note;;
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
            hidMessage.ascii - 48 => octave;
        }
        100::ms => now;
    }
    
    if( 0 == note ) {
        getRandomChord(octave, range) @=> RandomChord randomChord;
        playRandomChord(randomChord);
    }
    
    if( 1 == note ) {
        // should just play E
        getRandomNote(octave, range) @=> RandomNote randomNote;
        playRandomNote(randomNote);
    }
    
    totalAttempts + 1.00 => totalAttempts;
    100.00 * (correctGuesses / totalAttempts ) => percentCorrect;
}

