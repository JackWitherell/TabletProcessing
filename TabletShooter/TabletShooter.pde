import codeanticode.tablet.*;

Tablet tablet;
Player player;

class Player{
  PVector location;
  int size=20;
  color p_color;
  float angle;
  float charge=0;
  Player(int x, int y){
    location = new PVector(x,y);
    p_color=color(255);
    angle=0;
  }
  void chargeAndShoot(){
    charge+=2/frameRate;
    rect(3,3,charge*100,5);
    rect(3,8,tablet.getPressure()*100,3);
    if(charge>tablet.getPressure()){
      float bulletCharge=charge;
      bullets.add(new Bullet(location, angle, bulletCharge));
      charge-=bulletCharge;
    }
  }
  void updatePlayer(){
    angle=angleBetweenPoints(location.x,location.y,mouseX,mouseY);
    float diff=dist(location.x,location.y,mouseX,mouseY);
    if(diff>size){
      PVector move=movementVector(angle, diff-size);
      location.add(move);
      drawAngle(20,28,move);
    }
    stroke(p_color);
    drawAngle(location.x, location.y, angle, size);
    if(mousePressed){
      chargeAndShoot();
    }
  }
}

ArrayList<Bullet> bullets;

class Bullet{
  float power;
  PVector location;
  float angle;
  float speed=3;
  Bullet(PVector loc, float r_angle, float charge){
    location=new PVector(loc.x, loc.y);
    angle=r_angle;
    power=charge;
  }
  void update(){
    location.add(movementVector(angle,speed));
  }
  boolean drawBullet(){
    circle(location.x, location.y,power*10);
    if(!boxCollision(location,0,0,width,height)){
      return false;
    }
    else{
      return true;
    }
  }
}

void setup() {
  size(300,300);
  tablet = new Tablet(this); 
  player = new Player(50,50);
  bullets=new ArrayList<Bullet>();
}

boolean boxCollision(PVector location, float x, float y, float w, float h){
  if(location.x<0||location.y<0||location.x>x+w||location.y>y+h){
    return false;
  }
  else{
    return true;
  }
}

//draws an angle from xy to an endpoint defined by an angle and a magnitude
void drawAngle(float x, float y, float radians, float a_length){
  line(x,y,x+(cos(radians)*a_length),y+(-sin(radians)*a_length));
}
void drawAngle(float x, float y, PVector movementVector){
  line(x,y,x+movementVector.x,y+movementVector.y);
}

//calculates the angle in radians between two relative points
float angleBetweenPoints(float x1, float y1, float x2, float y2){
  float radians=0;
  float deltaX=(x2-x1);
  float deltaY=(y2-y1);
  radians=atan2(deltaX, deltaY)-HALF_PI;
  return radians;
}

//takes in an angle and a distance and returns the XY coordinate endpoint.
PVector movementVector(float radians, float distance){
  return new PVector(cos(radians)*(distance),-sin(radians)*(distance));
}

void draw(){
  background(0);
  player.updatePlayer();
  stroke(255,0,0);
  drawAngle(width/2,height/2,HALF_PI,width/2);
  stroke(0,0,255);
  drawAngle(width/2,height/2,0,width/2);
  stroke(0,255,0);
  drawAngle(width/2,height/2,angleBetweenPoints(width/2,height/2,mouseX,mouseY),width/2);
  for(int i=0; i<bullets.size(); i++){
    bullets.get(i).update();
    if(!bullets.get(i).drawBullet()){
      bullets.remove(i);
    }
  }
}
