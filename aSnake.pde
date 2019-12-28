/**
SnakeAI

Child of the grid class which runs Astar
The basic mechanics are that the snake is played by it self using the grid and astar algorithm
*/
public class SnakeAI extends Grid {
  Node food;
  List<Node> body;
  private int x,y;  //x and y represent the head of the snake
  boolean panic = false;
  List<Node> poison;
  boolean showpoison;
  public SnakeAI(){
   super();
   food = new Node();
   food.random();
   
   //Begins body at the node
   body = new ArrayList<Node>();
   poison = new ArrayList<Node>();
   showpoison = false;
   body.add(new Node(0, 0, false));
   initPath(new PVector(this.x, this.y), new PVector(food.x, food.y));
    navigate();
  }
  
  void poisonOn(){
    showpoison = true;
  }
  
  void displaySnake(){
    display();
    
    fill(255, 255, 255);
      if(panic)
        fill(255, 0, 0);
    stroke(2);
    
    for(int i = 0; i < body.size(); i++){
       rect(body.get(i).x*20, body.get(i).y*20, 20, 20);
    }
    fill(20, 220, 20); 
    ellipse(food.x*20+10,food.y*20+10, 20, 20);
    fill(255, 0, 0);
    for(int i = 0; i < this.poison.size(); i++){
       //ellipse(poison.get(i).x*20+10, poison.get(i).y*20+10, 20, 20);
       rect(poison.get(i).x*20, poison.get(i).y*20, 20, 20);
    }
  }
  
  //If no path is currently available, move everyway you can until a path becomes available
  void stall(){
    panic = true;
    //System.out.println("STALLING");
    if(this.y > 0 && grid[x][y-1].walkable){//Go up
       path.add(grid[x][y-1]); 
    }
    else if(this.x > 0 && grid[x-1][y].walkable){//Go left
       path.add(grid[x-1][y]); 
    }
    else if(this.x < columns-1 && grid[x+1][y].walkable){//Go right
       path.add(grid[x+1][y]); 
    }
     else if(this.y < rows-1 && grid[x][y+1].walkable){//Go right
       path.add(grid[x][y+1]); 
    }
    else{
      //System.out.println("No path is available");
    }
    
  }
  
  /**
  Updates the snake, follows the path
  If path is mepty it will stall
  */
  void update(){
    while(path.size() == 0){
       //System.out.println("No path was found");
       initPath(new PVector(this.x, this.y), new PVector(food.x, food.y));
       navigate();
       //Astar();
       if(path.size() == 0)
         stall();
       else
         panic = false;
    }
    Node n = path.get(0);
    
    Node endNode = this.body.get(this.body.size()-1);
    //System.out.println(endNode.x + ", " +endNode.y);
    grid[endNode.x][endNode.y].open();
    for(int i = this.body.size()-1; i >= 1; i--){
        this.body.get(i).change(this.body.get(i-1).x(), this.body.get(i-1).y());
        grid[this.body.get(i).x][this.body.get(i).y].block();
        
    }
    this.x = n.x;
    this.y = n.y;
    this.body.get(0).change(this.x, this.y);
    if(this.x == food.x && this.y == food.y){
      foodEaten();
    }
    if(path.size() > 0){
      path.remove(0);
    }
    
    
    
  }
  /**
  When the food has been eaten, find a new position that does not exist on the snake of poison positions
  */
  void foodEaten(){
    if(this.showpoison){
      Node newpoison = new Node();
      newpoison.random();
      newpoison.walkable = false;
      newpoison.id = -1;
      while(grid[newpoison.x][newpoison.y].walkable == false){
        newpoison.random();
      }
      grid[newpoison.x][newpoison.y].walkable = false;
      grid[newpoison.x][newpoison.y].id = -1;  
      this.poison.add(newpoison);
    }
    food.random();
    while(grid[food.x][food.y].walkable == false){
      food.random();
    }
    displaySnake(); 
    initPath(new PVector(this.x, this.y), new PVector(food.x, food.y));
    body.add(new Node(0, 0, false));
    navigate();
  }
  
  
  /*
  List<Node> cloneSnake(){
    List<Node> clone = new ArrayList<Node>();
    for(int i = 0; i < this.body.size(); i++){
      clone.add(grid[body.get(i).x][body.get(i).y]);
    }
    return clone;
    
  }
  */
  //If the snake is of certain size, switch to this algorithm
  void navigate(){
    double a = body.size() *100;
    double x = a/((double)(columns*rows));
    System.out.println("body size: " + body.size() + "..." + x + "% of total size");
    if(body.size() < (columns *rows)*.0){//change to 0.7
      Astar();
      return;
    }
   initGrid();
   //ID the snake
   for(int i = 0; i < body.size(); i++){
     grid[body.get(i).x][body.get(i).y].id = i+1;
   }
   openSet.add(startNode);
   Node currentNode;
   while(openSet.size() > 0){
     /*
      currentNode = openSet.get(0);
    for (int i = 1; i < openSet.size(); i ++) {
        if (openSet.get(i).fCost() < currentNode.fCost() || openSet.get(i).fCost() == currentNode.fCost()) {
          if (openSet.get(i).hCost < currentNode.hCost)
            currentNode = openSet.get(i);
        }
      }
      */
     currentNode = openSet.RemoveFirst();
     closedSet.add(currentNode);
     if(currentNode == targetNode){//There may be a problem here with these not being equal
        retracePath();
        return;//Path was found
     } 
     
     //boolean a = currentNode.isWalkable();
     List neighbors = getNeighbors(currentNode);
     for(int i = 0; i < neighbors.size(); i++){
        Node neighbor = (Node)neighbors.get(i);
         
        if(neighbor.id == -1){//If poison
          continue;
        }
        if(!neighbor.isWalkable()){
           int distanceFromTail = this.body.size() - neighbor.id;
           if(currentNode.gCost > distanceFromTail){
               //If this is true, then the snake's tail as already moved out of this position
           }else{
               continue;  
           }
        }
        if(closedSet.contains(neighbors.get(i))){
          continue;
        }
        int newCostToNeighbor = getDistance(currentNode, neighbor) + currentNode.gCost;
        //May be a problem with this for loop bc I initialize gCost to be 0. But idk think so because it will be init first by open set
        if(newCostToNeighbor < neighbor.gCost || !openSet.contains(neighbor)){
            neighbor.gCost = newCostToNeighbor;
            neighbor.hCost = getDistance(neighbor, this.targetNode);
            neighbor.parent = currentNode;
            
            
            if(!openSet.contains(neighbor)){
              openSet.add(neighbor);
            }
        }
     }
   
   }
  }
  
}
