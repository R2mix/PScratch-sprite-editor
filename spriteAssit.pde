// ----- Missing = CRTL + Z ou reset button en rappelant l'image de base -----


import controlP5.*;
PImage img;
ControlP5 cp5;
PGraphics pg;
boolean dragged;

void setup() {
  size(800, 600);
  pg = createGraphics(512, 512);
  cp5 = new ControlP5(this);
  initButtons();
  PImage ics = loadImage("costume1.png"); 
  surface.setIcon(ics);
  surface.setTitle("PScratch sprite editor - alpha 1");
}

void draw() {
  // ===== display the interface =========
  display();
  //--------------------------------------
  // == display the image and dragging ==
  placeImage();
  //--------------------------------------
  eraserImage();
}

void display() {
  background(150);
  push();
  imageMode(CENTER);
  rectMode(CENTER);
  fill(200);
  rect(width/2, height/2, 512, 512);
  image(pg, width/2, height/2, 512, 512);
  line( width/2, 0, width/2, height);
  line(0, height/2, width, height/2);
  pop();

  // ----- controler change when boolean is on -----------
  if (remover) {
    cp5.getController("backgroundRemover").setColorBackground(color(#3E3E3E));
  } else {
    cp5.getController("backgroundRemover").setColorBackground(color(#FFFFFF));
  }

  if (eraser) {
    cp5.getController("eraser").setColorBackground(color(#3E3E3E));
  } else {
    cp5.getController("eraser").setColorBackground(color(#FFFFFF));
  }
  //-------------------------------------------------------
}

void placeImage() {
  if (img != null) {
    pg.beginDraw();
    pg.clear();
    pg.image(img, imgX, imgY, img.width * imgSize/100, img.height * imgSize/100);
    pg.endDraw();
  }
  // --- l'image suit la souris
  if (dragged) {
    imgX += mouseX - pmouseX;
    imgY += mouseY - pmouseY ;
  }
}

void mousePressed() {
  // --- on active les fonction de background removal
  if (img != null && mousePressed && remover) {
    pg.beginDraw();
    removeBackground();
    pg.endDraw();
  }
  // --- vérifie si on clique sur drag
  if (img != null && dist(mouseX, mouseY, width/2, height/2) < (slsize)/2 && !dragged && !remover && !eraser) {
    dragged = true;
  }
}

void mouseReleased() {
  dragged = false;
}
