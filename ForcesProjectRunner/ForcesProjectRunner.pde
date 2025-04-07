/** global variables for calculating various forces **/
int NUM_ORBS = 10;
int MIN_SIZE = 10;
int MAX_SIZE = 60;
float MIN_MASS = 10;
float MAX_MASS = 100;
float G_CONSTANT = 1;
float D_COEF_SOLAR = 0.1;
float D_COEF_ALPHA = 0.7;
float K_CONSTANT = 8.9875 * pow(10, 9); // k is coulomb's constant, which is ~8.99 * 10^9 Nm^2/C^2
float COULOMB = 1.602 * pow(10, -4); // a real coulomb would be the constant multiplied by 10^-19 but it's too small to show any movement
float MIN_CHARGE = -10 * COULOMB; // this will represent an object having 10 negative charges/electrons
float MAX_CHARGE = 10 * COULOMB; // this will represent an object having 10 positive charges/protons
int SPRING_LENGTH = 50;
float SPRING_K = 0.005;

/** global variables for orb behavior (moving & bounce) toggles **/
int MOVING = 0;
int BOUNCE = 1;
boolean[] toggles = new boolean[2];
String[] modes = {"Moving", "Bounce"};

/** global variables for simulation toggles **/
int gravitySim = 0;
int springSim = 1;
int dragSim = 2;
int electrostaticSim = 3;
int combinationSim = 4;
boolean[] simToggles = new boolean[5];
String[] simModes = {"Gravity", "Spring", "Drag", "Electrostatic", "Combination"};

FixedOrb sun;
OrbArray bundle;
OrbDragArray draggedPlanets;
OrbList system;
OrbList springSystem;
OrbList combinationSystem;

void setup() {
  size(600, 600);
  /** initializing sun FixedOrb for gravity simulation **/
  sun = new FixedOrb(width/2, height /2, 90, 20, 0);
  sun.c = color(255, 150, 0);

  /** populating orbs (both the array of orbs and linked list, both ordered by default) **/
  bundle = new OrbArray(NUM_ORBS, true);
  draggedPlanets = new OrbDragArray(NUM_ORBS, true);
  system = new OrbList();
  system.populate(NUM_ORBS, true);
  springSystem = new OrbSpringList();
  springSystem.populate(NUM_ORBS, true);
  combinationSystem = new OrbSpringList();
  combinationSystem.populate(NUM_ORBS, true);
  
  simToggles[gravitySim] = true;
}//setup

void draw() {
  background(0); // black background to simulate a solar system in space
  displayMode();
  displayCosmos();
  showSimulations();
  runSimulations();
}//draw

void showSimulations() {
  if (simToggles[gravitySim]) {
    bundle.display(false);
    sun.display();
  }
  else if (simToggles[springSim]) {
    springSystem.display(true);
  }
  else if (simToggles[dragSim]) {
    draggedPlanets.display(false);
  }
  else if (simToggles[electrostaticSim]) {
    system.display(false);
  }
  else if (simToggles[combinationSim]) {
    combinationSystem.display(true);
  }
  else {
    bundle.display(false);
  }
}

void runSimulations() {
  if (toggles[MOVING]) {
    if (simToggles[gravitySim]) {
      bundle.run(toggles[MOVING]);
      bundle.applyGravity(sun, G_CONSTANT);
    }
    if (simToggles[springSim]) {
      springSystem.run(toggles[MOVING]);
      springSystem.applySprings(SPRING_LENGTH, SPRING_K);
    }
    if (simToggles[dragSim]) {
      draggedPlanets.run(toggles[MOVING]);
      draggedPlanets.applyDrag();
    }
    if (simToggles[electrostaticSim]) {
      system.run(toggles[MOVING]);
      system.applyElectrostatic(K_CONSTANT);
    }
    if (simToggles[combinationSim]) {
      combinationSystem.run(toggles[MOVING]);
      combinationSystem.applySprings(SPRING_LENGTH, SPRING_K);
      combinationSystem.applyDrag();
      combinationSystem.applyElectrostatic(K_CONSTANT);
    }
  }//moving
}

void populateOrbs(boolean ordered) {
  if (simToggles[gravitySim]) {
    bundle = new OrbArray(NUM_ORBS, ordered);
  }
  else if (simToggles[springSim]) {
    springSystem = new OrbSpringList();
    springSystem.populate(NUM_ORBS, ordered);
  }
  else if (simToggles[dragSim]) {
    draggedPlanets = new OrbDragArray(NUM_ORBS, ordered);
  }
  else if (simToggles[electrostaticSim]) {
    system = new OrbList();
    system.populate(NUM_ORBS, ordered);
  }
  else if (simToggles[combinationSim]) {
    combinationSystem = new OrbSpringList();
    combinationSystem.populate(NUM_ORBS, ordered);
  }
  else {
    bundle = new OrbArray(NUM_ORBS, ordered);
  }
}

