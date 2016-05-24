/**

Author: Andy Dennis

File: BtnMenu

Description:
The spot classes is responsible for generating a colour plate
based upon an input image ( a number 5). 
It takes the image and regenrates it
in a circle made upon of coloured spots, one set of spots e.g. red
for the background, and one set e.g. green for the figure 5.
       
References:

Code/ideas dervived from the following links is also anotated in
comments below.

1.) Generate a random point within a circle (uniformly)
http://stackoverflow.com/questions/5837572/generate-a-random-point-within-a-circle-uniformly
2.) Pointillism by Daniel Shiffman.  
https://www.processing.org/examples/pointillism.html
3.) Color Blindness Test Images
http://vis4.net/labs/61
4.) Online Pseudoisochromatic Plates Color Vision Test
http://www.color-blindness.com/2010/12/03/online-pseudoisochromatic-plates-color-vision-test/
5.) PseudoIsochromatic Plate (PIP) Color Vision Test 24 Plate Edition
http://www.eyemagazine.com/feature/article/ishihara
6.) Ishihara Color Test
http://www.colour-blindness.com/colour-blindness-tests/ishihara-colour-test-plates/

**/

class Spot {
  float x, y, spotRadius, random, area;
  int largePoint, smallPoint; 
  int[] circleX, circleY;
  color canvasBg;
  JSONObject Palette;
  
  Spot(JSONObject loadedPalette, color cBg) {
    /*Spot constructor */
    largePoint = 22;
    smallPoint = 6;
    /* Spot radius, idea derived from refrence [2] */
    spotRadius = random(smallPoint, largePoint)/2;
    /* Random point based upon circle Radius minus spot Radius */
    random = random(0, width/2-spotRadius);
    area = random(PI*2);
    /* Get a point in the circle. 
       Concept dervived from references [1] and [3]
    */   
    x = (width/2)+cos(area)*random;
    y = (width/2)+sin(area)*random;
    Palette = loadedPalette;
    canvasBg = cBg;
  }
    
  void createSpot() {
    /* Generates spots in 
       plate */ 
    int x = int(this.x);
    int y = int(this.y);
    int r = int(spotRadius);
    // Get the pixels from the circle
    // where we plan to place our spot.
    // Concept dervived from code at
    // reference [3] 
    int[] circleX = {x,x,x,
                x-r,x+r,
                int(x-r*.93),
                int(x-r*.93),
                int(x+r*.93),
                int(x+r*.93)
               };  
    int[] circleY = {y,y-r,y+r,
                y,y,
                int(y+r*.93),
                int(y-r*.93),
                int(y+r*.93),
                int(y-r*.93)
               };
                
    this.circleX = circleX;
    this.circleY = circleY;
  }

  boolean testOverlappingSpots() {
    /* Checks to ensure that the
       spot generated does not 
       overlap with an existing spot
    */   
    int canvasPixelColour;
    int p;  
    for (p=0;p<circleX.length;p++) {
      canvasPixelColour = get(circleX[p],circleY[p]);
      if (canvasPixelColour != canvasBg) {
        return true; 
      }
    }
    // Concept dervived from code at
    // reference [3] 
    if (spotRadius > smallPoint) {
       spotRadius = smallPoint;
       createSpot();
       return testOverlappingSpots();
    }
    return false;
  }

  color colourGenerator(String whichColour) {
    /* Colours in JSON file dervied 
    with help from examples at references [4], [5] and [6]
    */
    int index;
    JSONArray colour;
    index = int(random(0,Palette.getJSONArray(whichColour).size()));
    colour = Palette.getJSONArray(whichColour);
    return color(unhex(colour.getString(index)));    
  }  

  color circleOrFigure() {
    /* Chooses the colour based upon
       whether we are drawing the background
       or figure
    */   
    int imgPixelColour;
    int p;
    for (p=0;p<circleX.length;p++) {
      imgPixelColour = img.get(circleX[p],circleY[p]);
      if (imgPixelColour != canvasBg) {
       return colourGenerator("bgcolour");
      }
    }
    return colourGenerator("figurecolour");
  }
      
  void drawSpot() {
    /* Draws the spot */
    fill(circleOrFigure());
    noStroke();
    ellipse(x, y, spotRadius*2, spotRadius*2);
  }
  
}
