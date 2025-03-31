class OrbList {

  OrbNode front;

  OrbList() {
    front = null;
  }//constructor

  void addFront(OrbNode o) {
    if (front == null){
      front = o;  //if there aren't any nodes, make front o
    }
    else{
      front.previous = o;
      o.next = front;
      front = front.previous;  //if there are nodes, add another node to front and reassign front
    }

  }//addFront


  void populate(int n, boolean ordered) {
    /*while (front != null){
      if (front.next == null){
        front = null;
      }
      else{
        front = front.next;
        front.previous = null;
      }
    }*/
    front = null;  //clears the list
    for (int i = 0; i < n; i++){
      if (ordered){
        addFront(new OrbNode(SPRING_LENGTH*(i+1), height/2, random(MIN_SIZE, MAX_SIZE), random(MIN_MASS, MAX_MASS), random(MIN_CHARGE, MAX_CHARGE))); 
      }
      else{
        addFront(new OrbNode());
      }
    }  //makes orbs according to ordered
  }//populate

  void display() {
    OrbNode current = front;
    while (current != null){
      current.display();
      current = current.next;  //loop through each item in the list and call display()
    }
  }//display

  void applySprings(int springLength, float springK) {
    OrbNode current = front;
    while (current != null){
      current.applySprings(springLength, springK);
      current = current.next;  //loop through each item in the list and call applySprings
    }

  }//applySprings

  void applyGravity(Orb other, float gConstant) {
    OrbNode current = front;
    while (current != null){
      current.applyForce(current.getGravity(other, gConstant));
      current = current.next;  //loop through each item in the list and get the gravity to use in applyForce
    }

  }//applyGravity

  void run(boolean boucne) {
    OrbNode current = front;
    while (current != null){
      current.move(boucne);
      current = current.next;  ////loop through each item in the list and call move
    }

  }//run

  void removeFront() {
    if (front != null && front.next != null){
      front = front.next;
      front.previous = null;
    }  //if front exists and front.next exists, reassign front to be front.next and make the former front null
    else if (front != null && front.next == null){
      front = null;
    }  //if front exists and front.next doesn't (ie front is the only item), make front null
  }//removeFront


  
  OrbNode getSelected(int x, int y) {
    OrbNode current = front;
    while (current != null){  //loop through
      if (current.isSelected(x,y)){
        return current;
      }  //if the current matches with what is selected, return current
      else{
        current = current.next;
      }  //if it doesn't, iterate to the next item in the list
    }
    return null;  //if none of them match, return null
  }//getSelected

  void removeNode(OrbNode o) {
    OrbNode current = front;
    while (current != null){  //loop through all the items in the list
      if (current == o){  //if current DOES match with o, we need to see what conditions there are
        if (current == front){
          if (front.next != null){
            front = front.next;
            front.previous = null;
            current = null;
          }  //if current IS front, and there is more than one item, then reassign front before making the former front null
          else{
            front = null;
            current = null;
          }  //if front is the only item, just make front null
          
        }
        else if (current.previous != null && current.next != null){
          current.previous.next = current.next;
          current.next.previous = current.previous;
          current = null;
        }  //if current is in the middle of the list, reassign the nexts and previous's of the surrounding nodes, then make current null
        else{
          current.previous.next = null;
          current = null;
        }  //if current.next doesn't exist (it's the last one in the list), then reassign current.previous.next and then make current null

      }
      else{  //if current DOESN'T match with o, iterate to the next item in the list
        current = current.next;
      }
    }
  }
}//OrbList
