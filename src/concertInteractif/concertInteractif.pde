/* Program for an interactive percussion concert
    APO33
    Author: Snati1206
*/

// Importing the OSC libraries to communicate with the users android app
import netP5.*;
import oscP5.*;
// Importing hashmap libraries to create a dictionary type of data structure
//import java.util.HashMap;
 
int backgroundColor = 255;

// Declaring the object that spawns the shapes
ShapeManager shapeManager;

// Declaring the object that spawns text
JSONObject instructionsList; 
Instructions instructions;

// Declaring the Timer that shows at the bottom
Timer timer;

// Declaring the number of musicians
PlayerManager playerManager;
boolean isInputIn = false;
String userInput = "";
int numPlay; // number of musicians

// Temp stuff
String[] playNames = {"Nat","Jules","Jen","Rom","Gab"};

// Declaring the object destruction max range in z
float MaxRange = -2000;

// Declaring the votingManager

LogicManager logicManager;

// Section for the OSC connections and sending of Data
OscP5 oscp5;
NetAddress remoteLocation;

void setup()
{
  fullScreen(P3D);
  background(backgroundColor);
  
  // The shapes go here  
  shapeManager = new ShapeManager();
  
  // The text spawner goes here
  instructionsList = loadJSONObject("instructions.json");
  instructions = new Instructions(instructionsList, width/2, height/2, 0);
  
  // The timer goes here
  timer = new Timer(30);  
  
  // The playerManager goes here
  playerManager = new PlayerManager();
  
  // The Osc stuff goes here  
  oscp5 = new OscP5(this,8000);
  remoteLocation = new NetAddress("192.168.8.255", 7500);
  
  // The voting logic goes here
  logicManager = new LogicManager(timer);
  
}

void draw()
{
  background(backgroundColor);
  
  //Display text
  fill(0);
  textSize(60);     
  textAlign(CENTER, BOTTOM);
  text("CHOIX POUR PERCUSSION",width/2,height -7*height/8 );
  
  //Ask for number of musicians
  playerManager.start();
  
  //Text related stuff
  instructions.display();
  
  //Draw Shapes
  shapeManager.displayShapes(); //need to change this to display only the one that matches the winning shape of each round
  
  //Draw Timer
  timer.update();
  timer.display(width/2,height-20);
  
  //Voting Logic calls spawnShape after each round spawning the winning shape and also the associated instructions from text
  logicManager.update();
  logicManager.sendTime(oscp5, remoteLocation);
}

void keyPressed()
{
  if (key == 'b'){
    timer.restart = true;
  }
  if (key == 'c'){
    instructions.destroy();
    timer.restart = false;
  }
  if (key == 's'){
    if (playerManager.playerList.size() == playNames.length){
      for (int i = 0; i < playerManager.playerList.size(); i++){
        Player player = playerManager.playerList.get(i);
        player.namePlayer = playNames[i];
    }    
   }
     logicManager.sendTime(oscp5,remoteLocation);
  }
  
  // stores the number of musicians when the input is an int and then ENTER RETURN
  if (!isInputIn) {
    if (key == ENTER || key == RETURN) {
      // Process the input when Enter is pressed
      int n = int(userInput);
      isInputIn = true; // input marked as complete
      playerManager.spawnPlayers(n);
    } 
    else if (key != CODED) {
      // Append the typed character to the input
      userInput += key;
      playerManager.n = int(userInput);
    }    
  }
    
  if (key == 'p'){
    for (int i = 0; i < playerManager.playerList.size(); i++){
      Player player = playerManager.playerList.get(i); 
      println(player.name());
      println(player.isOn);
    }      
  }
  
  if (key == 'i'){
    println("number of IP's = " + logicManager.publicCounter);
  }
}


void oscEvent(OscMessage msg) {
  println("Received OSC message: " + msg.addrPattern()); 
  // Forward the message to LogicManager
  logicManager.voteCounting(msg);
  logicManager.playerActivate(msg);
  logicManager.androidStart(msg);
}

void exit(){
  oscp5.stop(); // Stop the OSC server
  super.exit(); // Call the default exit behavior
}

  
