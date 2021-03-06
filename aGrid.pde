/**
Jake Armendariz
aGrid

Built with Processing
It has the ability to find the shortest path between startNode and targetNode
non-walkable nodes, assigned by addBlock are obstacles for A*
This implementation does not allow for diagnol jumps, it would be more efficient with diagnols
but I wanted this algorithm to work on the snake game.

Feel free to use this code for whatever you would like, you can give me credit but the real hero is Sebastian Lague
I will link his github and youtube tutorials
(This person coded it in C-sharp Unity instead of processing so code looks very different)
https://github.com/SebLague/Pathfinding
https://www.youtube.com/watch?v=mZfyt03LDH4&list=PLFt_AvWsXl0cq5Umv3pMC9SPnKjfp9eGW&index=3
*/
import java.util.*;
public class Grid {
 Node[][] grid;
 int columns, rows;
 Node startNode, targetNode;
 //List <Node> openSet;
 Heap openSet;
 List<Node> closedSet;
 List<Node> path;
 //List<Node> snakelist;
 
 public Grid(){
   Node N = new Node();
   this.columns = (int)width/N.unit;
   this.rows = (int)width/N.unit;
   
   grid = new Node[rows][columns];
   for(int i = 0; i < rows; i ++){
        for(int j = 0; j < columns; j++){
          grid[i][j] = new Node(i, j, true);
        }
   }
   
   //this.openSet = new ArrayList<Node>();
   this.openSet = new Heap(columns*rows);
   this.closedSet = new ArrayList<Node>();
   this.path = new ArrayList<Node>();
 }
 
 //Inititates a new Grid (not really, but allows the Astar algorithm to run again)
 public void initGrid(){
   //this.openSet = new ArrayList<Node>();
   this.openSet = new Heap(columns*rows);
   this.closedSet = new ArrayList<Node>(); 
   this.path = new ArrayList<Node>();
   for(int i = 0; i < rows; i ++){
        for(int j = 0; j < columns; j++){ 
          grid[i][j].gCost = 0;
          grid[i][j].hCost = 0;
          if(grid[i][j].id != -1){
            grid[i][j].id = 0;
          }
        }
   }
   
   
   
 }
 
 //Draws the color of nodes depending on their use
 //Black is the base map
 //white is the path
 //Maroon is the obstacle in the path
 //Blue is the open set
 //Gray is the closed set
 public void display(){
     for(int i = 0; i < rows; i ++){
        for(int j = 0; j < columns; j++){ 
           noStroke();
           fill(30 + i, 30 + j, 30 + (i+j)/2);
           fill(10, 10, 10);
           Node N = grid[i][j];
           
           if(closedSet.contains(N)){
             //fill(155, 155, 155); 
           }
           if(openSet.contains(N)){
             //fill(55, 55, 155); 
           }
           if(this.path.contains(N)){
             //fill(20, 220, 20); 
           }//
           if(!N.walkable){
            //s fill(100, 0, 0);
           }
           int unit = N.unit;
           rect(N.x*unit, N.y*unit, unit, unit);
           //grid[i][j].displayText();
        }
     }
 }
 
 //Sets the start and target vector
 public void initPath(PVector start, PVector target){
   if(start.x >= 0 && start.x < this.columns && start.y >= 0 && start.y < this.rows) {
     if(target.x >= 0 && target.x < this.columns && target.y >= 0 && target.y < this.rows) {
       this.startNode = this.grid[(int)start.x][(int)start.y];
       this.targetNode =  this.grid[(int)target.x][(int)target.y];
       return;
     }
   }
    System.out.println("Could not inititate path, start and target vectors are not within bounds");
 }
 
 
 
 //Adding a block makes the node unwalkable
 public void addBlock(int x, int y){
      grid[x][y].block();
 }
 
 //Unblocks
 public void freeBlock(int x, int y){
       grid[x][y].open();
 }
 
 /**
 A* path finder
 it finds the shortest path
 does not use diagnoals
 */
 public void Astar(){
   initGrid();
   openSet.add(startNode);
   Node currentNode;
   while(openSet.size() > 0){
      currentNode = openSet.RemoveFirst();
    /*
    currentNode = openSet.get(0);
    for (int i = 1; i < openSet.size(); i ++) {
        if (openSet.get(i).fCost() < currentNode.fCost() || openSet.get(i).fCost() == currentNode.fCost()) {
          if (openSet.get(i).hCost < currentNode.hCost)
            currentNode = openSet.get(i);
        }
      }
     */
     closedSet.add(currentNode);
     if(currentNode == targetNode){//There may be a problem here with these not being equal
        retracePath();
        return;//Path was found
     } 
     
     //boolean a = currentNode.isWalkable();
     List neighbors = getNeighbors(currentNode);
     for(int i = 0; i < neighbors.size(); i++){
        Node neighbor = (Node)neighbors.get(i);
        if(!neighbor.walkable || closedSet.contains(neighbors.get(i))){
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
 
 //Adds the path, allows us to display it
 void retracePath(){
   path = new ArrayList<Node>();
    Node currentNode = this.targetNode;
    while(currentNode != this.startNode){
       path.add(currentNode);
       currentNode = currentNode.parent;
    }
   path.add(currentNode);
   Collections.reverse(path);
 }
 //Distance between two nodes, used in A*
 int getDistance(Node start, Node end){
   int dstX = Math.abs(start.x - end.x);
   int dstY = Math.abs(start.y - end.y);
   
   return (dstX + dstY);
 }
 
 //Gives the non-diagnoal neighbors
 public List<Node> getNeighbors(Node N){
   List<Node> neighbors = new ArrayList<Node>();
   int x = N.x;
   int y = N.y;
   if(x > 0)
       neighbors.add(grid[x-1][y]);
    if(x < columns-1)
       neighbors.add(grid[x+1][y]);
    if(y > 0)
       neighbors.add(grid[x][y-1]);
    if(y < rows-1)
       neighbors.add(grid[x][y+1]);
       
     return neighbors;
 }
  
  
}
