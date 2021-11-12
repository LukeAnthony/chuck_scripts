// human interface device. subclass of event
Hid hi;
// gets used to hold info that comes out of a HID
HidMsg msg;

if( !hi.openKeyboard( 1 ) ) me.exit();
<<< "keyboard '" + hi.name() + "' ready", "" >>>;
// "Q",   "W",   "E", "R",  "A", "S",   "D",   "F",   "Z",   "X",  "C", "V"
[ "C", "C#/Db", "D", "Eb", "E", "F", "F#/Gb", "G", "G#/Ab", "A", "Bb", "B" ] @=> string noteNames[];
//"Q","W","E","R","A","S","D","F","Z","X","C","V"
[ 81, 87, 69, 82, 65, 83, 68, 70, 90, 88, 67, 86 ] @=> int asciiNumbersForKeyboardKeys[];

while( true ) {
    // wait on event
    hi => now;   
    
    // get one or more messages
    while( hi.recv(msg) )  {
        if( msg.isButtonDown() ) {
            <<< "down: ", msg.which, " ascii: ", msg.ascii >>>;
            for( 0 => int i; i < asciiNumbersForKeyboardKeys.cap(); i++) {
                if( msg.ascii == asciiNumbersForKeyboardKeys[i] ) {
                    <<< "You guessed: " + noteNames[i] >>>;
                }
            }
        }
        
    }
}