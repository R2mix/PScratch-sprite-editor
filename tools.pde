// ------------------ eraser test ----------------------------------------------
void eraserImage() {

  if (eraser) {
    push();
    noFill();
    circle( mouseX, mouseY, eraserSize);
    pop();
  }

  if (eraser && mousePressed && img != null) {
    // calcules du coefficent de raport largeur, % en float
    float coeffimgW = renderGraphic.width/(renderGraphic.width * imgSize/100.00);
    float coeffimgH = renderGraphic.height/(renderGraphic.height * imgSize/100.00);
    //float coeffrenderGraphic = 256/(256 * slsize/100.00);
    // calcules pour suivre la souris dans l'image après translation ou zoom
    int pmX = (int) map(mouseX, 144, 656, 0, (512  * coeffimgW ) ) - (int)(imgX * coeffimgW) ;
    int pmY = (int) map(mouseY, 44, 556, 0, (512 * coeffimgH) ) - (int)(imgY * coeffimgH) ;

    // pour la taille de l'effaceur suivant le zoom sur l'image.
    int eraserSizePondered = (int) map(eraserSize, imgSize, 0, 100, 1);
    // gomme circulaire autour de la souris
    for (int i =0; i < eraserSizePondered; i++) {
      for (int j =0; j < eraserSizePondered; j++) {
        if (dist(pmX + eraserSizePondered/2, pmY + eraserSizePondered/2, pmX + i, pmY + j) < eraserSizePondered/2) {
          img.set(pmX + i - eraserSizePondered/2, pmY + j - eraserSizePondered/2, color(0, 0));
        }
      }
    }
  }
}




import java.util.LinkedList;

color targetColor, illegal_color = color(0, 0);

// ------------------ remove background flood --------------------------------
void removeBackground() {
  // calcules du coefficent de raport largeur, % en float
  float coeffimgW = renderGraphic.width/(renderGraphic.width * imgSize/100.00);
  float coeffimgH = renderGraphic.height/(renderGraphic.height * imgSize/100.00);
  // calcules pour suivre la souris dans l'image après translation ou zoom
  int pmX = (int) map(mouseX, 144, 656, 0, (512  * coeffimgW ) ) - (int)(imgX * coeffimgW) ;
  int pmY = (int) map(mouseY, 44, 556, 0, (512 * coeffimgH) ) - (int)(imgY * coeffimgH) ;
  // on récupère la couleur sous la souris (qui là n'a pas de zoom ni déplacement car c'est sa position dans le layer
  targetColor = renderGraphic.get( (int)map(mouseX, 144, 656, 0, 512 ), (int)map(mouseY, 44, 556, 0, 512 ));
  // au cas ou la couleur est déjà vide et on efface les zones
  if (targetColor != illegal_color) {
    floodFill(pmX, pmY);
  }
}
// ---------------------------------------------------------------------

void floodFill(int startX, int startY) {
  // Créer une liste chaînée pour simuler une file
  LinkedList<PVector> queue = new LinkedList<PVector>();

  // Ajouter les coordonnées du pixel de départ à la file
  queue.add(new PVector(startX, startY));

  while (!queue.isEmpty()) {
    PVector current = queue.poll();
    int x = (int) current.x;
    int y = (int) current.y;

    if (x >= 0 && x < img.width * 2 && y >= 0 && y < img.height * 2) {
      color pixelColor = img.get(x, y);
      // added distance alpha for the bug with black color
      float distance = dist(red(pixelColor), green(pixelColor), blue(pixelColor), red(targetColor), green(targetColor), blue(targetColor))
        + dist(alpha(pixelColor), 0, alpha(targetColor), 0) ;

      // Vérifier si le pixel est dans les limites de l'image et a la couleur cible
      if ( distance < colorTreshold) {
        // Remplacer la couleur du pixel
        img.set(x, y, color(0, 0));
        // Ajouter les pixels adjacents à la file
        queue.add(new PVector(x + 1, y));
        queue.add(new PVector(x - 1, y));
        queue.add(new PVector(x, y + 1));
        queue.add(new PVector(x, y - 1));
      }
    }
  }
  println(queue.size());
}



/*
// ------------------ old remove background --------------------------------
 void removeBackground() {
 // tester avec while et peut etre get jusqu'à toucher un bord d'une autre couleur
 img.loadPixels();
 int pmX = mouseX - width/2 + ( 256 * slsize/100);
 int pmY = mouseY - height/2 + ( 256 * slsize/100);
 
 if (pmX < renderGraphic.width && pmX > 0 && pmY < renderGraphic.height && pmY > 0) {
 color targetColor = renderGraphic.get(pmX, pmY);
 
 for (int i = 0; i < img.pixels.length; i++) {
 float d = dist(red(img.pixels[i]), green(img.pixels[i]), blue(img.pixels[i]), red(targetColor), green(targetColor), blue(targetColor));
 // Comparaison des couleurs en fonction de la distance
 if (d < colorTreshold) {  // Ajuste la valeur selon tes besoins
 img.pixels[i] = color(0, 0);
 }
 }
 img.updatePixels();
 }
 }
 // ---------------------------------------------------------------------
 */
