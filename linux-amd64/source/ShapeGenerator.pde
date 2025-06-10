

//Basic Shape class that contains the basic parameters needed for this shapes,
//like 3D position, movement, colors, and creation and destruction
class ShapeGen {
  
  float x,y,z;
  boolean isVisible = false;
  float movSpeed = 1.2; // for transposing the images
  float zPos; //variables to destroy automatically the shapes

  
  ShapeGen(float x, float y, float z){
    
    this.x = x;
    this.y = y;  
    this.z = z;
    this.zPos = z;
  }

  void display() {
    
    if (isVisible){
      
      fill(0);
      pushMatrix();
      translate(0, 0, zPos);
      rect(x,y,50,50);  
      popMatrix();
      zPos -= movSpeed;
    }      
  }
  
  void spawn(){
    
    if (!isVisible){
      isVisible = true;
    }  
  }
  
  void destroy(){
    isVisible = false;
    zPos = z;   
  }
}

//This inherited classes will create the types of shapes, I used inheritance because
//it can help future coders to optimize code

// This shape produces a pointillism figure

class ShapePoints extends ShapeGen {
  ArrayList<Point> points; // List to store points
  float lastSpawnTime; // Time of the last point spawn

  ShapePoints(float x, float y, float z) {
    super(x, y, z);
    points = new ArrayList<Point>();
    lastSpawnTime = millis(); // Initialize the last spawn time
  }

  void display() {
    if (isVisible) {
      // Move the shape along the z-axis
      zPos -= movSpeed;

      // Push the matrix for z-axis translation
      pushMatrix();
      translate(0, 0, zPos); // Apply z-axis movement

      // Spawn points randomly within a delay of 0.2 to 2 seconds
      if (millis() - lastSpawnTime > random(600, 2500)) {
        spawnRandomPoint();
        lastSpawnTime = millis(); // Reset the spawn timer
      }

      // Display and update points
      for (int i = points.size() - 1; i >= 0; i--) {
        Point p = points.get(i);
        p.display();
        p.update();

        // Remove the point if it has faded away
        if (p.alpha <= 0) {
          points.remove(i);
        }
      }

      // Pop the matrix after translation
      popMatrix();
    }
  }

  // Spawn a random point
  void spawnRandomPoint() {
    float randomX = random(width / 8, width - width / 8); // Random x position across the screen
    float randomY = random(height / 7, height - height / 7); // Random y position across the screen
    float randomSize = random(10, 50); // Random size for the ellipse
    int randomColor = color(random(0, 255), random(0, 50), random(0, 50)); // Random dark color
    points.add(new Point(randomX, randomY, randomSize, randomColor));
  }

  // Inner class to represent a point
  class Point {
    float px, py, size; // Position and size of the point
    int col; // Color of the point
    float alpha; // Transparency of the point

    Point(float px, float py, float size, int col) {
      this.px = px;
      this.py = py;
      this.size = size;
      this.col = col;
      this.alpha = 255; // Start fully opaque
    }

    void display() {
      fill(col, alpha); // Apply transparency
      noStroke();
      ellipse(px, py, size, size); // Draw the point
    }

    void update() {
      alpha -= 2; // Gradually fade out
    }
  }
}

// This produces some kind of Picasso shapes or animated lines
//class ShapeBezier extends ShapeGen {

class ShapeBezier extends ShapeGen {
  ArrayList<BezierFigure> bezierFigures; // List to store Bezier figures
  int numFigures = 15; // Number of Bezier figures
  int currentFigureIndex = 0; // Index of the figure currently being drawn

  ShapeBezier(float x, float y, float z) {
    super(x, y, z);
    bezierFigures = new ArrayList<BezierFigure>();

    // Create Bezier figures
    for (int i = 0; i < numFigures; i++) {
      bezierFigures.add(new BezierFigure());
    }
  }
  
  @Override
  void spawn(){
    
    isVisible = true;
    bezierFigures.clear();
    for(int i = 0; i < numFigures; i++){
      bezierFigures.add(new BezierFigure());
    }
    currentFigureIndex = 0;
    zPos = z;
  }
  
  @Override
  void destroy(){
    isVisible = false;
    bezierFigures.clear();
    currentFigureIndex = 0;
    zPos = z;
  }
  
  void display() {
    if (isVisible) {
      // Move the shape along the z-axis
      zPos -= movSpeed;
      pushMatrix();
      translate(0, 0, zPos); // Apply z-axis movement

      // Draw all completed figures
      for (int i = 0; i < currentFigureIndex; i++) {
        bezierFigures.get(i).displayFull();
      }

      // Draw the current figure incrementally
      if (currentFigureIndex < bezierFigures.size()) {
        BezierFigure currentFigure = bezierFigures.get(currentFigureIndex);
        currentFigure.update();
        currentFigure.display();

        // If the current figure is fully drawn, move to the next one
        if (currentFigure.isComplete()) {
          currentFigureIndex++;
        }
      }
      popMatrix();
    }
    else{
      destroy();     
    }
  }

  // Inner class to represent a Bezier figure
  class BezierFigure {
    float x, y;
    float x1, y1, x2, y2; // Start and end points
    float cx1, cy1, cx2, cy2; // Control points
    float r, g, b; // Color
    float t; // Parameter for drawing the curve incrementally

