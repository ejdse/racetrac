PImage bg; String image = "track.JPG";  // image size = 1049 x 862
int [] bzr; int [][] legs = { {245 ,  162 ,  397 ,  250 ,  401 ,  261 ,  401 ,  272},
{401 ,  272 ,  392 ,  289 ,  380 ,  298 ,  370 ,  303}, {370 ,  303 ,  351 ,  314 ,  340 ,  320 ,  335 ,  331},
{335 ,  331 ,  329 ,  353 ,  332 ,  365 ,  340 ,  377}, {340 ,  377 ,  369 ,  385 ,  544 ,  403 ,  552 ,  376},
{552 ,  376 ,  501 ,  221 ,  491 ,  208 ,  378 ,  172}, {378 ,  172 ,  357 ,  153 ,  357 ,  78 ,  392 ,  65},  
{392 ,  65 ,  642 ,  67 ,  671 ,  71 ,  685 ,  86}, {685 ,  86 ,  748 ,  198 ,  749 ,  219 ,  731 ,  241}, 
{731 ,  241 ,  687 ,  260 ,  683 ,  288 ,  699 ,  323}, {699 ,  323 ,  892 ,  478 ,  901 ,  495 ,  896 ,  520},
{896 ,  520 ,  860 ,  565 ,  846 ,  574 ,  819 ,  571}, {819 ,  571 ,  649 ,  510 ,  637 ,  498 ,  632 ,  481},
{632 ,  481 ,  653 ,  429 ,  645 ,  411 ,  618 ,  398}, {618 ,  398 ,  589 ,  398 ,  521 ,  524 ,  524 ,  547},
{524 ,  547 ,  749 ,  670 ,  763 ,  695 ,  768 ,  718}, {768 ,  718 ,  761 ,  745 ,  738 ,  769 ,  700 ,  775},
{700 ,  775 ,  222 ,  387 ,  213 ,  366 ,  218 ,  343}, {218 ,  343 ,  221 ,  189 ,  229 ,  171 ,  245 ,  162} };
int speed = 10, leg = 0, steps = 1000/speed, points = 0, lp=0, damage = 0, damageAmt = 52, laps=0;
float turn = 0.0, accel = 10.0, slopeDelta = 0.033;
void setup() { size(1049, 862); noLoop(); }
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