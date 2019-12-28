import java.util.Random; 
/**
Node consists of every body of the snake
Just an x,y integer along with the ability to retrieve

*/
public class Node {
   public int x,y;
   public int hCost, gCost;
   public boolean walkable;
   public Node parent;
   public int heapIndex;
   public int id;
  
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
   
   public int x(){
      return this.x; 
   }
   
   public int y(){
      return this.y; 
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
  
  public boolean isWalkable(){
    return this.walkable;
  }
   
   public void random(){
      Random r = new Random();
      this.x = r.nextInt(width/20);
      this.y = r.nextInt(height/20);
      
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


  
