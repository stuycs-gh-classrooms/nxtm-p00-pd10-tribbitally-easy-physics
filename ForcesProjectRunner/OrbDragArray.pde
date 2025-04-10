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
  
  void addOrb() {
    for (int i = 0; i < orbCount; i++) { // go through each orb in the orbs array
      if (orbs[i] == null) {
        orbs[i] = new Orb(); // initialize a new orb if the current one doesn't exist (set to null)
        if (toggles[MOVING]) {
          orbs[i].velocity = initVelocity(); // set each of the orbs' velocity to an initial random velocity when moving is toggled on
        }
      }
      else if (orbs[i] != null) {
        break; // if the current orb doesn't exist, then break out of the loop and continue to the following code in the method
      }
    }
    orbCount++; // increase the number of orbs by 1
    addedOrbs = new Orb[orbCount]; // initialize the array that will contain the added orb
    arrayCopy(orbs, 0, addedOrbs, 0, orbCount - 1); // copy over the existing elements from the orbs array to the new addedOrbs array
    addedOrbs[orbCount - 1] = new Orb(); // initalize a new orb as the last element in the new array (i.e. appending to the array)
    addedOrbs[orbCount - 1].velocity = initVelocity(); // initializing a random velocity for a newly added orb fixes bug where they wouldn't move even when moving toggled on
    orbs = addedOrbs; // set the orbs array to be the new addedOrbs array
  }//addOrb -- overridden from OrbArray class
}//OrbArray
