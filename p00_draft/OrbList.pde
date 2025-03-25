/*===========================
  OrbList (ALL WORK GOES HERE)

  Class to represent a Linked List of OrbNodes.

  Instance Variables:
    OrbNode front:
      The first element of the list.
      Initially, this will be null.

  Methods to work on:
    0. addFront
    1. populate
    2. display
    3. applySprings
    4. applyGravity
    5. run
    6. removeFront
    7. getSelected
    8. removeNode

  When working on these methods, make sure to
  account for null values appropraitely. When the program
  is run, no NullPointerExceptions should occur.
  =========================*/

class OrbList {

  OrbNode front;

  /*===========================
    Contructor
    Does very little.
    You do not need to modify this method.
    =========================*/
  OrbList() {
    front = null;
  }//constructor

  /*===========================
    addFront(OrbNode o)

    Insert o to the beginning of the list.
    =========================*/
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


  /*===========================
    populate(int n, boolean ordered)

    Clear the list.
    Add n randomly generated  orbs to the list,
    using addFront.
    If ordered is true, the orbs should all
    have the same y coordinate and be spaced
    SPRING_LEGNTH apart horizontally.
    =========================*/
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
        addFront(new OrbNode(SPRING_LENGTH*(i+1), height/2, random(MIN_SIZE, MAX_SIZE), random(MIN_MASS, MAX_MASS))); 
      }
      else{
        addFront(new OrbNode());
      }
    }  //makes orbs according to ordered
  }//populate

  /*===========================
    display(int springLength)

    Display all the nodes in the list using
    the display method defined in the OrbNode class.
    =========================*/
  void display() {
    OrbNode current = front;
    while (current != null){
      current.display();
      current = current.next;  //loop through each item in the list and call display()
    }
  }//display

  /*===========================
    applySprings(int springLength, float springK)

    Use the applySprings method in OrbNode on each
    element in the list.
    =========================*/
  void applySprings(int springLength, float springK) {
    OrbNode current = front;
    while (current != null){
      current.applySprings(springLength, springK);
      current = current.next;  //loop through each item in the list and call applySprings
    }

  }//applySprings

  /*===========================
    applyGravity(Orb other, float gConstant)

    Use the getGravity and applyForce methods
    to apply gravity crrectly.
    =========================*/
  void applyGravity(Orb other, float gConstant) {
    OrbNode current = front;
    while (current != null){
      current.applyForce(current.getGravity(other, gConstant));
      current = current.next;  //loop through each item in the list and get the gravity to use in applyForce
    }

  }//applyGravity

  /*===========================
    run(boolean bounce)

    Call run on each node in the list.
    =========================*/
  void run(boolean boucne) {
    OrbNode current = front;
    while (current != null){
      current.move(boucne);
      current = current.next;  ////loop through each item in the list and call move
    }

  }//run

  /*===========================
    removeFront()

    Remove the element at the front of the list, i.e.
    after this method is run, the former second element
    should now be the first (and so on).
    =========================*/
  void removeFront() {
    if (front != null && front.next != null){
      front = front.next;
      front.previous = null;
    }  //if front exists and front.next exists, reassign front to be front.next and make the former front null
    else if (front != null && front.next == null){
      front = null;
    }  //if front exists and front.next doesn't (ie front is the only item), make front null
  }//removeFront


  /*===========================
    getSelected(float x, float y)

    If there is a node at (x, y), return
    a reference to that node.
    Otherwise, return null.

    See isSlected(float x, float y) in
    the Orb class (line 115).
    =========================*/
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

  /*===========================
    removeNode(OrbNode o)

    Removes o from the list. You can
    assume o is an OrbNode in the list.
    You cannot assume anything about the
    position of o in the list.
    =========================*/
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
