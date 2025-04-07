class OrbSpringList extends OrbList {
  FixedOrb leftOrb;
  FixedOrb rightOrb;

  void populate(int n, boolean ordered) {
    front = null;
    for (int i = 0; i < n - 1; i++) {
      if (ordered){
        addFront(new OrbNode(SPRING_LENGTH*(i+2), height/2, random(MIN_SIZE, MAX_SIZE), random(MIN_MASS, MAX_MASS), random(MIN_CHARGE, MAX_CHARGE)));
      }
      else {
        addFront(new OrbNode());
      }
    }//makes orbs according to ordered
    OrbNode current = front;
    while (current != null) {
      current.velocity = initVelocity();
      current = current.next;
    }
    
    float size = random(MIN_SIZE, MAX_SIZE);
    leftOrb = new FixedOrb(size/2, random(5, height/2), size, random(MIN_MASS, MAX_MASS), random(MIN_CHARGE, MAX_CHARGE));
    rightOrb = new FixedOrb(width - size/2, random(height/2, height - 5), size, random(MIN_MASS, MAX_MASS), random(MIN_CHARGE, MAX_CHARGE));
  }
  
  PVector initVelocity() {
    float degrees = random(0, 360);
    float initVelX = random(1, 6) * cos(radians(degrees));
    float initVelY = random(1, 6) * sin(radians(degrees));
    PVector initVel = new PVector(initVelX, initVelY);
    return initVel;
  }
  
  void display(boolean ifSpring) {
    OrbNode current = front;
    while (current != null){
      current.display(ifSpring);
      current = current.next;  //loop through each item in the list and call display()
    }
    leftOrb.display();
    rightOrb.display();
    drawLeftOrbSpring();
    drawRightOrbSpring();
  }//display
  
  void drawLeftOrbSpring() {
    float distanceToLeftOrb = PVector.dist(lastNode().center, leftOrb.center);
    if (distanceToLeftOrb < SPRING_LENGTH) {
      stroke(0, 255, 0);
    }
    else if (distanceToLeftOrb > SPRING_LENGTH) {
      stroke(255, 0, 0);
    }
    else {
      stroke(0, 0, 0);
    }
    strokeWeight(2);
    line(leftOrb.center.x, leftOrb.center.y + 2, lastNode().center.x, lastNode().center.y + 2);
    line(lastNode().center.x, lastNode().center.y - 2, leftOrb.center.x, leftOrb.center.y - 2);
  }
  
  void drawRightOrbSpring() {
    float distanceToRightOrb = PVector.dist(front.center, rightOrb.center);
    if (distanceToRightOrb < SPRING_LENGTH) {
      stroke(0, 255, 0);
    }
    else if (distanceToRightOrb > SPRING_LENGTH) {
      stroke(255, 0, 0);
    }
    else {
      stroke(0, 0, 0);
    }
    strokeWeight(2);
    line(rightOrb.center.x, rightOrb.center.y + 2, front.center.x, front.center.y + 2);
    line(front.center.x, front.center.y - 2, rightOrb.center.x, rightOrb.center.y - 2);
  }
  
  OrbNode lastNode() {
    OrbNode current = front;
    while (current != null) {
      if (current.next == null) {
        return current;
      }
      else {
        current = current.next;
      }
    }
    return null;
  }
}
