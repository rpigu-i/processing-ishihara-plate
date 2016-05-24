/**

Author: Andy Dennis

File: ishihara_plate

Description:
The following program provides an Ishihara colour 
plate test for colour blindness, specifically testing for
deuteranopic vision.
The program allows the user to choose from between 4 colour
palettes with various shades of red and green.

Classes: The Spot and BtnMenu 
         classes are included from tabs
         as inner classes.
         
Colour palettes: Loaded from palette JSON file.         

**/
int currentSpot;
int chosenPalette;
int frameRateVal;
int numSpots;
color canvasBg;
PImage img;
JSONObject json;
JSONObject loadedPalette;
Spot[] Spots;
BtnMenu BtnMenuItms;

void setup() {
  //initalize variables
  img = loadImage("five.png");
  json = loadJSONObject("palettes.json");
  canvasBg = color(255,255,255);
  numSpots = 1000;
  BtnMenuItms = new BtnMenu(img.height, img.width);
  currentSpot = 0;
  chosenPalette = 1;
  frameRateVal = 100; 
  initalize();
}

void initalize(){
  //setup canvas
  size(img.width,img.height+BtnMenuItms.btnMenuHeight);
  background(canvasBg);
  colorMode(RGB);
  frameRate(frameRateVal);
  Spots = new Spot[numSpots];
  
  //load and setup the colour Palette
  JSONArray Palettes = json.getJSONArray("palettes");
  for (int i = 0; i < Palettes.size(); i++) {
    JSONObject Palette = Palettes.getJSONObject(i);
    //first load grab default Palette. if Palette does not
    // exist when user enters a number, used default.
    if(Palette.getInt("id") == chosenPalette) {
       loadedPalette = Palette;
       break;
    }
  }
  BtnMenuItms.drawBtnMenu();  
}

void draw() {
  /*renders the spots in the Ishihara plate */
  if (currentSpot < Spots.length) {
    Spots[currentSpot] = new Spot(loadedPalette,canvasBg);
    Spots[currentSpot].createSpot();
    if (!Spots[currentSpot].testOverlappingSpots()) {
        Spots[currentSpot].drawSpot();
        currentSpot++;
    } 
  }
}

void mousePressed() {
  /* Passes mouse clicks off to the
     BtnMenu class instance */
  BtnMenuItms.handleClick(mouseX, mouseY);
}

void keyPressed() {
  /* Passes key presses to the
     BtnMenu class instance */  
  BtnMenuItms.handleText();
}

