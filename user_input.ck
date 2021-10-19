// human interface device. subclass of event
Hid hi;
// gets used to hold info that comes out of a HID
HidMsg msg;

if( !hi.openKeyboard( 1 ) ) me.exit();
<<< "keyboard '" + hi.name() + "' ready", "" >>>;

while( true ) {
    // wait on event
    hi => now;   
    
    // get one or more messages
    while( hi.recv(msg) )  {
        if( msg.isButtonDown() ) {
            <<< "down: ", msg.which, " ascii: ", msg.ascii >>>;
        }
        
    }
}