
// Logic to manage the interaction

class LogicManager {
  
  int bez = 0, nois = 0, points = 0, txt = 0, trace = 0, nothing = 1;
  int play1 = 0, play2 = 0, play3 = 0, play4 = 0, play5 = 0, play6 = 0; //count of players 
  Timer timer;
  StringList IPStorage; //Dynamic array that stores different Ip's from incoming messages.
  int publicCounter = 0;
  
  
  LogicManager(Timer timer){
    this.timer = timer;
    this.IPStorage = new StringList();
  }
  
  //Method that listens for the /start message to send back the number of musicians to the audience apps
  void androidStart (OscMessage msg){  
    if (msg.checkAddrPattern("/start")){
    //Send OSC message to all android apps
      OscMessage nPlayers = new OscMessage("/nplayers");
      nPlayers.add(playerManager.n); //send the number of players to the android apps.
      oscp5.send(nPlayers, remoteLocation);
    }  
  }
  
  //Method that sends the current time to all other apps
  void sendTime(OscP5 oscp5, NetAddress address){
    OscMessage msg = new OscMessage("/timer");
    msg.add(timer.timeLeft);
    oscp5.send(msg, address);
    //println("sent oscMessage " + msg.typetag() + msg.get(0).floatValue());
  }
  
  //Method that turns on/off the players/musiciens
  void playerActivate (OscMessage msg){    
    if (msg.checkAddrPattern("/addIP")) {
      NetAddress sender = msg.netAddress(); // Get the sender's address
      String senderIP = sender.address(); // Extract the IP address
      if (!IPStorage.hasValue(senderIP)) { // Avoid duplicates
        IPStorage.append(senderIP); // Add the IP to the list
        println("Added Sender IP: " + senderIP);
      } else {
        println("IP already exists: " + senderIP);
      }
    }
  
    // Removes an IP from the Array
    if (msg.checkAddrPattern("/removeIP")) {
      NetAddress sender = msg.netAddress(); // Get the sender's address
      String senderIP = sender.address(); // Extract the IP address
      int index = IPStorage.index(senderIP); // Find the index of the IP
      if (index != -1) { // Check if the IP exists in the list
        IPStorage.remove(index); // Remove the IP using its index
        println("Removed Sender IP: " + senderIP);
      } else {
        println("IP not found: " + senderIP);
      }
    }
    
    // Counts votes for player activation and compares it to the total of IP's registered
    // After the concert it can be useful to spawn this based on the number of players of the concert    
    switch (msg.addrPattern()){
      case "/play1":
        int play1state = msg.get(0).intValue();
        play1 = play1 + play1state;
        println(play1);
        if (play1 <0){
          play1 = 0;
        }
  
        if (play1 > publicCounter/2) {
          Player player = playerManager.playerList.get(0);
          player.isOn = true;
        } 
        else {
          Player player = playerManager.playerList.get(0);
          player.isOn = false;
        }
        break;
  
      case "/play2":
        int play2state = msg.get(0).intValue();
        play2 = play2 + play2state;
        if (play2 <0){
          play2 = 0;
        }
        println(play2);
  
        if (play2 > publicCounter/2) {
          Player player = playerManager.playerList.get(1);
          player.isOn = true;
        } 
        else {
          Player player = playerManager.playerList.get(1);
          player.isOn = false;
        }
        break;
  
      case "/play3":
        int play3state = msg.get(0).intValue();
        play3 = play3 + play3state;
        println(play3);
        if (play3<0){
          play3 = 0;
        }  
        if (play3 > publicCounter/2) {
          Player player = playerManager.playerList.get(2);
          player.isOn = true;
        }
        else {
          Player player = playerManager.playerList.get(2);
          player.isOn = false;
        }
        break;
  
      case "/play4":
        int play4state = msg.get(0).intValue();
        play4 = play4 + play4state;
        println(play4);
        if(play4<0){
          play4=0;
        }
  
        if (play4 > publicCounter/2) {
          Player player = playerManager.playerList.get(3);
          player.isOn = true;
        } 
        else {
          Player player = playerManager.playerList.get(3);
          player.isOn = false;
        }
        break;
  
      case "/play5":
        int play5state = msg.get(0).intValue();
        play5 = play5 + play5state;
        println(play5);       
        if(play5<0){
          play5 = 0;
        }  
        if (play5 > publicCounter/2) {
          Player player = playerManager.playerList.get(4);
          player.isOn = true;
        } else {
          Player player = playerManager.playerList.get(4);
          player.isOn = false;
        }
        break;
  
      case "/play6":
        int play6state = msg.get(0).intValue();
        play6 = play6 + play6state;
        println(play6);
        if (play6<0){
          play6 = 0;
        }
        if (play6 > publicCounter/2) {
          Player player = playerManager.playerList.get(5);
          player.isOn = true;
        } 
        else {
          Player player = playerManager.playerList.get(5);
          player.isOn = false;
        }
        break;
        
      default :
        break;
    }
  }
  
  // OSC Method that listens to incoming messages
  void voteCounting (OscMessage msg){
    switch (msg.addrPattern()) {
      case "/texture":
        bez++; // Increment the vote for "bez" 
        println("bez= " + bez);
        break;

      case "/noise":
        nois++; // Increment the vote for "nois"
        println("noise= " + nois);
        break;

      case "/rhythmic":
        points++; // Increment the vote for "points"
        println("points= " + points);
        break;

      case "/silence":
        txt++; // Increment the vote for "txt"
        println("text= " + txt);
        break;

      case "/abstract":
        trace++; // Increment the vote for "trace"
        println("trace= " + trace);
        break;
        
      case "/skip":
        nothing++; // Increment the vote for "Nothing"
        println("nothing= " + nothing);
        break;

      default :
        break;
    } 
  }
  
  // Method to reset the votes, it's called in the update method inside the same class
  void resetVotes(){
    bez = 0;
    nois = 0;
    points = 0;
    txt = 0;
    trace = 0;
    nothing = 1;
  }
  
  // Method to find the winner from the voting window and return it as a String, it could return a Shape instead
  // It also spawns the winner of the round (Shape and Text)
  String returnChoice(){
    
    int[] votes = {bez, nois, points, txt, trace, nothing};
    int maxVotes = max(votes); //pick the one with most votes
    // Choose the winner
    if (bez == maxVotes) return "Bezier"; //Spawns Bezier shape and Textural Text
    if (nois == maxVotes) return "Noise"; //Spawns Noise shape and Noise Text
    if (points == maxVotes) return "Points"; //spawns Points shape and Rhythmic text
    if (txt == maxVotes) return "Text"; //
    if (trace == maxVotes) return "Traces";
    if (nothing == maxVotes) return "Nothing";
    return null;
  }
  
  // Update Method, selects the winner at the start of a new round, and returns a string, with the name of the winner
  void update(){
    if (timer.timeLeft == timer.timeWindow ){ 
      //println("round winner is " + returnChoice()); //test debug round winner
      returnChoice();
      shapeManager.spawnShape(returnChoice()); //Spawns the winning shape of each round
      resetVotes();       
    }
    publicCounter = IPStorage.size(); //Updates the number of voters by storing their IP's, when the Android app closes it sends removeIP osc message to remove it from the list
  }
}
