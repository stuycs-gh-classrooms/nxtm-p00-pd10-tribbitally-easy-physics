class Orb {

  //instance variables
  PVector center;
  PVector velocity;
  PVector acceleration;
  float bsize;
  float mass;
  float charge;  //charge in coulumbs, make sure to add - if negative charge
  color c;


  Orb() {
     bsize = random(10, MAX_SIZE);
     float x = random(bsize/2, width-bsize/2);
     float y = random(bsize/2, height-bsize/2);
     center = new PVector(x, y);
     mass = random(10, 100);
     velocity = new PVector();
     acceleration = new PVector();
     setColor();
     charge = random (MIN_CHARGE, MAX_CHARGE);
  }

  Orb(float x, float y, float s, float m, float c) {
     bsize = s;
     mass = m;
     center = new PVector(x, y);
     velocity = new PVector();
     acceleration = new PVector();
     setColor();
     charge = c;
   }

  //movement behavior
  void move(boolean bounce) {
    if (bounce) {
      xBounce();
      yBounce();
    }

    velocity.add(acceleration);
    center.add(velocity);
    acceleration.mult(0);
  }//move

  void applyForce(PVector force) {
    PVector scaleForce = force.copy();
    scaleForce.div(mass);
    acceleration.add(scaleForce);
  }

  PVector getDragForce(float cd) {
    float dragMag = velocity.mag();
    dragMag = -0.5 * dragMag * dragMag * cd;
    PVector dragForce = velocity.copy();
    dragForce.normalize();
    dragForce.mult(dragMag);
    return dragForce;
  }

  PVector getGravity(Orb other, float G) {
    float strength = G * mass*other.mass;
    //dont want to divide by 0!
    float r = max(center.dist(other.center), MIN_SIZE);
    strength = strength/ pow(r, 2);
    PVector force = other.center.copy();
    force.sub(center);
    force.mult(strength);
    return force;
  }

  //spring force between calling orb and other
  PVector getSpring(Orb other, int springLength, float springK) {
    PVector direction = PVector.sub(other.center, this.center);
    direction.normalize();

    float displacement = this.center.dist(other.center) - springLength;
    float mag = springK * displacement;
    direction.mult(mag);

    return direction;
  }//getSpring

  boolean yBounce(){
    if (center.y > height - bsize/2) {
      velocity.y *= -1;
      center.y = height - bsize/2;

      return true;
    }//bottom bounce
    else if (center.y < bsize/2) {
      velocity.y*= -1;
      center.y = bsize/2;
      return true;
    }
    return false;
  }//yBounce
  boolean xBounce() {
    if (center.x > width - bsize/2) {
      center.x = width - bsize/2;
      velocity.x *= -1;
      return true;
    }
    else if (center.x < bsize/2) {
      center.x = bsize/2;
      velocity.x *= -1;
      return true;
    }
    return false;
  }//xbounce

  boolean collisionCheck(Orb other) {
    return ( this.center.dist(other.center)
             <= (this.bsize/2 + other.bsize/2) );
  }//collisionCheck

  boolean isSelected(float x, float y) {
    float d = dist(x, y, center.x, center.y);
    return d < bsize/2;
  }//isSelected

  void setColor() {
    color c0 = color(0, 255, 255);
    color c1 = color(0);
    c = lerpColor(c0, c1, (mass-MIN_SIZE)/(MAX_MASS-MIN_SIZE));
  }//setColor
  
  void setOutline() {
    strokeWeight(5);
    color c0 = color(255, 255, 255);
    color c1;
    color c2;
    if (charge >= 0){
      c1 = color(0, 255, 0);
      c2 = lerpColor(c0, c1, charge/MAX_CHARGE);  //makes it a shade of green if a positive charge
    }
    else{
      c1 = color(255, 0 , 0);
      c2 = lerpColor(c0, c1, charge/MIN_CHARGE);  //makes it a shade of red if a negative charge
    }
    stroke(c2);
  }
    
  //visual behavior
  void display() {
    setOutline();
    fill(c);
    circle(center.x, center.y, bsize);
    fill(0);
    //text(mass, center.x, center.y);
    
  }//display
  
  
  
  
  PVector getElectrostaticForce(Orb other, float k){
    //dont want to divide by 0!
    PVector r = new PVector(center.x - other.center.x, center.y - other.center.y);
    float distance = max(r.mag(), MIN_SIZE);
    float distanceSquared = distance * distance;
    
    float q1 = charge;
    float q2 = other.charge;
    
    //Coulomb's Law: F = k * q1 * q2 / r^2 * direction
    PVector F = r.copy().normalize();
    F.mult((k * q1 * q2) / distanceSquared);
    return F;
  }//getElectrostatic
  
  PVector electrostaticField(PVector electrostaticForce, float k){
    PVector E = new PVector();
    E.x = electrostaticForce.x/k;  //k is the "test charge" according to E = F/q
    E.y = electrostaticForce.y/k;
    return E;
  }//electrostaticField
  
}//Orb
