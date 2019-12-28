/**
Runs snake Ai
*/
SnakeAI sammy;

public void settings() { 
 size(800, 800);//Creates the canvas
}

 void setup(){
   System.out.println("Running SnakeAI");
   frameRate(120);
   sammy = new SnakeAI();
}

void draw(){
  //System.out.println("Running");
  sammy.update();
  sammy.displaySnake(); 
}
