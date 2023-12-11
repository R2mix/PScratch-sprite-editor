boolean remover, eraser;
String  imageImported;
int imgSize = 100, imgX, imgY, slsize = 512, colorTreshold = 1, eraserSize = 10;

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
    .setRange(16, 512)
    .setValue(512)
    .setColorBackground(color(#FFFFFF))
    .setColorLabel(color(#3E3E3E))
    .setColorCaptionLabel(color(#000000))
    .setColorForeground(color(#A0A0A0))
    .setCaptionLabel("Size")
    ;
  // ---- slider de la taille de l'image dans l'éditeur ----
  cp5.addSlider("imgSize")
    .setPosition(10, 310)
    .setSize(20, 200)
    .setRange(1, 200)
    .setColorBackground(color(#FFFFFF))
    .setColorLabel(color(#3E3E3E))
    .setColorCaptionLabel(color(#000000))
    .setColorForeground(color(#A0A0A0))
    .setCaptionLabel("image")
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
    .setCaptionLabel("image")
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
    img = createImage(imageNonConverted.width, imageNonConverted.height, ARGB);
    imageNonConverted.loadPixels();
    img.loadPixels();
    // copy les pixels d'une image dans l'autre
    arrayCopy(imageNonConverted.pixels, img.pixels);
    imageImported = selection.getName();
  }
}
// ---------------------------------------------------------------------

// --------------------------export image buttons -------------------
void exportButton() {
  if (img != null) {
    // comme pour l'import on créer une image d'export a partir du PGraphics pour éviter le crash
    pg.loadPixels();
    PImage  imageExported = createImage(pg.width, pg.height, ARGB);
    imageExported.loadPixels();
    arrayCopy(pg.pixels, imageExported.pixels);
    imageExported.resize(slsize, slsize);
    imageExported.save("export/" + removeExtension(imageImported) + ".png");
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