    BezierFigure() {
      // Initialize random positions for the points
      x = random(width);
      y = random(height);
      x1 = x + 40;
      y1 = y + 40;
      x2 = x1 + width/2;
      y2 = y1 + height/2 + 100;
      cx1 = random(width);
      cy1 = random(height);
      cx2 = random(width);
      cy2 = random(height);

      // Initialize random colors
      r = random(50, 255);
      g = random(50, 255);
      b = random(50, 255);

      // Initialize t
      t = 0; // Start drawing the curve from the beginning
    }

    void update() {
      // Increment t to draw more of the curve
      t += 0.005; // Adjust this value to control the drawing speed
      if (t > 1) {
        t = 1; // Stop drawing once the curve is fully drawn
      }
    }

    void display() {
      // Draw the curve incrementally
      if (isVisible){
        stroke(r, g, b, 120); // Semi-transparent stroke
        strokeWeight(1);
        fill(r, g, b, 70);
      }
      else{
        noStroke();
        noFill();
      }
      beginShape();
      for (float i = 0; i < t; i += 0.005) {
        float px = bezierPoint(x1, cx1, cx2, x2, i);
        float py = bezierPoint(y1, cy1, cy2, y2, i);
        vertex(px, py);
      }
      endShape();
    }

    void displayFull() {
      // Draw the full curve
      stroke(r, g, b, 60); // Semi-transparent stroke
      strokeWeight(1);
      fill(r, g, b, 100);
      bezier(x1, y1, cx1, cy1, cx2, cy2, x2, y2);
    }

    boolean isComplete() {
      // Check if the curve is fully drawn
      return t >= 1;
    }
  }
}

// This produces some kind of traces like from a brush in painting
//class ShapeTraces extends ShapeGen {

class ShapeTraces extends ShapeGen {
  int num = 40; // Number of points in the trace
  float[] mx = new float[num]; // Array to store x-coordinates
  float[] my = new float[num]; // Array to store y-coordinates
  float noiseOffsetX = random(3000); // Noise offset for x
  float noiseOffsetY = random(2000); // Noise offset for y

  ShapeTraces(float x, float y, float z) {
    super(x, y, z);
  }

  void display() {
    if (isVisible) {
      // Move the shape along the z-axis
      zPos -= movSpeed;

      // Update the noise-based trajectory
      int which = frameCount % num;
      mx[which] = width / 2 + sin(noise(noiseOffsetX) * TWO_PI) * width / 4; // Noise-based x-coordinate
      my[which] = height / 2 + cos(noise(noiseOffsetY) * TWO_PI) * height / 4; // Noise-based y-coordinate
      noiseOffsetX += random(0.001,0.01); // Increment noise offset for x
      noiseOffsetY += random(0.001,0.01); // Increment noise offset for y

      // Draw the trace
      pushMatrix();
      translate(0, 0, zPos); // Apply z-axis movement
      noStroke();
      fill(255, 0, 102, 153); // Semi-transparent red
      for (int i = 0; i < num; i++) {
        int index = (which + 1 + i) % num; // Get the correct index in the circular buffer
        ellipse(mx[index], my[index], i, i); // Draw the ellipse with increasing size
      }
      popMatrix();
    }
    else {
      destroy();
    }
  }
}

// This produces the a 2D visualisation of a noise waveform
class ShapeNoise extends ShapeGen {
  
  ShapeNoise(float x, float y, float z){
    super(x,y,z);
  }
  void display() {
    if (isVisible){
      
      fill(0, 169, 20);
      pushMatrix();
      translate(0, 0, zPos);
      rect(x,y,50,50);  
      popMatrix();    
      zPos -= movSpeed;
    }    
  }
}

//This will manage the creation and destruction of shapes
class ShapeManager{
  
  ArrayList<ShapeGen> shapes;
  String voteResult;
  ShapePoints figPoints;
  ShapeBezier figBez;
  ShapeNoise figNoise;
  ShapeTraces figTrace;

  ShapeManager(){
    shapes = new ArrayList<ShapeGen>();
    figPoints = new ShapePoints(width/2,50+height/2,100);
    shapes.add(figPoints);
    figBez = new ShapeBezier(width/2,50+height/2,100);
    shapes.add(figBez);
    figNoise = new ShapeNoise(width/2,50+height/2,100);
    shapes.add(figNoise);
    figTrace = new ShapeTraces(width/2,50+height/2,100);
    shapes.add(figTrace); 
  }
    
  void loadShapes(ShapeGen shape){
    shapes.add(shape);
  }

  // Method to display all shapes
  void displayShapes() {
    for (ShapeGen shape : shapes) {
      shape.display(); // Continuously
    }
  }
    
  void destroyShape(ShapeGen shape){
    shape.destroy();
    }

  void spawnShape(String voteResult){
    clearAllShapes();
    instructions.destroy();
    
    switch (voteResult) {
      case "Points":
        figPoints.spawn();
        instructions.spawn("Rhythmic");
        println("Spawning Points shape");
        break;

      case "Bezier":
        figBez.spawn();
        instructions.spawn("Textural");
        println("Spawning Bezier shape");
        break;

      case "Noise":
        figNoise.spawn();
        instructions.spawn("Noise");
        println("Spawning Noise shape");
        break;

      case "Traces":
        figTrace.spawn();
        instructions.spawn("Abstract");
        println("Spawning Traces shape");
        break;
      
      case "Text":
        instructions.spawn("Silence");
        println("Spawning Silence only");
        break;
        
      case "Nothing":
   //     println("Nothing happens");
        break;

      default:
        println("Unknown vote result: " + voteResult);
        break;
    }  
  }

  void clearAllShapes() {
    for ( ShapeGen shape : shapes){
      shape.destroy();
    }
  }
}
