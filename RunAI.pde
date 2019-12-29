/**
Runs snake Ai
*/
SnakeAI sammy;

public void settings() { 
 size(800, 800);//Creates the canvas
}

 void setup(){
   System.out.println("Running SnakeAI");
   frameRate(1200);
   sammy = new SnakeAI();
   sammy.poisonOn(); //Uncomment this line to see the game with posion tiles
}

void draw(){
  //System.out.println("Running");
  
  sammy.update();
  sammy.displaySnake(); 
}
