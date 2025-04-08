class OrbList { // OrbList class that will control behavior of a linked list of orb nodes
  OrbNode front;

  OrbList() {
    front = null;
  }//constructor

  void addFront(OrbNode o) {
    if (front == null) {
      front = o;  //if there aren't any nodes, make front o
    }
    else{
      front.previous = o;
      o.next = front;
      front = front.previous; //if there are nodes, add another node to front and reassign front
    }

  }//addFront
  void populate(int n, boolean ordered) {
    front = null;  //clears the list
    for (int i = 0; i < n; i++){
      if (ordered) {
        addFront(new OrbNode(SPRING_LENGTH*(i+1), height/2, random(MIN_SIZE, MAX_SIZE), random(MIN_MASS, MAX_MASS), random(MIN_CHARGE, MAX_CHARGE)));
      }
      else {
        addFront(new OrbNode());
      }
    }//makes orbs according to ordered
  }//populate

  void display(boolean ifSpring) {
    OrbNode current = front;
    while (current != null) {
      current.display(ifSpring);
      current = current.next;  // loop through each item in the list and call display()
    }
  }//display

  void applySprings(int springLength, float springK) {
    OrbNode current = front;
    while (current != null) {
      current.applySprings(springLength, springK);
      current = current.next;  // loop through each item in the list and call applySprings
    }
  }//applySprings

  void applyGravity(Orb other, float gConstant) {
    OrbNode current = front;
    while (current != null) {
      current.applyForce(current.getGravity(other, gConstant));
      current = current.next; // loop through each item in the list and get the gravity to use in applyForce
    }
  }//applyGravity
  
  void applyDrag(){
    OrbNode current = front;
    while (current != null) {
      if (current.center.y < height/2) { // if the orb is in the Solar System
        current.applyForce(current.getDragForce(D_COEF_SOLAR)); // calculate and apply the drag force
      }
      else if (current.center.y > height/2) { // if the orb is in the Alpha Centauri system
        current.applyForce(current.getDragForce(D_COEF_ALPHA)); // calculate and apply the drag force
      }
      current = current.next;  // loop through each item in the list
    }
  }//applyDrag
  
  void applyElectrostatic(float kConstant) {
    OrbNode current = front;
    while (current != null) {
      OrbNode toCompare = front;
      while (toCompare != null) {
        if (current != toCompare) { // Avoid self-interaction
          current.applyForce(current.getElectrostaticForce(toCompare, kConstant)); // calculate and apply electrostatic force between two charged orb nodes
        }
        toCompare = toCompare.next; // iterating through the orb nodes to exert electrostatic force on, for each orb node
      }
      current = current.next; // iterate to the next item in the linked list
    }
  }
  
  void run(boolean bounce) {
    OrbNode current = front;
    while (current != null) {
      current.move(bounce);
      current = current.next; // loop through each item in the list and call move
    }
  }//run

  void removeFront() {
    if (front != null && front.next != null) {
      front = front.next;
      front.previous = null;
    }  //if front exists and front.next exists, reassign front to be front.next and make the former front null
    else if (front != null && front.next == null) {
      front = null;
    }  //if front exists and front.next doesn't (ie front is the only item), make front null
  }//removeFront
  
  OrbNode getSelected(int x, int y) {
    OrbNode current = front;
    while (current != null) {  //loop through
      if (current.isSelected(x,y)) {
        return current;
      }  //if the current matches with what is selected, return current
      else{
        current = current.next;
      }  //if it doesn't, iterate to the next item in the list
    }
    return null;  //if none of them match, return null
  }//getSelected
  
  /** addNode(int index) method that basically adds a node in the linked list between the specified index and the one after it **/
  void addNode(int index) {
    OrbNode current = front; // initially set the current node to the front node
    int count = 0; // count variable that will act as the current index when looping through the linked list
    OrbNode addedNode = new OrbNode(); // the new node to be added
    while (current != null) { // loop through all the items in the list
      if (index == count) { // if the specified index matches with the current index, we need to see what conditions there are
        if (current == front) {
          if (front.next != null) {
            OrbNode nextNode = front.next;
            front.next.previous = null;
            front.next = null;
            front.next = addedNode;
            addedNode.previous = front;
            addedNode.next = nextNode;
            nextNode.previous = addedNode;
            //println(addedNode.previous);
            //println(addedNode.next);
          } // if current IS front, and there is more than one item, then create linkages between the front node and the next node after, to the new addedNode
          else {
            addFront(addedNode);
          } // if front is the only item, just run the addFront method with addedNode as the argument for an OrbNode (adds OrbNode to the front)
        }
        else if (current.previous != null && current.next != null) {
          current.next.previous = addedNode;
          addedNode.next = current.next;
          current.next = addedNode;
          addedNode.previous = current;
        } // if current is in the middle of the list, relink the next nodes and previous nodes of the surrounding nodes to addedNode
        else {
          current.next = addedNode;
          addedNode.previous = current;
        } // if current.next doesn't exist (it's the last one in the list), then reassign current.next to be the new addedNode (and addedNode.previous to be the current node)
      }
      else { // if the specified index DOESN'T match with the current index, iterate to the next node in the linked list, while also incrementing the index value
        current = current.next;
        count++;
      }
    }
  }//addNode

  void removeNode(OrbNode o) {
    OrbNode current = front;
    while (current != null) {  //loop through all the items in the list
      if (current == o) {  //if current DOES match with o, we need to see what conditions there are
        if (current == front) {
          if (front.next != null) {
            front = front.next;
            front.previous = null;
            current = null;
          }  //if current IS front, and there is more than one item, then reassign front before making the former front null
          else {
            front = null;
            current = null;
          }  //if front is the only item, just make front null
        }
        else if (current.previous != null && current.next != null) {
          current.previous.next = current.next;
          current.next.previous = current.previous;
          current = null;
        }  //if current is in the middle of the list, reassign the nexts and previous's of the surrounding nodes, then make current null
        else {
          current.previous.next = null;
          current = null;
        }  //if current.next doesn't exist (it's the last one in the list), then reassign current.previous.next and then make current null

      }
      else {  //if current DOESN'T match with o, iterate to the next item in the list
        current = current.next;
      }
    }
  }//removeNode
}//OrbList
