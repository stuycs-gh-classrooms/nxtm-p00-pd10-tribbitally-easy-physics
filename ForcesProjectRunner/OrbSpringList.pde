class OrbSpringList extends OrbList {
  /**
    This class (OrbSpringList) is a subclass of the OrbList class.
    This subclass was created in order to address an issue with the spring simulation
    where the orbs would not move by default (even if moving was toggled on) due to 
    being equidistant from each other, which resulted no spring force being exerted 
    on each of the orb nodes. 
    
    As such, each of the orbs' velocity for this subclass are initially in random directions
    and random magnitudes, which will then cause each of the orbs to be influenced
    by the spring force.
    
    This also served as a way to introduce two new fixed orbs (since that's a requirement
    for the spring simulation) and also connect them to a linked list of orbs, so creating
    a separate class for this helped make the code cleaner and easier to understand.
    
    Ideally, this class can also be used for the combo simulation, since that involves
    spring forces being exerted on each orb node in a linked list.
  **/
  FixedOrb leftOrb; // fixed orb on the left of the screen
  FixedOrb rightOrb; // fixed orb on the right of the screen

  void populate(int n, boolean ordered) {
    front = null;
    for (int i = 0; i < n - 1; i++) {
      if (ordered){ // orb nodes with set x, y, size, mass, and charge
        addFront(new OrbNode(SPRING_LENGTH*(i+2), height/2, random(MIN_SIZE, MAX_SIZE), random(MIN_MASS, MAX_MASS), random(MIN_CHARGE, MAX_CHARGE)));
      }
      else { // random orb nodes
        addFront(new OrbNode());
      }
    }//makes orbs according to ordered
    OrbNode current = front; // set the current node to be the front node initially
    while (current != null) { // loop through the linked list
      current.velocity = initVelocity(); // set each orb node's velocity to a random initial velocity
      current = current.next; // iterate to the next orb node in the linked list
    }
    initializeFixedOrbs();
  }//populate -- overridden from OrbList class
  
  void initializeFixedOrbs() {
    float size = random(MIN_SIZE, MAX_SIZE); // size for the fixed orbs
    leftOrb = new FixedOrb(size/2, random(5, height/2), size, random(MIN_MASS, MAX_MASS), random(MIN_CHARGE, MAX_CHARGE)); // create a new fixed orb on the left
    rightOrb = new FixedOrb(width - size/2, random(height/2, height - 5), size, random(MIN_MASS, MAX_MASS), random(MIN_CHARGE, MAX_CHARGE)); // create a new fixed orb on the right
  }//initializeFixedOrbs
  
  PVector initVelocity() { // method that basically calculates a random velocity and returns it as a PVector
    float degrees = random(0, 360);
    float initVelX = random(1, 6) * cos(radians(degrees)); // x-component of velocity
    float initVelY = random(1, 6) * sin(radians(degrees)); // y-component of velocity
    PVector initVel = new PVector(initVelX, initVelY);
    return initVel;
  }
  
  void display(boolean ifSpring) {
    OrbNode current = front;
    while (current != null){
      current.display(ifSpring);
      current = current.next;  // loop through each item in the list and call display()
    }
    leftOrb.display(); // show the left fixed orb
    rightOrb.display(); // show the right fixed orb
    drawLeftOrbSpring(); // draw the spring from the left orb to the closest node in the linked list
    drawRightOrbSpring(); // draw the spring from the right orb to the closest node in the linked list
  }//display -- overridden from OrbList class
  
  void drawLeftOrbSpring() {
    float distanceToLeftOrb = PVector.dist(lastNode().center, leftOrb.center); // calculate the distance between the left orb and the last node in the linked list (last since the linked list is populated leftward)
    if (distanceToLeftOrb < SPRING_LENGTH) {
      stroke(0, 255, 0); // green spring if compressed
    }
    else if (distanceToLeftOrb > SPRING_LENGTH) {
      stroke(255, 0, 0); // red spring if stretched
    }
    else {
      stroke(0, 0, 0); // black spring if at natural length
    }
    strokeWeight(2);
    /** draw two springs between the left orb and the last node in the linked list **/
    line(leftOrb.center.x, leftOrb.center.y + 2, lastNode().center.x, lastNode().center.y + 2);
    line(lastNode().center.x, lastNode().center.y - 2, leftOrb.center.x, leftOrb.center.y - 2);
  }//drawLeftOrbSpring
  
  void drawRightOrbSpring() {
    float distanceToRightOrb = PVector.dist(front.center, rightOrb.center); // calculate the distance between the right orb and the front node in the linked list (front since the linked list is populated leftward)
    if (distanceToRightOrb < SPRING_LENGTH) {
      stroke(0, 255, 0); // green spring if compressed
    }
    else if (distanceToRightOrb > SPRING_LENGTH) {
      stroke(255, 0, 0); // red spring if stretched
    }
    else {
      stroke(0, 0, 0); // black spring if at natural length
    }
    strokeWeight(2);
    /** draw two springs between the right orb and the front node in the linked list **/
    line(rightOrb.center.x, rightOrb.center.y + 2, front.center.x, front.center.y + 2);
    line(front.center.x, front.center.y - 2, rightOrb.center.x, rightOrb.center.y - 2);
  }//drawRightOrbSpring
  
  OrbNode lastNode() { // method that basically loops through the linked list and returns the last node
    OrbNode current = front; // initially set the current node to be the front node
    while (current != null) {
      if (current.next == null) {
        return current; // return the current node if there's no node after it
      }
      else {
        current = current.next; // otherwise, move on to the next node in the linked list
      }
    }
    return null; // otherwise, return null if no last node found
  }//OrbNode
  
  void removeFront() {
    if (front != null && front.next != null) {
      front = front.next;
      front.previous = null;
    }  //if front exists and front.next exists, reassign front to be front.next and make the former front null
    else if (front != null && front.next == null) {
       //if front exists and front.next doesn't (ie front is the only item), don't do anything/don't remove the front orb (won't run into NullPointerException error when attempting to draw springs)
    }  
  }//removeFront -- overridden from OrbList class
}
