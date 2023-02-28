class Particle{
  PVector pos;
  PVector target;
  PVector vel;
  PVector acc;
  float maxspeed;
  float maxforce;
  boolean mode = true;
  
  //constructor
  Particle(PVector T, PVector P, PVector V){
     target = T;
     pos = P;
     vel = V;
     acc = new PVector(0,0);
     maxspeed = maxSpeed;
     maxforce = maxForce;
  }
  
  void behaviours(){
    if (mode){
      PVector arive = arive();
      applyForce(arive);
      if(flee_mouse){
        PVector flee = flee();
        applyForce(flee);
      }
    }else{
      //gravity
      applyForce(new PVector(random(-3,3),5));
    }
  }
  
  void applyForce(PVector f){
    acc.add(f);
  }
  
  void update(){
    if(pos.x<=0){
      pos.x = 1;
      vel.x=vel.x*-0.5;
      pos.add(vel);
    }else if(pos.x>=width){
      pos.x = width-1;
      vel.x=vel.x*-0.5;
      pos.add(vel);
    }else if(pos.y<=0){
      pos.y = 1;
      vel.y=vel.y*-0.5;
      pos.add(vel);
    }else if(pos.y>=height){
      pos.y = height-1;
      vel.y=vel.y*-0.5;
      pos.add(vel);
    }else{
      vel.add(acc);
      pos.add(vel);
      acc.mult(0); //set acceleration to 0 as force is only applied momenterilly
 
    }
  }
  
  void show(){
    strokeWeight(3);
    if(rainbow_mode){
      float hue = map(target.x,0,width,0,255);
      stroke(hue,255,255);
    }else{
      stroke(255);
    }
    point(pos.x,pos.y);
  }
  
  PVector arive(){
    PVector desired = new PVector(target.x-pos.x,target.y-pos.y);
    // desired = target.sub(pos) for some reason doesnt work
    float distance = desired.mag();
    float speed = maxspeed;
    if (distance < 100){
      speed = map(distance, 0, 100, 0, maxspeed); 
    }
    desired.setMag(speed);
    PVector steer = new PVector(desired.x-vel.x,desired.y-vel.y);
    //println(pos,target,desired,steer);
    steer.limit(maxforce);
    return steer;
  }
  
  PVector flee(){
    PVector desired = new PVector(mouseX-pos.x,mouseY-pos.y);
    // desired = target.sub(pos) for some reason doesnt work
    float distance = desired.mag();
    if (distance < 50){
      float speed = map(distance, 0, 50, maxspeed, 1); 
      desired.setMag(speed);
      desired.mult(-10); //weight *10, negative for repulsive force
      PVector steer = desired.sub(vel);
      //println(pos,target,desired,steer);
      return steer;
    }else{
      return new PVector(0,0); 
    }
  }   
}
