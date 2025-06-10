
//Player class, will store the name of players and their color when they have to play

class Player{
  
  int n; //player number
  String namePlayer;
  int active; //player counter
  float x, y; //position of the player
  float w, h; //weidth and height of the player box
  color c; //color of the box
  boolean isOn = false; //boolean that will decide if the player has to play or not by applying color to it's box in the screen
    
  // Constructor  
  Player(int n, float x, float y, float w, float h){
    this.n = n; 
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.c = color(139,236,118);
  }
  
  String name(){
    String name = ("musicien_" + "_" + this.n);
    namePlayer = name;
    return name;
  }
    
  void display(){ 
    
    if (isOn){
      fill(c);
    }
    else {
      noFill();
    }
    stroke(0);
    rectMode(CORNER);
    rect(x,y,w,h); //Creating rectangle for the musician
    
    float fitText = min(w,h)/3;
    textSize(fitText);
    
    fill(0);
    textAlign(CENTER,CENTER); //showing player name at the center of the rectangle
    text(namePlayer + n,(x+w/2),(y+h/2)); //text should appear at the center of the box    
  }
}

class PlayerManager{
  
  ArrayList<Player> playerList; // list of players
  int n; // number of players from input
  boolean isInput = false; // boolean to turn to true once we have entered the number of musicians
  
  PlayerManager(){
    playerList = new ArrayList<Player>();
  }
  
  //
  void display() {
    if (isInput) {
      for (Player player : playerList) {
        player.display(); // Display each player
      }
    }
  }
  
  void addPlayer(Player player){
    playerList.add(player);
  }
  
  // Method that adds all players to the playertype Array
  void spawnPlayers(int n){
    
    float boxWidth = width/n;
    float boxHeight = 70;
    
    for (int i = 0; i<n ; i++){
      Player player = new Player(i+1, i* boxWidth, height-110, boxWidth, boxHeight);
      addPlayer(player);      
    }   
    isInput = true;
  }
 
  //Method to ask for number of players and then display them into the screen
  void start(){
    if (!isInput) {
    // Ask for the number of players
      fill(0);
      textAlign(CENTER,CENTER);
      text("Enter the number of musicians: " + n, width/2, height/2);
    } else {
    // Display the players
      this.display();
    }
  }
   
}
