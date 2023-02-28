int text_size_overide = 0; //set to 0 for auto size to screen
boolean rainbow_mode = true;
boolean outline_only = true; //improves performance, less particles
boolean flee_mouse = true;
float maxSpeed = 20;
float maxForce = 1;
int start_mode = 4; //0 = random - particles start randomly across screen
                    //1 = randomer - particles start with random pos and vel
                    //2 = dot - paricles start at singularity in centre
                    //3 = corner- particles start at singularity in NW corner
                    //4 = circle - particles explode from centre in circle
                    
boolean record = false;
PGraphics pg;
String txt;
ArrayList<Particle> balls;

void setup(){
  fullScreen(P2D);
  colorMode(HSB);
  pg = createGraphics(width,height);
  String[] lines = loadStrings("data\\text.txt");
  txt = join(lines, "\n");
 
  pg.beginDraw();
  pg.background(0);
  pg.fill(255);
  pg.textAlign(CENTER,CENTER);
  int size = 1;
  if (text_size_overide <= 0){
    pg.textSize(1);
    while ((pg.textWidth(txt)<width-10)&&(pg.textAscent()+pg.textDescent()<height-10)){
      size++;
      pg.textSize(size);
    }
  }else{
    size = text_size_overide;
    pg.textSize(text_size_overide);
  }
 
  if (outline_only){
    PGraphics temp = createGraphics(pg.width,pg.height);
    temp.beginDraw();
    temp.background(0);
    temp.fill(255);
    temp.stroke(255);
    temp.textAlign(CENTER,CENTER);
    temp.textSize(size);
    temp.text(txt,width/2,height/2);
    temp.endDraw();
    
    pg.strokeWeight(size/40);
    
    for (int x = 0; x<temp.width; x++){
      for (int y = 0; y<temp.height; y++){
        int loc = x + (y*temp.width);
        if (temp.pixels[loc] != color(0)){
          
          boolean textEdge = false;
          int startx;
          int stopx;
          int starty;
          int stopy;;
          
          //deal with edges of screen
          if(x==0){
            startx=0;
          }else{
            startx=-1; 
          }
          if(x==width-1){
            stopx=0;
          }else{
            stopx=1;
          }
          if(y==0){
            starty=0;
          }else{
            starty=-1; 
          }
          if(y==height-1){
            stopy=0;
          }else{
            stopy=1;
          }
            
            
          for (int i=startx; i<=stopx; i++){
            for (int j=starty; j<=stopy; j++){
              int coord = (x+i + ((y+j)*temp.width));
              if (temp.pixels[coord]==color(0)){ //if x,y has even 1 black neightbour it is an edge
                textEdge = true; 
              }
            }
          }
          //if none found edge remains false
          if(textEdge){//edge will resolve to boolean
            pg.stroke(255);
            pg.point(x,y);
          }
        }
      }
    }
        
  }else{
    pg.text(txt,pg.width/2,pg.height/2);
  }
  pg.endDraw();

  balls = new ArrayList<Particle>();
  for (int x = 0; x < pg.width; x++){
     for (int y = 0; y < pg.height; y++){
        int loc = x + (y*pg.width);

        if (pg.pixels[loc] == color(255)){
          
          PVector target = new PVector(x,y);
          PVector pos;
          PVector vel;
          if(start_mode == 1){ //randomer
            pos = new PVector(random(width),random(height));
            vel = PVector.random2D();
            vel.mult(random(100));
            
          }else if(start_mode == 2){ //dot
            pos = new PVector(width/2,height/2);
            vel = new PVector(0,0);
            
          }else if(start_mode == 3){ //corner
            pos = new PVector(0,0);
            vel = new PVector(0,0);
            
          }else if(start_mode == 4){ //circle
            pos = new PVector(width/2,height/2);
            vel = PVector.random2D();
            vel.mult(30);
            
          }else{ //default to 0 = random mode
            pos = new PVector(random(width),random(height));
            vel = new PVector(0,0);
          }
          
          Particle ball = new Particle(target, pos, vel);
          balls.add(ball);
        }
     }
  }
}

void keyPressed(){
  if(key==' '){
    for (Particle p : balls){
      p.mode = false;
    }
  }
}

void draw(){
  stroke(255);
  background(0);
  for (Particle p : balls){
    p.behaviours();
    p.update();
    p.show();
  }
  
  if(record){
    saveFrame("output/frame_####.png"); 
  }
}
