import java.util.Random; 
/**
The entire map is a 2D grid of Nodes
Just an x,y integer along with the ability to retrieve

id allows the map to differentiate between posion tiles and the snake
hCost and gCost maintain distance from start and target node in path finding
walkable tells whether the spot is blocked or not
parent points to the pointer for the Astar once destination is reached
unit is the size of everynode. The mapheight/unit * mapwidth/unit is the number of nodes
*/
public class Node {
   public int x,y;
   public int hCost, gCost;
   public boolean walkable;
   public Node parent;
   public int heapIndex;
   public int id;
   public int unit = 20;
  
   public Node(){
      this.x = 0;
      this.y = 0;
      this.walkable = true;
   }
   
   public Node(int x, int y, boolean _walkable){
     this.x = x;
     this.y = y;
     this.walkable = _walkable;
   }
   
   public void change(int x, int y){
      this.x = x;
      this.y = y;
   }
   
   public void update(int x, int y){
     this.x += x;
      this.y += y;
   }
   
  public int fCost(){
    return this.hCost = this.gCost;
  }
  
  public void block(){
     this.walkable = false;
  }
  
  public void open(){
     this.walkable = true;
  }
   //Used for assigning food and posion tiles
   public void random(){
      Random r = new Random();
      this.x = r.nextInt(width/unit);
      this.y = r.nextInt(height/unit);
      
   }
   
   public int compareInts(int a, int b){
     if(a==b)
         return 0;
     else if( a < b)
         return -1;
     else if(a > b)
         return 1;
      
      return 0;
      
   }
   
   public int compareTo(Node b){
     if(this.fCost() == b.fCost()){
       int hdiff = -1*compareInts(this.hCost, b.hCost);
        return hdiff;
          
     }
     return (-1*compareInts(this.fCost(), b.fCost()));
   }
   
   void displayText(){
     textSize(8);
     fill(255);
     text(fCost(), x*20+10, y*20+10);
   }
}


  
