import oscP5.*;
import netP5.*;

OscP5 oscP5;
boolean found=false;
String ipNumber = "127.0.0.1";
int receivePort = 7301;
int sendPort = 7300;
NetAddress myRemoteLocation;
NetAddress myRemoteLocationEcho;
boolean sendOsc = false;
String oscChannelFormat = "OSCeleton"; // "Isadora", "OSCeleton, Animata"
boolean oscLocalEcho = false;
//1. OSCELETON / OPENNI / MS SDK
String[] osceletonNamesNormal = {
  "head", "neck", "torso", "r_shoulder", "r_elbow", "r_hand", "l_shoulder", "l_elbow", "l_hand", "r_hip", "r_knee", "r_foot", "l_hip", "l_knee", "l_foot"
};
String[] osceletonNamesReversed = { //standard non-mirrored
  "head", "neck", "torso", "l_shoulder", "l_elbow", "l_hand", "r_shoulder", "r_elbow", "r_hand", "l_hip", "l_knee", "l_foot", "r_hip", "r_knee", "r_foot"
};
//String[] osceletonNames = new String[15];
String[] osceletonNames = osceletonNamesReversed;
boolean modeOsc = true;

void oscSetup() {
    oscP5 = new OscP5(this, receivePort);
    myRemoteLocation = new NetAddress(ipNumber, sendPort);
    if(oscLocalEcho) myRemoteLocationEcho = new NetAddress("127.0.0.1", sendPort); 
}

//this is for receiving; not used here.
/*
void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/joint") && msg.checkTypetag("sifff")) {
    found = true;
    for (int i=0;i<osceletonNames.length;i++) {
      if (modeOsc&&msg.get(0).stringValue().equals(osceletonNames[i])) {
        x[i] = msg.get(2).floatValue();
        y[i] = msg.get(3).floatValue();
        z[i] = msg.get(4).floatValue();
      }
    }
  }
}
*/

void oscSendHandler(OscMessage _myMessage){
  try{
    oscP5.send(_myMessage, myRemoteLocation);
  }catch(Exception e){ }
  
  try{
  if(oscLocalEcho){
    oscP5.send(_myMessage, myRemoteLocationEcho);
  }
  }catch(Exception e){ }
}

void oscSend(){
    OscMessage myMessage;
    try{
        myMessage = new OscMessage("/tracker");
        
        myMessage.add(p.x);
        myMessage.add(p.y);
        myMessage.add(p.z);
        
        oscSendHandler(myMessage);
        println("Sending OSC to " + myRemoteLocation + " /tracker   x: " + p.x + " y: " + p.y + " z: " + p.z);
   }catch(Exception e){ }
}

/*
void oscSend(int skel) {
    OscMessage myMessage;

    int counter = 0;
    
    for (int i=0;i<osceletonNames.length;i++) {
      try{
        myMessage = new OscMessage("/joint"); // x
        myMessage.add(osceletonNames[i]);
        myMessage.add(skel);
        
        myMessage.add(x[i]);
        myMessage.add(y[i]);
        myMessage.add(z[i]);
        
        oscSendHandler(myMessage);
        //println("Sending OSC to " + myRemoteLocation + " " + osceletonNames[i] + " x: " + x[i] + " y: " + y[i] + " z: " + z[i]);
   }catch(Exception e){ }
    }
}
*/

