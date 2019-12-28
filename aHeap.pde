/**
Built with Processing, works without it
Note: Uses Node class in Snake file
This creates an manages a minheap data structure
Jake Armendariz

Credits to https://github.com/SebLague/Pathfinding/tree/master/Episode%2004%20-%20heap/Assets/Scripts
I took a lot from this, even variable names.
I just changed for it to work as an array of Nodes
Goal is to shorten time needed to run
*/

public class Heap {
  Node[] items;
  int itemCount;
  public Heap(int maxSize){
    items = new Node[maxSize];
    itemCount = 0;
    
  }
  
  public void add(Node item){
     item.heapIndex = itemCount;
     items[itemCount] = item;
     sortUp(item);
     itemCount++;
  }
  
  //Removes from the top of the heap!
  public Node RemoveFirst(){
    Node firstItem = items[0];
    itemCount--;
    items[0] = items[itemCount];//Bottom right of the stack
    items[0].heapIndex = 0;
    sortDown(items[0]);
    return firstItem;
  }
  
  public void updateItem(Node item){
    sortUp(item); 
  }
  
  public boolean contains(Node item){
     return item.equals(items[item.heapIndex]); 
  }
  
  public int size(){
    return itemCount;
  }
  
  public void sortDown(Node item){
   while (true) {
      int childIndexLeft = item.heapIndex * 2 + 1;
      int childIndexRight = item.heapIndex * 2 + 2;
      int swapIndex = 0;

      if (childIndexLeft < this.itemCount) {
        swapIndex = childIndexLeft;

        if (childIndexRight < this.itemCount) {
          if (items[childIndexLeft].compareTo(items[childIndexRight]) < 0) {
            swapIndex = childIndexRight;
          }
        }

        if (item.compareTo(items[swapIndex]) < 0) {
          swap(item,items[swapIndex]);
        }
        else {
          return;
        }

      }
      else {
        return;
      }

    } 
  }
  
  
  public void sortUp(Node item){
    int parentIndex = (item.heapIndex-1)/2; 
    while(true){
       Node parentItem = items[parentIndex];
       if(item.compareTo(parentItem) > 0){
         swap(item, parentItem);
       }else{
         break;
       }
       parentIndex = (item.heapIndex-1)/2;
       
    }
  }
  
  public void swap(Node itemA, Node itemB){
    items[itemA.heapIndex] = itemB;
    items[itemB.heapIndex] = itemA;
    
    int itemAIndex = itemA.heapIndex;
    itemA.heapIndex = itemB.heapIndex;
    itemB.heapIndex = itemAIndex;
    
    
  }
  
  
  
}