void mousePressed() {
  Orb selectedBundleOrb = bundle.getSelected(mouseX, mouseY);
  OrbNode selectedSpringNode = springSystem.getSelected(mouseX, mouseY);
  Orb selectedDragOrb = draggedPlanets.getSelected(mouseX, mouseY);
  OrbNode selectedSystemNode = system.getSelected(mouseX, mouseY);
  OrbNode selectedCombinationNode = combinationSystem.getSelected(mouseX, mouseY);
  if (simToggles[gravitySim]) {
    //println(selectedBundleOrb);
    bundle.removeOrb(selectedBundleOrb);
  }
  else if (simToggles[springSim]) {
    springSystem.removeNode(selectedSpringNode);
  }
  else if (simToggles[dragSim]) {
    draggedPlanets.removeOrb(selectedDragOrb);
  }
  else if (simToggles[electrostaticSim]) {
    system.removeNode(selectedSystemNode);
  }
  else if (simToggles[combinationSim]) {
    combinationSystem.removeNode(selectedCombinationNode);
  }
  else {
    //println(selectedBundleOrb);
    bundle.removeOrb(selectedBundleOrb);
  }
}//mousePressed

void keyPressed() {
  /** keys for toggling orb behavior (movement and bouncing) **/
  if (key == ' ') {
    toggles[MOVING] = !toggles[MOVING];
  }//moving
  if (key == 'b') {
    toggles[BOUNCE] = !toggles[BOUNCE];
  }//bounce

  /** keys for toggling simulations **/
  if (key == '1' || key == '2' || key == '3' || key == '4' || key == '5') {
    for (int i = 0; i < simToggles.length; i++) {
      simToggles[i] = false; // toggle off all other simulations except the one that's actually toggled on
    }
  }
  if (key == '1') {
    simToggles[gravitySim] = true;
  }//gravity

  if (key == '2') {
    simToggles[springSim] = true;
  }//spring

  if (key == '3') {
    simToggles[dragSim] = true;
  }//drag

  if (key == '4') {
    simToggles[electrostaticSim] = true;
  }//electrostatic

  if (key == '5') {
    simToggles[combinationSim] = true;
  }//combination

  if (key == '=' || key == '+') {
    if (simToggles[gravitySim]) {
      bundle.addOrb();
    }
    else if (simToggles[springSim]) {
      springSystem.addFront(new OrbNode());
    }
    else if (simToggles[dragSim]) {
      draggedPlanets.addOrb();
    }
    else if (simToggles[electrostaticSim]) {
      system.addFront(new OrbNode());
    }
    else if (simToggles[combinationSim]) {
      combinationSystem.addFront(new OrbNode());
    }
    else {
      bundle.addOrb();
    }
  }
  
  if (key == '-') {
    if (simToggles[gravitySim]) {
      bundle.removeOrb();
    }
    else if (simToggles[springSim]) {
      springSystem.removeFront();
    }
    else if (simToggles[dragSim]) {
      draggedPlanets.removeOrb();
    }
    else if (simToggles[electrostaticSim]) {
      system.removeFront();
    }
    else if (simToggles[combinationSim]) {
      combinationSystem.removeFront();
    }
    else {
      bundle.removeOrb();
    }
  }
  
  if (key == 'q') {
    populateOrbs(true);
  }
  if (key == 'w') {
    populateOrbs(false);
  }
}//keyPressed


void displayMode() {
  textAlign(LEFT, TOP);
  textSize(20);
  stroke(255);
  strokeWeight(3);
  int toggleX = 215; // initial x-pos of toggle box for orb behavior
  for (int m = 0; m < toggles.length; m++) {
    if (toggles[m]) {
      fill(0, 255, 0); // color the toggle box green if toggled on
    } else {
      fill(255, 0, 0); // color the toggle box red if toggled off
    }
    float w = textWidth(modes[m]); // width of the text
    float toggleWidth = w + 10; // add spacing between the text and the box by making the box width longer
    rect(toggleX, 10, toggleWidth, 25); // draw the toggle box
    fill(0);
    text(modes[m], toggleX + 5, 15); // fill the toggle box with the name of the toggle
    toggleX += toggleWidth + 20; // increase the x value by the toggle width and a bit more to draw the next toggle box
  }

  int simToggleX = 50; // initial x-pos of toggle box for simulations
  for (int s = 0; s < simToggles.length; s++) {
    if (simToggles[s]) {
      fill(0, 255, 0); // color the toggle box green if toggled on
    } else {
      fill(255, 0, 0); // color the toggle box red if toggled off
    }
    float w = textWidth(simModes[s]); // width of the text
    float simToggleWidth = w + 10; // add spacing between the text and the box by making the box width longer
    rect(simToggleX, 55, simToggleWidth, 25); // draw the toggle box
    fill(0);
    text(simModes[s], simToggleX + 5, 60); // fill the toggle box with the name of the toggle
    simToggleX += simToggleWidth + 20; // increase the x value by the toggle width and a bit more to draw the next toggle box
  }
}//displayMode()

void displayCosmos() {
  fill(255);
  textSize(20);
  text("Solar System", 10, 15);

  if (simToggles[dragSim] || simToggles[combinationSim]) {
    strokeWeight(1);
    stroke(78, 42, 132);
    fill(78, 42, 132);
    rect(0, height/2, width, height/2);

    fill(255);
    text("Alpha Centauri", 10, height - 25);
  }
}
