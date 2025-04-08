/**
  ForcesProjectRunner -- the driver file for this project
  
  Keybindings:
  '1': Toggle on the gravity simulation
  '2': Toggle on the spring simulation
  '3': Toggle on the drag simulation
  '4': Toggle on the electrostatic simulation
  '5': Toggle on the combination simulation
  
  'q': Create a new ORDERED array of orbs/linked list of orbs
  'w': Create a new UNORDERED array of orbs/linked list of orbs
  '+/=': Add a new orb to the array of orbs, or a new orb node to the front of the linked list
  '-': Remove a random orb from the array of orbs, or remove the front node of the linked list
  
  Mouse Pressed:
  Clicking on any orb with the mouse in any simulation will remove that orb.
  
  Things to Note:
  - Stroke color for each orb node will be different in electrostatic sim depending on charge
  - Red means negative, and green means positive
  - Shade of stroke color depends on the amount of pos or neg charge the orb node has
**/

/** global variables for calculating various forces **/
int NUM_ORBS = 10;
int MIN_SIZE = 10;
int MAX_SIZE = 60;
float MIN_MASS = 10;
float MAX_MASS = 100;
float G_CONSTANT = 1;
float D_COEF_SOLAR = 0.1; // drag coefficient for the main Solar System
float D_COEF_ALPHA = 0.7; // drag coefficient for the Alpha Centauri planetary system
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

/** global variables for simulations **/
FixedOrb sun; // sun for gravity
OrbArray bundle; // generic OrbArray called bundle (but used in only gravity simulation for now)
OrbDragArray draggedPlanets; // array of orbs specifically for drag simulation (subclass of OrbArray)
OrbList system; // generic OrbList called system (but used in only electrostatic simulation for now)
OrbList springSystem; // linked list of orbs specifically for spring simulation (subclass of OrbList)
OrbList combinationSystem; // same OrbSpringList used as for the spring simulation, but different object so that the two don't affect each other (used for combo sim)

void setup() {
  size(600, 600);
  /** initializing sun FixedOrb for gravity simulation **/
  sun = new FixedOrb(width/2, height /2, 90, 20, 0);
  sun.c = color(255, 150, 0);

  /** populating orbs for all simulations, all ordered by default **/
  initializeSimulations();
  
  /** make gravity simulation enabled by default on start **/
  simToggles[gravitySim] = true;
}//setup

void draw() {
  background(0); // black background to simulate a solar system in space
  displayMode(); // show toggle menu
  displayCosmos(); // show necessary planetary system info
  showSimulations();
  runSimulations();
}//draw

void initializeSimulations() {
  bundle = new OrbArray(NUM_ORBS, true);
  draggedPlanets = new OrbDragArray(NUM_ORBS, true);
  system = new OrbList();
  system.populate(NUM_ORBS, true);
  springSystem = new OrbSpringList();
  springSystem.populate(NUM_ORBS, true);
  combinationSystem = new OrbSpringList();
  combinationSystem.populate(NUM_ORBS, true);
}//initializeSimulations

void showSimulations() {
  if (simToggles[gravitySim]) {
    bundle.display(false); // show the array of orbs without springs
    sun.display(); // show the sun
  }
  else if (simToggles[springSim]) {
    springSystem.display(true); // show the linked list of orbs with springs
  }
  else if (simToggles[dragSim]) {
    draggedPlanets.display(false); // show the array of orbs without springs
  }
  else if (simToggles[electrostaticSim]) {
    system.display(false); // show the linked list of orbs withput springs
  }
  else if (simToggles[combinationSim]) {
    combinationSystem.display(true); // show the linked list of orbs with springs
  }
  else {
    bundle.display(false); // if no simulation is enabled, show the array of orbs without springs by default
  }
}//showSimulations

void runSimulations() {
  if (toggles[MOVING]) {
    if (simToggles[gravitySim]) {
      bundle.run(toggles[BOUNCE]);
      bundle.applyGravity(sun, G_CONSTANT); // apply a gravitational force between the sun and each of the orbs
    }
    if (simToggles[springSim]) {
      springSystem.run(toggles[BOUNCE]);
      springSystem.applySprings(SPRING_LENGTH, SPRING_K); // apply a spring force between each of the orb nodes (and the two fixed orbs)
    }
    if (simToggles[dragSim]) {
      draggedPlanets.run(toggles[BOUNCE]);
      draggedPlanets.applyDrag(); // apply a drag force to each of the orbs depending on planetary system
    }
    if (simToggles[electrostaticSim]) {
      system.run(toggles[BOUNCE]);
      system.applyElectrostatic(K_CONSTANT); // apply an electrostatic force between each of the charged orb nodes
    }
    /** apply spring, drag, and electrostatic forces for the combo sim **/
    if (simToggles[combinationSim]) {
      combinationSystem.run(toggles[BOUNCE]);
      combinationSystem.applySprings(SPRING_LENGTH, SPRING_K);
      combinationSystem.applyDrag();
      combinationSystem.applyElectrostatic(K_CONSTANT);
    }
  }//moving
}//runSimulations

