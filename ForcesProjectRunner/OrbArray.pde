class OrbArray { // OrbArray class that will control behavior of an array of orbs
  Orb[] orbs; // array of orbs
  Orb[] addedOrbs; // array of orbs that wil contain the additional orbs when the addOrb() method is called
  int orbCount; // variable to store the number of orbs
  
  PVector Fsp; // spring force stored as a PVector variable
  PVector Fg; // gravitational force between orbs stored as a PVector variable
  PVector Fdrag; // drag force stored as a PVector variable
  PVector Fe; // electrostatic force between two charged orbs stored as a PVector variable
  
  OrbArray() {
    makeOrbs(NUM_ORBS, true);
  }//default constructor (# of orbs based on driver variable and ordered by default)
  
  OrbArray(int numOrbs, boolean ordered) {
    makeOrbs(numOrbs, ordered);
  }//OrbArray constructor
  
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
        }
      }
      else { // orbs with random positions if not ordered
        for (int i = 0; i < orbCount; i++) {
          orbs[i] = new Orb();
        }
      }
    }
  }//makeOrbs

  void display(boolean spring) {
    for (int i = 0; i < orbCount; i++) { // loop through the array
      if (orbs[i] != null) { // make sure the element exists before displaying it
        orbs[i].display();
        if (spring) {
          showSprings(i); // show the connected springs if in the appropriate simulation(s)
        }
      }
    }
  }//display
  
  /**
   drawSpring(Orb o0, Orb o1), method that draws springs between the orbs
   red springs signify stretched springs, green springs signify compressed springs, and black springs signify springs at normal length
  **/
  void drawSpring(Orb o0, Orb o1) {
    float dist = PVector.dist(o0.center, o1.center); // calculate the distance between the two orbs
    color lineColor = color(0, 0, 0);
    if (dist > SPRING_LENGTH) {
      lineColor = color(255, 0, 0); // color the connecting line red if the distance is more than the spring length (i.e. stretched)
    }
    else if (dist < SPRING_LENGTH) {
      lineColor = color(0, 255, 0); // color the connecting line green if the distance is less than the spring length (i.e. compressed)
    }
    else if (dist == SPRING_LENGTH) {
      lineColor = color(0, 0, 0); // color the connecting line black if the distance is equal to the spring length (i.e. normal length)
    }
    stroke(lineColor); // set the line color
    strokeWeight(3);
    line(o0.center.x, o0.center.y, o1.center.x, o1.center.y); // draw the line between the orbs
  }//drawSpring
  
  void showSprings(int currentOrb) {
    /**
      method that contains two for loops, which act as inner for loops to the outer for loop inside display() above
      
      these two inner for loops have each orb draw a spring to its left and right (depending on if that orb is null or not)
      "relativeOrb" is the variable that stores the index of an orb RELATIVE to the current orb
          
      the first inner for loop involves drawing springs to orbs to the LEFT of the current orb
      we initially start drawing a spring to the orb to the LEFT of the current orb (currentOrb - 1), and then continue moving to the left (relativeOrb--)
      we stop running this inner for loop when "relativeOrb" >= 0 since index 0 is the beginning of the array
      >= makes the inner for loop stop when it has reached the first orb, and doesn't run it when we initially start from the first orb in the outer for loop
          
      the second inner for loop involves drawing springs to orbs to the RIGHT of the current orb
      we initially start drawing a spring to the orb to the RIGHT of the current orb (currentOrb + 1), and then continue moving to the right (relativeOrb++)
      we stop running the inner for loop when "relativeOrb" <= orbCount - 1 since index orbCount - 1 is the end of the array
      <= makes the inner for loop stop when it has reached the last orb, and doesn't run it when we have reached the last orb in the outer for loop
    **/
    for (int relativeOrb = currentOrb - 1; relativeOrb >= 0; relativeOrb--) { // draw springs to the left of the current orb
      if (orbs[relativeOrb] != null) { // if the relative orb to the left exists...
        drawSpring(orbs[currentOrb], orbs[relativeOrb]); // draw the spring from the current orb to that relative orb
        break; // break out of the for loop since we don't want to be drawing springs more than once for each orb
      }
      else if (orbs[relativeOrb] == null) { // if the relative orb to the left doesn't exist...
        continue; // continue on to the next relative orb to the left since we're unable to draw a spring to a non-existent orb
      }
    }
    for (int relativeOrb = currentOrb + 1; relativeOrb <= orbCount - 1; relativeOrb++) { // draw springs to the right of the current orb
      if (orbs[relativeOrb] != null) { // if the relative orb to the right exists...
        drawSpring(orbs[currentOrb], orbs[relativeOrb]); // draw the spring from the current orb to that relative orb
        break; // break out of the for loop since we don't want to be drawing springs more than once for each orb
      }
      else if (orbs[relativeOrb] == null) {
        continue; // continue on to the next relative orb to the right since we're unable to draw a spring to a non-existent orb
      }
    }
  }//showSprings
  
  void applySprings(int springLength, float springK) {
    for (int i = 0; i < orbCount; i++) { // skip the first orb as it's a Fixed Orb so it doesn't have any spring force applied to it
      if (orbs[i] != null) { // make sure there's an existing Orb in the array
        /**
          basically using the same inner for loop structure as the showSprings() method above to apply a spring force to the current and neighboring orbs
        **/
        for (int j = i - 1; j >= 1; j--) {
          if (orbs[j] != null) { // if the relative orb to the left exists...
            Fsp = orbs[i].getSpring(orbs[j], springLength, springK); // exert Fsp on orbs to the left (of the current orb)
            orbs[i].applyForce(Fsp);
          }
          else if (orbs[j] == null) { // if the relative orb to the left doesn't exist...
            continue; // continue on to the next relative orb to the left since we're unable to exert Fsp on a non-existent orb
          }
        }
        for (int j = i + 1; j < orbCount; j++) {
          if (orbs[j] != null) { // if the relative orb to the right exists...
            Fsp = orbs[i].getSpring(orbs[j], springLength, springK); // exert Fsp on orbs to the right (of the current orb)
            orbs[i].applyForce(Fsp);
          }
          else if (orbs[j] == null) { // if the relative orb to the right doesn't exist...
            continue; // continue on to the next relative orb to the right since we're unable to exert Fsp on a non-existent orb
          }
        }
      }
    }
  }//applySprings    
  
  void applyGravity(Orb other, float gConstant) {
    for (int i = 0; i < orbCount; i++) { // loop through the array
      if (orbs[i] != null) { // make sure the Orb exists before exerting a gravitational force on it
        Fg = orbs[i].getGravity(other, gConstant); // calculate the gravitational force between each orb and the other orb
        orbs[i].applyForce(Fg); // apply the gravitational force
      }
    }
  }//applyGravity
  
  void applyDrag() {
    for (int i = 0; i < orbCount; i++) { // loop through the array
      if (orbs[i] != null) { // make sure the Orb exists before exerting a drag force on it
        if (orbs[i].center.y < height/2) { // if the orb is in the Solar System
          Fdrag = orbs[i].getDragForce(D_COEF_SOLAR); // calculate the drag force
          orbs[i].applyForce(Fdrag); // apply the drag force
        }
        else if (orbs[i].center.y > height/2) { // if the orb is in the Alpha Centauri system
          Fdrag = orbs[i].getDragForce(D_COEF_ALPHA); // calculate the drag force
          orbs[i].applyForce(Fdrag); // apply the drag force
        }
      }
    }
  }//applyDrag
  
  void applyElectrostatic(float kConstant) {
    for (int i = 0; i < orbCount; i++) {
      if (orbs[i] != null) {
        /**
          basically using the same inner for loop structure as the showSprings() method above to apply an electrostatic force to the current and neighboring orbs
        **/
        for (int j = i - 1; j >= 1; j--) {
          if (orbs[j] != null) { // if the relative orb to the left exists...
            Fe = orbs[i].getElectrostaticForce(orbs[j], kConstant); // exert Fe on orbs to the left (of the current orb)
            orbs[i].applyForce(Fe);
          }
          else if (orbs[j] == null) { // if the relative orb to the left doesn't exist...
            continue; // continue on to the next relative orb to the left since we're unable to exert Fe on a non-existent orb
          }
        }
        for (int j = i + 1; j < orbCount; j++) {
          if (orbs[j] != null) { // if the relative orb to the right exists...
            Fe = orbs[i].getElectrostaticForce(orbs[j], kConstant); // exert Fe on orbs to the right (of the current orb)
            orbs[i].applyForce(Fe);
          }
          else if (orbs[j] == null) { // if the relative orb to the right doesn't exist...
            continue; // continue on to the next relative orb to the right since we're unable to exert Fe on a non-existent orb
          }
        }
      }
    }
  }//applyElectrostatic
  
  void run(boolean bounce) {
    for (int i = 0; i < orbCount; i++) { // loop through the array
      if (orbs[i] != null) { // make sure the element exists before moving it (and bouncing it)
        orbs[i].move(bounce); // move the element (and bounce it depending on the boolean value)
      }
    }
  }//run
  
  Orb getSelected(int x, int y) {
    for (int i = 0; i < orbCount; i++) { // loop through the array
      if (orbs[i] != null) { // make sure the element exists before selecting it
        if (orbs[i].isSelected(x, y)) {
          return orbs[i]; // return the Orb that is selected
        }
        else {
          continue;
        }
      }
    }
    return null; // otherwise, return null
  }//getSelected
  
  void addOrb() {
    for (int i = 0; i < orbCount; i++) { // go through each orb in the orbs array
      if (orbs[i] == null) {
        orbs[i] = new Orb(); // initialize a new orb if the current one doesn't exist (set to null)
      }
      else if (orbs[i] != null) {
        break; // if the current orb doesn't exist, then break out of the loop and continue to the following code in the method
      }
    }
    orbCount++; // increase the number of orbs by 1
    addedOrbs = new Orb[orbCount]; // initialize the array that will contain the added orb
    arrayCopy(orbs, 0, addedOrbs, 0, orbCount - 1); // copy over the existing elements from the orbs array to the new addedOrbs array
    addedOrbs[orbCount - 1] = new Orb(); // initalize a new orb as the last element in the new array (i.e. appending to the array)
    orbs = addedOrbs; // set the orbs array to be the new addedOrbs array
  }//addOrb
  
  void removeOrb() {
    orbs[(int)random(0, orbCount - 1)] = null; // remove a random orb from the orbs array
  }//removeOrb
  
  void removeOrb(Orb selected) {
    for (int i = 0; i < orbCount; i++) { // loop through the array
      if (orbs[i] != null) { // make sure the element exists before removing it
        if (orbs[i] == selected) {
          orbs[i] = null; // remove the element
        }
      }
    }
  }//removeOrb(Orb selected) -- overloaded removeOrb() method
}//OrbArray
