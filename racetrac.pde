PImage bg; String image = "track.JPG";  // image size = 1049 x 862
int [] bzr; int [][] legs = { {225,269,238,148,216,158,356,227},
{356,227,502,322,182,332,428,396},
{428,396,554,410,570,388,512,266},
{512,266,472,153,350,207,358,119},
{358,119,349,78,369,64,459,70},
{459,70,661,63,681,71,732,183},
{732,183,781,245,621,253,736,347},
{736,347,997,502,873,642,701,527},
{701,527,577,501,719,335,566,443},
{566,443,508,581,500,523,614,603},
{614,603,862,704,756,884,528,635},
{528,635,205,365,227,433,224,269} };
int speed = 10, leg = 0, steps = 1000/speed, points = 0, lp=0, damage = 0, damageAmt = 52, laps=0;
float turn = 0.0, accel = 10.0, slopeDelta = 0.033;
void setup() { size(1049, 862); }//noLoop(); }
void draw() {
  if (laps < 10 && damage < 100) {
    // load background image
    bg = loadImage(image);
    image(bg, 0, 0, width, height);
    background(bg);
    //draw car
    bzr = legs[leg]; 
    steps = round(accel);
    float t = (frameCount%steps) / float(steps), tr=0.0, radius = 0.0;
    if (t <slopeDelta) t = slopeDelta*2;
    float x1 = bezierPoint(bzr[0], bzr[2], bzr[4], bzr[6], t-slopeDelta);
    float y1 = bezierPoint(bzr[1], bzr[3], bzr[5], bzr[7], t-slopeDelta);
    float x2 = bezierPoint(bzr[0], bzr[2], bzr[4], bzr[6], t+slopeDelta);
    float y2 = bezierPoint(bzr[1], bzr[3], bzr[5], bzr[7], t+slopeDelta);
    float x = bezierPoint(bzr[0], bzr[2], bzr[4], bzr[6], t);
    float y = bezierPoint(bzr[1], bzr[3], bzr[5], bzr[7], t);
    //draw Blue body
    stroke(0, 0, random(255));
    strokeWeight(11);
    line(x1, y1, x2, y2);
    //draw helmet
    stroke(255, 255, 255);
    strokeWeight(2);
    fill(255, 0, 0);
    if (!Float.isNaN(tr = (x2-x1)/2)) radius = tr;
    ellipse(x, y, radius, radius);
    //damage criteria
    if ((tan((y2-y1)/(x2-x1))<0 && turn < 0 )||(tan((y2-y1)/(x2-x1))>0 && turn > 0 ) ) { lp = points++; } 
    else { points--; if ((lp - points)%damageAmt==damageAmt-1) { damage+=speed; } }
    //Leg Navigation
    if (frameCount%steps == steps-1) leg++;
    if (leg > legs.length-1) { leg = 0 ; laps++; }
  } else {
    fill(255, 255, 100); text("Score: "+(points+400), 10, height/2-20);
    if (damage >= 100 && laps <10) text("Crash & burn on lap "+laps+" ! !", 17, height/2+20);
    else { fill(0, 0, 255); text("Winner !!", width/2-20, height/2+20); }
  }
}
//void mouseDragged() { redraw();} void mousePressed(){ redraw();} // if removed then remove noLoop in setup
//void mouseMoved(){ accel = (mouseY-pmouseY > 25||mouseY-pmouseY < -25)?map(mouseY, height, 10, 10, 300):accel; turn = map(mouseX, 0, width, -45, 45); }