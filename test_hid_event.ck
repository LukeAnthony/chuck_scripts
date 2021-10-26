Hid hi;
HidMsg msg;

// open keyboard (get device number from command line)
if( !hi.openKeyboard( 1 ) ) me.exit();


while( true ) {
    
    string noteOrChord;
    <<< "note or chord" >>>;
    hi => now;   
 
    while( hi.recv(msg) ) {
     
     if( msg.isButtonDown() ) {
         if( msg.ascii == 67 ) {
          "chord" => noteOrChord;
         }
         else {
          "note" => noteOrChord;   
         }
         100::ms => now;
     }  
  }
  
  <<< noteOrChord >>>;
    
}