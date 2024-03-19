// ----- Missing = CRTL + Z ou reset button en rappelant l'image de base -----

// à finir , crop et undo/redo
import controlP5.*;
ControlP5 cp5;

PImage img;
PGraphics renderGraphic;
boolean dragged, savingStack;

ArrayList<PImage> undoStack = new ArrayList<PImage>();

void setup() {
  size(800, 600);
  renderGraphic = createGraphics(512, 512);
  cp5 = new ControlP5(this);
  initButtons();
  PImage ics = loadImage("costume1.png");
  surface.setIcon(ics);
  surface.setTitle("PScratch sprite editor - BETA 1");
}

void draw() {
  println(stackTrace, undoStack.size()-1);
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
  rect(width/2, height/2, cropWidth, cropHeight);
  strokeWeight(8);
  point(width/2 - cropWidth/2, height/2 - cropHeight/2);
  image(renderGraphic, width/2, height/2, 512, 512);
  strokeWeight(1);
  noFill();
  stroke(0, 255, 0, 200);
  rect(width/2, height/2, cropWidth, cropHeight);
  stroke(0);
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
    renderGraphic.beginDraw();
    renderGraphic.clear();
    renderGraphic.image(img, imgX, imgY, img.width * imgSize/100, img.height * imgSize/100);
    renderGraphic.endDraw();
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
    renderGraphic.beginDraw();
    removeBackground();
    renderGraphic.endDraw();
  }
  // --- vérifie si on clique sur drag
  if (img != null && dist(mouseX, mouseY, width/2, height/2) < 256 && !dragged && !remover && !eraser) {
    dragged = true;
  }
  if (mouseX > width/2 - 256 && mouseX < width/2 + 256 && mouseY > height/2 - 256 && mouseY < height/2 + 256 ) {
    savingStack = true;
  }
}

void mouseReleased() {
  dragged = false;

  if (savingStack) {
    saveStackTrace();
    savingStack = false;
  }
}

// ------------ saving stack for ctrl z dans un array -------
void saveStackTrace() {
  if (img != null) {
    if (stackTrace >= undoStack.size()-1) {
      stackTrace ++;
      undoStack.add(renderGraphic.get());
    } else {
      // remove the extra stack if a change come during
      int removeStack = undoStack.size()-1 - stackTrace;
      for (int i =0; i < removeStack; i++) {
        undoStack.remove(undoStack.size() -1);
      }
    }
  }
}
