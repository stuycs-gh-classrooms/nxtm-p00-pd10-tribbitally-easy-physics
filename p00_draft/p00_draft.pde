/* ===================================
Keyboard commands:
  1: Create a new list of orbs in a line.
  2: Create a new list of random orbs.
  =: add a new node to the front of the list
  -: remove the node at the front
  SPACE: Toggle moving on/off
  g: Toggle sun gravity on/off

Mouse Commands:
  mousePressed: if the mouse is over an
    orb, remove it from the list.
=================================== */


int NUM_ORBS = 10;
int MIN_SIZE = 10;
int MAX_SIZE = 60;
float MIN_MASS = 10;
float MAX_MASS = 100;
float G_CONSTANT = 1;
float D_COEF = 0.1;
float K_CONSTANT = 8.9875 * pow(10,9);  //units = N*m^2/C^2
float COULOMB = 1.602 * pow(10, -5); //a real coulomb is 10 ^-19 but it's too small to show any movement
float MIN_CHARGE = -10 *COULOMB;
float MAX_CHARGE = 10 * COULOMB;

int SPRING_LENGTH = 50;
float  SPRING_K = 0.005;

int MOVING = 0;
int BOUNCE = 1;
int GRAVITY = 2;
int DRAGF = 3;
int ELECTROSTATIC = 4;
boolean[] toggles = new boolean[5];
String[] modes = {"Moving", "Bounce", "Gravity", "Drag", "Electrostatic"};

FixedOrb sun;

OrbList system;

void setup() {
  size(600, 600);
  
  sun = new FixedOrb(width/2, height /2, 90, 20, 0);
  sun.c = color(255,150,0);

  system = new OrbList();
  system.populate(NUM_ORBS, true);
}//setup

void draw() {
  background(255);
  displayMode();

  system.display();

  if (toggles[MOVING]) {

    //system.applySprings(SPRING_LENGTH, SPRING_K);

    if (toggles[GRAVITY]) {
      system.applyGravity(sun, GRAVITY);
      sun.display();
    }
    
  if (toggles[ELECTROSTATIC]) {
    system.applyElectrostatic(K_CONSTANT);
  }
    system.run(toggles[BOUNCE]);
  }//moving
  
}//draw

void mousePressed() {
  OrbNode selected = system.getSelected(mouseX, mouseY);
  if (selected != null) {
    system.removeNode(selected);
  }
}//mousePressed

void keyPressed() {
  if (key == ' ') { toggles[MOVING] = !toggles[MOVING]; }
  if (key == 'b') { toggles[BOUNCE] = !toggles[BOUNCE]; }
  if (key == 'g') { toggles[GRAVITY] = !toggles[GRAVITY]; }
  if (key == 'd') { toggles[DRAGF] = !toggles[DRAGF]; }
  if (key == 'e') { toggles[ELECTROSTATIC] = !toggles[ELECTROSTATIC]; }
  if (key == '=' || key =='+') {
    system.addFront(new OrbNode());
  }
  if (key == '-') {
    system.removeFront();
  }
  if (key == '1') {
    system.populate(NUM_ORBS, true);
  }
  if (key == '2') {
    system.populate(NUM_ORBS, false);
  }
}//keyPressed


void displayMode() {
  textAlign(LEFT, TOP);
  textSize(20);
  noStroke();
  int spacing = 85;
  int x = 0;

  for (int m=0; m<toggles.length; m++) {
    //set box color
    if (toggles[m]) { fill(0, 255, 0); }
    else { fill(255, 0, 0); }

    float w = textWidth(modes[m]);
    rect(x, 0, w+5, 20);
    fill(0);
    text(modes[m], x+2, 2);
    x+= w+5;
  }
}//display
