
//Timer class to spawn timer

class Timer{
  
  float timeLeft;
  float timeWindow; 
  Boolean restart = false;
  //positioning  
  float x, y;
  
  Timer( float timeWindow){
    this.timeWindow = timeWindow; 
    this.timeLeft = timeWindow; // it starts the same as the time window then it decreases
  }
  
  //Update timer by seconds
  void update(){
    if (timeLeft < 1.f){ //turn restart true if timeLeft goes below 1 sec
      restart = true;
    }
    else{
      restart = false;
    }
   }
   
   void setTimeLeft(float t){
     timeLeft = t;
     //println("timeLeft = " +timeLeft);
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
