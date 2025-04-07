class OrbSpringList extends OrbList {
  void populate(int n, boolean ordered) {
    front = null;
    for (int i = 0; i < n; i++){
      if (ordered){
        addFront(new OrbNode(SPRING_LENGTH*(i+1), height/2, random(MIN_SIZE, MAX_SIZE), random(MIN_MASS, MAX_MASS), random(MIN_CHARGE, MAX_CHARGE)));
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
  }
  
  PVector initVelocity() {
    float degrees = random(0, 360);
    float initVelX = random(1, 6) * cos(radians(degrees));
    float initVelY = random(1, 6) * sin(radians(degrees));
    PVector initVel = new PVector(initVelX, initVelY);
    return initVel;
  }
}
