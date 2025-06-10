
//Method to remove your IP from the IP array in the main program
void removeIp(OscP5 oscp5, NetAddress address ){  
  OscMessage removeIp = new OscMessage("/removeIP");
  oscp5.send(removeIp, address);
  println("removeIp message sent");
}

// Updates time from the main program //TEEEEST
void timeLeft(OscMessage msg){
  if (msg.checkAddrPattern("/timer")==true){
    timeCurrent = msg.get(0).floatValue();
    println("timeCurrent = " + timeCurrent);
  }
}

void nplayers(OscMessage msg){
  if (msg.checkAddrPattern("/nplayers")){
    n = msg.get(0).intValue(); //n players 
  }
}

// Send the Start Method when launching the app, and the addIP
void sendStart(OscP5 oscp5, NetAddress address){
  if(oscp5 != null && mainAddress != null){
    OscMessage startMessage = new OscMessage("/start");
    OscMessage sendIp = new OscMessage("/addIP");
    oscp5.send(startMessage, address);
    oscp5.send(sendIp, address);
  }
  else {
    println("Oscp5 or mainAddres not recognized");
  }
}