void populateOrbs(boolean ordered) {
  if (simToggles[gravitySim]) {
    bundle = new OrbArray(NUM_ORBS, ordered); // create a new array of orbs for the gravity sim
  }
  else if (simToggles[springSim]) {
    springSystem = new OrbSpringList();
    springSystem.populate(NUM_ORBS, ordered); // create a new linked list of orbs for the spring sim
  }
  else if (simToggles[dragSim]) {
    draggedPlanets = new OrbDragArray(NUM_ORBS, ordered); // create a new array of orbs for the drag sim
  }
  else if (simToggles[electrostaticSim]) {
    system = new OrbList();
    system.populate(NUM_ORBS, ordered); // create a new linked list of orbs for the electrostatic sim
  }
  else if (simToggles[combinationSim]) {
    combinationSystem = new OrbSpringList();
    combinationSystem.populate(NUM_ORBS, ordered); // create a new linked list of orbs for the combo sim
  }
  else {
    bundle = new OrbArray(NUM_ORBS, ordered); // if no simulation is enabled by default, create a new array of orbs
  }
}//populateOrbs

void addToSimulations() {
  if (simToggles[gravitySim]) {
    bundle.addOrb(); // add an orb to the bundle array
  }
  else if (simToggles[springSim]) {
    springSystem.addFront(new OrbNode()); // add a node to the front of the linked list
    //springSystem.addNode(0);
  }
  else if (simToggles[dragSim]) {
    draggedPlanets.addOrb(); // add an orb to the drag array
  }
  else if (simToggles[electrostaticSim]) {
    system.addFront(new OrbNode()); // add a node to the front of the linked list
  }
  else if (simToggles[combinationSim]) {
    combinationSystem.addFront(new OrbNode()); // add a node to the front of the linked list
  }
  else {
    bundle.addOrb(); // if no simulation is enabled by default, add an orb to the bundle array
  }
}//addToSimulations

void removeFromSimulations() {
  if (simToggles[gravitySim]) {
    bundle.removeOrb(); // remove an orb from the bundle array
  }
  else if (simToggles[springSim]) {
    springSystem.removeFront(); // remove the front node of the linked list
  }
  else if (simToggles[dragSim]) {
    draggedPlanets.removeOrb(); // remove an orb from the drag array
  }
  else if (simToggles[electrostaticSim]) {
    system.removeFront(); // remove the front node of the linked list
  }
  else if (simToggles[combinationSim]) {
    combinationSystem.removeFront(); // remove the front node of the linked list
  }
  else {
    bundle.removeOrb(); // if no simulation is enabled by default, remove an orb from the bundle array
  }
}

void mousePressed() {
  Orb selectedBundleOrb = bundle.getSelected(mouseX, mouseY); // selected orb from bundle array
  OrbNode selectedSpringNode = springSystem.getSelected(mouseX, mouseY); // selected orb from spring system linked list
  Orb selectedDragOrb = draggedPlanets.getSelected(mouseX, mouseY); // selected orb from drag array
  OrbNode selectedSystemNode = system.getSelected(mouseX, mouseY); // selected orb from system linked list
  OrbNode selectedCombinationNode = combinationSystem.getSelected(mouseX, mouseY); // selected orb from combo system linked list
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
    bundle.removeOrb(selectedBundleOrb); // if no simulation is enabled by default, remove a selected orb from the bundle array of orbs
  }
}//mousePressed

void keyPressed() {
  /** keys for toggling orb behavior (movement and bouncing) **/
  if (key == ' ') {
    toggles[MOVING] = !toggles[MOVING];
  }
  if (key == 'b') {
    toggles[BOUNCE] = !toggles[BOUNCE];
  }

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
    addToSimulations();
  }//addToSimulations
  
  if (key == '-') {
    removeFromSimulations();
  }//removeFromSimulations
  
  if (key == 'q') {
    populateOrbs(true); // populate orbs that are ordered
  }
  
  if (key == 'w') {
    populateOrbs(false); // populate orbs that aren't ordered
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
  /** main Solar System **/
  fill(255);
  textSize(20);
  text("Solar System", 10, 15);

  /** Alpha Centauri system **/
  if (simToggles[dragSim] || simToggles[combinationSim]) {
    strokeWeight(1);
    stroke(78, 42, 132);
    fill(78, 42, 132);
    rect(0, height/2, width, height/2);

    fill(255);
    text("Alpha Centauri", 10, height - 25);
  }
}
