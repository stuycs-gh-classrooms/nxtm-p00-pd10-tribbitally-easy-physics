/** global variables for calculating various forces**/
int NUM_ORBS = 10;
int MIN_SIZE = 10;
int MAX_SIZE = 60;
float MIN_MASS = 10;
float MAX_MASS = 100;
float G_CONSTANT = 1;
float D_COEF = 0.1;
float K_CONSTANT = 8.9875 * pow(10,9); // k is coulomb's constant, which is ~8.99 * 10^9 Nm^2/C^2
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
OrbList system;

void setup() {
  size(600, 600);
  /** initializing sun FixedOrb for gravity simulation **/
  sun = new FixedOrb(width/2, height /2, 90, 20, 0);
  sun.c = color(255,150,0);
  
  /** populating orbs (both the array of orbs and linked list) **/
  bundle = new OrbArray(NUM_ORBS, true); // array of orbs is ordered by default
  system = new OrbList();
  system.populate(NUM_ORBS, false); // linked list of orbs isn't ordered by default (ordered list doesn't move orbs for spring sim since orbs are equidistant)
}//setup

void draw() {
  background(0); // black background to simulate a solar system in space
  displayMode();
  if (simToggles[springSim] || simToggles[electrostaticSim] || simToggles[combinationSim]) {
    boolean ifSpring = simToggles[springSim] || simToggles[combinationSim];
    system.display(ifSpring);
    if (toggles[MOVING]) {
      system.run(toggles[BOUNCE]);
    }
  }
  else if (simToggles[gravitySim] || simToggles[dragSim]) {
    bundle.display(false);
    if (toggles[MOVING]) {
      bundle.run(toggles[BOUNCE]);
    }
  }
  else {
    bundle.display(false);
  }
  if (simToggles[gravitySim]) {
    sun.display();
  }
  if (toggles[MOVING]) {
    if (simToggles[gravitySim]) {
      bundle.applyGravity(sun, G_CONSTANT);
    }
    if (simToggles[springSim]) {
      system.applySprings(SPRING_LENGTH, SPRING_K);
    }
    if (simToggles[dragSim]) {
      bundle.applyDrag(D_COEF);
    }
    if (simToggles[electrostaticSim]) {
      system.applyElectrostatic(K_CONSTANT);
    }
    if (simToggles[combinationSim]) {
      system.applySprings(SPRING_LENGTH, SPRING_K);
      system.applyDrag(D_COEF);
      system.applyElectrostatic(K_CONSTANT);
    }
  }//moving
}//draw

void mousePressed() {
  if (simToggles[gravitySim] || simToggles[dragSim]) {
    Orb selectedOrb = bundle.getSelected(mouseX, mouseY);
    if (selectedOrb != null) {
      bundle.removeOrb(selectedOrb);
    }
  }
  else if (simToggles[springSim] || simToggles[electrostaticSim] || simToggles[combinationSim]) {
    OrbNode selectedOrbNode = system.getSelected(mouseX, mouseY);
    if (selectedOrbNode != null) {
      system.removeNode(selectedOrbNode);
    }
  }
  else {
    Orb selectedOrb = bundle.getSelected(mouseX, mouseY);
    if (selectedOrb != null) {
      bundle.removeOrb(selectedOrb);
    }
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
  
  if (key == '=' || key =='+') {
    if (simToggles[gravitySim] || simToggles[dragSim]) {
      bundle.addOrb();
    }
    else if (simToggles[springSim] || simToggles[electrostaticSim] || simToggles[combinationSim]) {
      system.addFront(new OrbNode());
    }
    else {
      bundle.addOrb();
    }
  }
  if (key == '-') {
    if (simToggles[gravitySim] || simToggles[dragSim]) {
      bundle.removeOrb();
    }
    else if (simToggles[springSim] || simToggles[electrostaticSim] || simToggles[combinationSim]) {
      system.removeFront();
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

void populateOrbs(boolean ordered) {
  if (simToggles[gravitySim] || simToggles[dragSim]) {
    bundle = new OrbArray(NUM_ORBS, ordered);
  }
  else if (simToggles[springSim] || simToggles[electrostaticSim] || simToggles[combinationSim]) {
    system = new OrbList();
    system.populate(NUM_ORBS, ordered);
  }
  else {
    bundle = new OrbArray(NUM_ORBS, ordered);
  }
}

void displayMode() {
  textAlign(LEFT, TOP);
  textSize(20);
  stroke(255);
  strokeWeight(3);
  int toggleX = 215; // initial x-pos of toggle box for orb behavior
  for (int m = 0; m < toggles.length; m++) {
    if (toggles[m]) {
      fill(0, 255, 0); // color the toggle box green if toggled on
    }
    else { 
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
    }
    else {
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
