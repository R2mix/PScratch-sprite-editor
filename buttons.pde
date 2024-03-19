boolean remover, eraser;
int stackTrace = 0;
String  imageImported;
int imgSize = 100, imgX, imgY, slsize = 100, colorTreshold = 1, eraserSize = 10;
int cropWidth = 512, cropHeight = 512;
// --------------------------Init buttons -------------------
void initButtons() {

  // ---- bouton pour importer des images ----
  cp5.addButton("importButton")
    .setPosition(10, 10)
    .setSize(80, 30)
    .setCaptionLabel("Importer")
    .setColorBackground(color(#FFFFFF))
    .setColorLabel(color(#3E3E3E))
    .setColorCaptionLabel(color(#000000))
    .setColorForeground(color(#A0A0A0))
    ;
  // ---- bouton pour exporter les images ----
  cp5.addButton("exportButton")
    .setPosition(100, 10)
    .setSize(80, 30)
    .setCaptionLabel("Exporter")
    .setColorBackground(color(#FFFFFF))
    .setColorLabel(color(#3E3E3E))
    .setColorCaptionLabel(color(#000000))
    .setColorForeground(color(#A0A0A0))
    ;
  // ---- slider de la résolution d'export ----
  cp5.addSlider("slsize")
    .setPosition(10, 50)
    .setSize(20, 200)
    .setRange(1, 100)
    .setValue(100)
    .setColorBackground(color(#FFFFFF))
    .setColorLabel(color(#3E3E3E))
    .setColorCaptionLabel(color(#000000))
    .setColorForeground(color(#A0A0A0))
    .setCaptionLabel("Quality %")
    ;
  // ---- slider de la taille de l'image dans l'éditeur ----
  cp5.addSlider("imgSize")
    .setPosition(10, 310)
    .setSize(20, 200)
    .setRange(1, 1000)
    .setColorBackground(color(#FFFFFF))
    .setColorLabel(color(#3E3E3E))
    .setColorCaptionLabel(color(#000000))
    .setColorForeground(color(#A0A0A0))
    .setCaptionLabel("image Size")
    ;
  // ---- bouton pour la magic wand ----
  cp5.addButton("backgroundRemover")
    .setPosition(700, 10)
    .setSize(80, 30)
    .setCaptionLabel("Magic Wand")
    .setColorBackground(color(#FFFFFF))
    .setColorLabel(color(#3E3E3E))
    .setColorCaptionLabel(color(#000000))
    .setColorForeground(color(#A0A0A0))
    ;
  // ---- bouton pour la gomme ----
  cp5.addButton("eraser")
    .setPosition(610, 10)
    .setSize(80, 30)
    .setCaptionLabel("Eraser")
    .setColorBackground(color(#FFFFFF))
    .setColorLabel(color(#3E3E3E))
    .setColorCaptionLabel(color(#000000))
    .setColorForeground(color(#A0A0A0))
    ;
  // ---- slider du seuil de la magic wand ----
  cp5.addSlider("colorTreshold")
    .setPosition(760, 50)
    .setSize(20, 200)
    .setRange(1, 200)
    .setColorBackground(color(#FFFFFF))
    .setColorLabel(color(#3E3E3E))
    .setColorCaptionLabel(color(#000000))
    .setColorForeground(color(#A0A0A0))
    .setCaptionLabel("Treshold")
    ;
  // ---- slider du seuil de la taille de la gomme ----
  cp5.addSlider("eraserSize")
    .setPosition(760, 310)
    .setSize(20, 200)
    .setRange(1, 50)
    .setColorBackground(color(#FFFFFF))
    .setColorLabel(color(#3E3E3E))
    .setColorCaptionLabel(color(#000000))
    .setColorForeground(color(#A0A0A0))
    .setCaptionLabel("Eraser")
    ;

  // ---- slider du seuil de la taille de la gomme ----
  cp5.addSlider("cropWidth")
    .setPosition(width/2 - 256, height/2 + 260)
    .setSize(512, 10)
    .setRange(1, 512)
    .setColorBackground(color(#FFFFFF))
    .setColorLabel(color(#3E3E3E))
    .setColorCaptionLabel(color(#000000))
    .setColorForeground(color(#A0A0A0))
    .setCaptionLabel("L")
    .setValue(512)     // Valeur initiale
    ;


  // ---- slider du seuil de la taille de la gomme ----
  cp5.addSlider("cropHeight")
    .setPosition(width/2 - 270, height/2 - 256)
    .setSize(10, 512)
    .setRange(1, 512)
    .setColorBackground(color(#FFFFFF))
    .setColorLabel(color(#3E3E3E))
    .setColorCaptionLabel(color(#000000))
    .setColorForeground(color(#A0A0A0))
    .setCaptionLabel("H")
    .setValue(512)     // Valeur initiale
    ;

  // ---- slider du seuil de la taille de la gomme ----
  cp5.addButton("undo")
    .setPosition(width/2 + 25, height/2 - 290)
    .setSize(25, 25)
    .setColorBackground(color(#FFFFFF))
    .setColorLabel(color(#3E3E3E))
    .setColorCaptionLabel(color(#000000))
    .setColorForeground(color(#A0A0A0))
    .setCaptionLabel("<-")
    ;

  // ---- slider du seuil de la taille de la gomme ----
  cp5.addButton("redo")
    .setPosition(width/2 - 50, height/2 - 290)
    .setSize(25, 25)
    .setColorBackground(color(#FFFFFF))
    .setColorLabel(color(#3E3E3E))
    .setColorCaptionLabel(color(#000000))
    .setColorForeground(color(#A0A0A0))
    .setCaptionLabel("->")
    ;
}
// ---------------------------------------------------------------------


// --------------------------background remover buttons -------------------
void backgroundRemover() {
  if (!remover) {
    remover = true;
    eraser = false;
  } else if (!eraser) {
    remover = false;
  }
}
void eraser() {
  if (!eraser) {
    eraser = true;
    remover = false;
  } else if (!remover) {
    eraser = false;
  }
}
// ---------------------------------------------------------------------
// --------------------------import image buttons -------------------
void importButton() {
  selectInput("Sélectionner une image à importer", "fileSelected");
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Aucun fichier sélectionné.");
  } else {
    println("Fichier sélectionné : " + selection.getAbsolutePath());
    // on créer une nouvelle image, on charge ses pixels pour les collers dans la nouvelle pour travailler sur de la transparence
    PImage  imageNonConverted = loadImage(selection.getAbsolutePath());
    if (imageNonConverted.width > imageNonConverted.height) {
      imageNonConverted.resize(constrain(imageNonConverted.width, 1, 512), 0);
    } else {
      imageNonConverted.resize(0, constrain(imageNonConverted.height, 1, 512));
    }
    img = createImage(imageNonConverted.width, imageNonConverted.height, ARGB);
    imageNonConverted.loadPixels();
    img.loadPixels();
    // copy les pixels d'une image dans l'autre
    arrayCopy(imageNonConverted.pixels, img.pixels);
    imageImported = selection.getName();
    // -------------  save dans la stack pour le ctrl z  ----------------
    stackTrace = -1;
    undoStack.clear();
    delay(50);
    saveStackTrace();
    imgX =0;
    imgY =0;
  }
}
// ---------------------------------------------------------------------
// ------------------------- Export image buttons ----------------------

void exportButton() {
  if (img != null) {
    PImage cropped = renderGraphic.get(renderGraphic.width/2 - cropWidth/2, renderGraphic.height/2 - cropHeight/2, cropWidth, cropHeight);
    cropped.resize(cropWidth * slsize/100, cropHeight * slsize/100);
    cropped.save("export/" + removeExtension(imageImported) + ".png");
  }
}
// Fonction pour supprimer l'extension du nom de fichier
String removeExtension(String fileName) {
  int dotIndex = fileName.lastIndexOf('.');
  if (dotIndex != -1 && dotIndex < fileName.length()) {
    return fileName.substring(0, dotIndex);
  } else {
    return fileName;
  }
}
// ---------------------------------------------------------------------


// ---------------------------------------------------------------------
// ------------------------- undo buttons ------------------------------
void undo() {
  if (stackTrace > 0) {
    // Récupérer le dernier état de la pile d'undo
    stackTrace --;
    img = undoStack.get(stackTrace);
    imgX = 0;
    imgY = 0;
  }
}
// ---------------------------------------------------------------------
// ------------------------- redo buttons ------------------------------
void redo() {
  if (stackTrace < undoStack.size()-1) {
    // Récupérer le dernier état de la pile d'undo
    stackTrace ++;
    img = undoStack.get(stackTrace);
    imgX = 0;
    imgY = 0;
  }
}
// ---------------------------------------------------------------------
