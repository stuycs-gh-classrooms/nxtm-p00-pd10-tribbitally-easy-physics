class OrbDragArray extends OrbArray {
  OrbDragArray(int numOrbs, boolean ordered) {
    makeOrbs(numOrbs, ordered);
  }
  
  void makeOrbs(int numOrbs, boolean ordered) {
    orbCount = numOrbs;
    orbs = new Orb[orbCount]; // initialize the orbs array
    
    if (numOrbs != 0) {
      /** variables for ordered array of orbs **/
      int orbX = SPRING_LENGTH;
      int orbY = height/2;
      if (ordered) { // orbs with set positions if ordered
        for (int i = 0; i < orbCount; i++) {
          orbs[i] = new Orb(orbX * (i + 1), orbY, random(MIN_SIZE, MAX_SIZE), random(MIN_MASS, MAX_MASS), random(MIN_CHARGE, MAX_CHARGE));
          orbs[i].velocity = initVelocity();
        }
      }
      else { // orbs with random positions if not ordered
        for (int i = 0; i < orbCount; i++) {
          orbs[i] = new Orb();
          orbs[i].velocity = initVelocity();
        }
      }
    }
  }//makeOrbs
  
  PVector initVelocity() {
    float degrees = random(0, 360);
    float initVelX = random(1, 6) * cos(radians(degrees));
    float initVelY = random(1, 6) * sin(radians(degrees));
    PVector initVel = new PVector(initVelX, initVelY);
    return initVel;
  }
}
