class OrbDragArray extends OrbArray {
  /**
    This class (OrbDragArray) is a subclass of the OrbArray class.
    This subclass was created in order to address an issue with the drag simulation
    where the orbs would not move by default (even when moving was toggled on) due to
    not being influenced by external forces initially, but just drag, which does nothing
    until the orbs start moving.
    
    As such, each of the orbs' velocity for this subclass are initially in random directions
    and random magnitudes, which will then cause each of the orbs to be influenced
    by the force of drag.
  **/
  OrbDragArray(int numOrbs, boolean ordered) {
    makeOrbs(numOrbs, ordered); // run the below makeOrbs() method instead of the same method from the OrbArray superclass
  }//OrbDragArray constructor
  
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
          orbs[i].velocity = initVelocity(); // set each of the orbs' velocity to an initial random velocity
        }
      }
      else { // orbs with random positions if not ordered
        for (int i = 0; i < orbCount; i++) {
          orbs[i] = new Orb();
          orbs[i].velocity = initVelocity(); // set each of the orbs' velocity to an initial random velocity
        }
      }
    }
  }//makeOrbs -- overridden from OrbArray class
  
  PVector initVelocity() { // method that basically calculates a random velocity and returns it as a PVector
    float degrees = random(0, 360);
    float initVelX = random(1, 6) * cos(radians(degrees)); // x-component of velocity
    float initVelY = random(1, 6) * sin(radians(degrees)); // y-component of velocity
    PVector initVel = new PVector(initVelX, initVelY);
    return initVel;
  }//initVelocity
}//OrbArray
