int NUM_ORBS = 10;
int MIN_SIZE = 10;
int MAX_SIZE = 60;
float MIN_MASS = 10;
float MAX_MASS = 100;
float G_CONSTANT = 1;
float D_COEF = 0.1;
float K_CONSTANT = 8.9875 * pow(10,9);  //units = N*m^2/C^2
float COULOMB = 1.602 * pow(10, -4); //a real coulomb is 10 ^-19 but it's too small to show any movement
float MIN_CHARGE = -10 *COULOMB;
float MAX_CHARGE = 10 * COULOMB;

int SPRING_LENGTH = 50;
float SPRING_K = 0.005;

int MOVING = 0;
int BOUNCE = 1;
int SIM1 = 2;
int SIM2 = 3;
int SIM3 = 4;
int SIM4 = 5;
int SIM5 = 6;
boolean[] toggles = new boolean[7];
String[] modes = {"Moving", "Bounce", "Sim 1", "Sim 2", "Sim 3", "Sim 4", "Sim 5"};

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
  
  boolean ifSpring = toggles[SIM2] || toggles[SIM5];
  system.display(ifSpring);
  if (toggles[SIM1]) {
    sun.display();
  }
  if (toggles[MOVING]) {

    if (toggles[SIM1]) {
      system.applyGravity(sun, G_CONSTANT);
    }
    
    if (toggles[SIM2]) {
      system.applySprings(SPRING_LENGTH, SPRING_K);
    }
    
    if (toggles[SIM3]) {
      system.applyDrag(D_COEF);
    }
    if (toggles[SIM4]) {
      system.applyElectrostatic(K_CONSTANT);
    }
    if (toggles[SIM5]) {
      system.applySprings(SPRING_LENGTH, SPRING_K);
      system.applyDrag(D_COEF);
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
  if (key == '1') { 
    for (int i = 0; i < toggles.length; i++){
      toggles[i] = false;
    }
    toggles[SIM1] = true;
  }
  if (key == '2') { 
    for (int i = 0; i < toggles.length; i++){
      toggles[i] = false;
    }
    toggles[SIM2] = true;
  }
  if (key == '3') { 
    for (int i = 0; i < toggles.length; i++){
      toggles[i] = false;
    }
    toggles[SIM3] = true;
  }
  if (key == '4') { 
    for (int i = 0; i < toggles.length; i++){
      toggles[i] = false;
    }
    toggles[SIM4] = true;
  }
  if (key == '5') { 
    for (int i = 0; i < toggles.length; i++){
      toggles[i] = false;
    }
    toggles[SIM5] = true;
  }
  if (key == '=' || key =='+') {
    system.addFront(new OrbNode());
  }
  if (key == '-') {
    system.removeFront();
  }
  if (key == 'q') {
    system.populate(NUM_ORBS, true);
  }
  if (key == 'w') {
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
