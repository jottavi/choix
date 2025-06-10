
//Button class to spawn them with OscAddress and position

class Button{
  
  String name;
  String messageAddress;
  boolean isActive = false;
  boolean isVisible = true; //can adjust it 
  boolean isSent = false; //if 
  float x,y,w,h;
  
  Button(String name, String messageAddress,float x,float y,float w,float h){      
    this.name = name;
    this.messageAddress = messageAddress;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  void display(){    
    if(isVisible){
      if(isActive){
        fill(139,236,118);
      }
      else{
        noFill();
      }
    stroke(0);
    rectMode(CORNER);
    rect(x,y,w,h,10);
    }
    float buttonTextSize = min(w, h) / 3; // Adjust text size based on button dimensions
    textSize(buttonTextSize);
    fill(0);
    textAlign(CENTER,CENTER); //showing player name at the center of the rectangle
    text(name,(x+w/2),(y+h/2)); //text should appear at the center of the box 
  }
  
  void spawn(){
    isVisible = true;
  }
  
  void destroy(){
    isVisible = false;
  }
  
  void active(){
    isActive = true;
  }
  
  //need to change methods, only use this for sending adding ip or removing it
  void handleTouch(float touchX, float touchY){
    if (isInsideButton(touchX, touchY)){
      isActive = !isActive;
      if(isActive){
        sendStart(oscp5, mainAddress);
      }
      else{
        removeIp(oscp5, mainAddress);
      }      
    }    
  }
  boolean isInsideButton(float touchX, float touchY){
    return (touchX > x && touchX < x+w && touchY > y &&touchY < y+h);
  }
}

// class to spawn playerButtons
class PlayerButtonManager{
  ArrayList<Button> playerButtons; //array of buttons
  int n; // number of buttons
  
  PlayerButtonManager(){
    playerButtons = new ArrayList<Button>();
  }
  
  void display(){
    for (Button button : playerButtons){
      button.display();
    }
  }
  
  void addButton(Button button){
    playerButtons.add(button);
  }
   
  void spawn(int n){
    
    float boxWidth = width/n;
    float boxHeight= 70;
    
    for (int i = 0; i<n; i++){
      Button button = new Button("musician " + (i+1), "/play" + (i+1), i* boxWidth, height- height/4, boxWidth, boxHeight);
      addButton(button);
    } 
  }
  
  void handleTouch(float touchX, float touchY){
    for (Button button : playerButtons){
      if (isInsideButton(button, touchX, touchY)){
        button.isActive = !button.isActive;
        sendPlayerState(button.messageAddress, button.isActive);
      }  
    }      
  }
  
  void sendPlayerState(String address, boolean state){    
    if (oscp5!= null && mainAddress != null){
      OscMessage msg = new OscMessage(address);
      msg.add(state ? 1 : -1);
      oscp5.send(msg, mainAddress);
      println(address + " sent = " + msg.get(0).intValue());
    }

  
  }
  
  boolean isInsideButton(Button button, float touchX, float touchY){
    return touchX > button.x && touchX< button.x + button.w && touchY > button.y && touchY < button.y + button.h;
  }
}

// class to spawn musicChoiceButtons
class MusicButtonManager{
  
  ArrayList<Button> musicButtons;
  StringDict musicButtonsList;
  int n;
  boolean choiceMade = false; //tracks if a choice has been made
  
  MusicButtonManager(){
    musicButtonsList = new StringDict();
    musicButtons = new ArrayList<Button>();
  }
  
  void display(){
    for (Button button : musicButtons){
      button.display();
    }    
  }
  
  void addButton(Button button){
    musicButtons.add(button);
  }
  
  void spawn(String[] category, String[] address){
    if( category.length == address.length){
      
      float boxWidth = width/category.length;
      float boxHeight = 80;
      
      for (int i = 0; i<category.length; i++){
        Button button = new Button(category[i], address[i], i*boxWidth, height - 2*height/4, boxWidth, boxHeight);
        addButton(button);
      }    
    }    
  }

  void handleTouch(float touchX, float touchY){
    if (!choiceMade){
      for (Button button : musicButtons){
        if (isInsideButton(button, touchX, touchY)){
          button.active();
          sendMusicVote(button.messageAddress);
          choiceMade = true;
          break;
        }
      }
    }
  }

  void resetVote(){
    choiceMade = false;
    for (Button button : musicButtons){
      button.isActive = false;
    }
  } 

  boolean isInsideButton(Button button, float touchX, float touchY){
    return touchX > button.x && touchX< button.x + button.w && touchY > button.y && touchY < button.y + button.h;
  }

  void sendMusicVote(String address){
    OscMessage msg = new OscMessage(address);
    oscp5.send(msg, mainAddress);
    println("Osc message sent: " + address);
  } 
}
