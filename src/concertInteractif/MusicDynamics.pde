
// Storing all the instructions into a list and ready to display them

class Instructions{
  
 JSONObject instructions; //json that contains the instructions divided by category
 JSONArray currentList; //empty jsonArray that takes the form of one categorie acording to user input
 PFont apoFont;
 float x,y,z; //text position
 int index = -1; //starting is -1 to avoid printing anything
 float textSize = 50;
 boolean isVisible = false;
 float movSpeed = 0.2;
 float zPos;
 float alpha = 255;
 
 // Arrays for each category
 JSONArray _textural;
 JSONArray _rhythmic;
 JSONArray _abstract;
 JSONArray _silence;
 JSONArray _noise;
 
 Instructions(JSONObject list, float x, float y, float z){    
   this.instructions = list;  
   this.x = x;
   this.y = y;
   this.z = z;
   zPos = z;
   
   // Defining the font
   apoFont = createFont("Arial", 40, true);
   
   // Storing all the categories of the Instructions.json in an individual array
   _textural = instructions.getJSONArray("Textural"); //spawns in Bezier Shape
   _rhythmic = instructions.getJSONArray("Rhythmic"); //spawns in Points Shape
   _abstract = instructions.getJSONArray("Abstract"); //spawns in Traces type of Shape
   _silence = instructions.getJSONArray("Silence"); //spawns in Silence, no shape for it
   _noise = instructions.getJSONArray("Noise"); //spawns in Noise Shape
 }
 
 //Assigning each instruction category by using a string in the spawn method
 void spawn(String category){
   if (!isVisible && instructions != null){
     
      switch (category) {
        case "Textural":
          currentList = _textural;
          break;
        case "Rhythmic":
          currentList = _rhythmic;
          break;
        case "Abstract":
          currentList = _abstract;
          break;
        case "Silence":
          currentList = _silence;
          break;
        case "Noise":
          currentList = _noise;
          break;
        default:
          println("Invalid category: " + category);
          return;
      }
     index = int(random(currentList.size()));
     isVisible = true;
   }

 }
 
 void display(){
   if (isVisible && index >= 0){
     alpha -= movSpeed;
     if (alpha<0){
     alpha = 0;
   }
     fill(0,0,0,alpha);
     textSize(textSize);     
     textAlign(CENTER, BOTTOM);
     pushMatrix();
     translate(0,0,zPos);
     text(currentList.getString(index),x,y);
     popMatrix();
     
     //z axis move speed
     zPos -= movSpeed;
   }
 }
 
 void destroy(){
   isVisible = false;
   zPos = z;
   alpha = 255;
   }
}
