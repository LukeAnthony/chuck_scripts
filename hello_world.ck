// https://www.youtube.com/watch?v=M1Xexrf5h-o

// chuck has two types of variables that deal with time, "time" type and "duration" type
//     time describes a particular moment in time
//     using now in the context on line 6 is an example of the time type
//.             <<< now >>>;
//  use keyword dur for duration types   
//.     ex) 1::second => dur beat;


// How time works in Chuck
//      Set up a musical or sound scenario
//      Send a duration to 'now'
//      Chuck will play your sound for that duration
//      Chuck then stops and you describe the next sound
//      Start playback again by sending another duration to now


1::second / 2 => beat;

SinOsc osc => dac;