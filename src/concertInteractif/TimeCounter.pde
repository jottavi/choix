
//Timer that opens a window for the public to choose the next musical actions

class Timer{
  
  float timeLeft;
  float timeWindow;
  boolean restart = false; //bool to trigger a changement of scene by the public  
  //positioning  
  float x, y;
  
  Timer(float timeIn){
    this.timeWindow = timeIn; 
    this.timeLeft = timeIn; // it starts the same as the time window then it decreases
  }
  
  //Update timer by seconds
  void update(){
    
    if (restart != false){
      if (timeLeft > 0){
      timeLeft -= 1.0/frameRate; //reduce time that's left in seconds and limit it at 0
      } 
      else {
        timeLeft = 0;
        restart = false;
      }    
    }    
    else {
      timeLeft = random(20,timeWindow);
      timeWindow = timeLeft;
      restart = true;
    }    
   }

  //asigns a position to the timer bar
  void display(float x, float y){
    
    this.x = x;
    this.y = y;
    fill(0,0,0);
    float rectWidth = map(timeLeft, 0, timeWindow, 0, width-100); // Map timeLeft to rectangle width
    rectMode(CENTER);
    rect(x, y, rectWidth, 20, 5); // Draw the rectangle    
  }  
}
