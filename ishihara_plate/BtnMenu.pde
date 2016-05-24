/**

Author: Andy Dennis

File: BtnMenu

Description:
The following class is responsible for providing a 
menu system. The footer menu allows the user to restart
the animation. The side settings menu allows the user
to change the number of spots generated on the colour plate,
the frame rate and choose which colours palette to load.
  
References:

Code/ideas dervived from the following links is also anotated in
comments below.


1.) 25 LIFE-SAVING TIPS FOR PROCESSING 
https://amnonp5.wordpress.com/2012/01/28/25-life-saving-tips-for-processing/
2.) Processing.org - keyCode 
https://www.processing.org/reference/keyCode.html

**/

public class BtnMenu {
 
  int btnMenuHeight;
  int btnWidth;
  int canvasH;
  int canvasW;
  int menuColour;
  int editingSetting;
  float xTextEntry;
  float yTextEntry;
  String[] btns = {"Redraw", "Settings"};
  String[] settings = {"Palette", "Frame rate", "Num spots"};
  boolean settingVis;

  BtnMenu(int h, int w) {
    /* Button menu constructor*/
    btnMenuHeight = 55;
    btnWidth = 70;
    menuColour = 100; 
    canvasH = h;
    canvasW = w;
    editingSetting = -1;
    settingVis = false;
  }  
  
  void drawBtnMenu() {
    /* Draws the footer menu
       area on the screen
    */ 
    fill(menuColour); 
    stroke(menuColour);
    rect(0, canvasH+10, canvasW-1, btnMenuHeight-10);
    drawBtnMenuItems();
  }

  void drawBtnMenuItems(){
    /* Draws the menu buttons
       on the bottom of the screen
    */   
    int x = 100; 
    stroke(0);
    textSize(14);
    fill(0);
    
    for (int i =0; i < btns.length; i++) {
      fill(0);
      rect(x, canvasH+15, btnWidth, btnMenuHeight-20, 7);
      fill(255, 255, 255);
      text(btns[i],x+9,canvasH+38); 
      x = x + 80;
    }
  }

  void handleClick(float x, float y) {
    /* Calculates where the user has clicked
       on the screen. 
       If it is a menu button
       then the corresponding menu event is
       fired off e.g. opening the settings menu
       or redrawing the screen.
       If it is a setttings item, then the user
       can eit the setting.
    */   
    int btnX = 100;
    int btnY = 165;

    editingSetting = -1;
    if((x>0 && x <canvasW-1) && (y>canvasH)) {
        for (int i =0; i < btns.length; i++) {
          if( (x>=btnX && x<btnX+btnWidth) && 
              (y >canvasH+15 && y < (canvasH+15) +(btnMenuHeight-20))){
                fireClickFunction(i); 
              }
          btnX = btnX + 80;
        } 
    } else if((x>canvasW-180 && x <canvasW-1) &&
              (y<canvasH) && settingVis){
                loadSettingsMenu();
                for (int s =0; s < settings.length; s++) {
                  if( (x>=canvasW-180 && x<canvasW-1) && 
                      (y >btnY && y < btnY+14)){  
                        stroke(255, 0, 45);
                        noFill();
                        rect(canvasW-80, btnY, 60, 20);
                        xTextEntry = x;
                        yTextEntry = y;
                        editingSetting = s;
                   }
                   btnY = btnY + 80;
                 } 
         }
   }  
  
  void fireClickFunction(int btn){
     /* Handles the click event */
     switch(btn) {
      case 0: redrawImg(); break;
      case 1: checkIfSettingsOpen(); break;
      default: break;   
     } 
  }

  void redrawImg() {
    /* Restarts the generation of
       the Ishihara plate using the current
       settings.
    */
    currentSpot = 0;
    initalize();
  }
  
  void checkIfSettingsOpen() {
    /* Checks if the settings menu
       is open and closes it 
       if the user clicks the 
       setting button again */ 
    if(settingVis){
      settingVis = false;
      redrawImg();
    } else {
      loadSettingsMenu(); 
    }
  }
  
  void loadSettingsMenu() {
    /* Draws the settings menu
       on the right hand side
       of the screen.
    */   
    settingVis = true;
    stroke(0);
    fill(menuColour, 255); 
    rect(canvasW-200, 0, canvasW-1, canvasH+10);
    drawSettingMenuItems();
  }

  void drawSettingMenuItems(){
    /* Draws the settings menu
       and instruction text
    */   
    int y = 140; 
    stroke(0);
    smooth();
    fill(255);
    textSize(12);
    text("1.) Click on a setting\nto update it.\n2.) To save and close click\nthe settings button.",canvasW-180,20);
    text("3.) Please note, there are\n4 Palettes (1-4) to\nchoose from",canvasW-180,100);
    fill(0);
    textSize(14);

    for (int i =0; i < settings.length; i++) {
      fill(253);
      rect(canvasW-80, 25+y, 60, 20);
      fill(0);
      text(settings[i],canvasW-180,40+y);
      getSetting(y,i);
      y = y + 80;
    }
  }

  void getSetting(int y, int index) {
    /* Gets the current setting value
       and displays it on the right
    */   
    switch(index){
      case 0:  text(chosenPalette, canvasW-80, 40+y); break;
      case 1:  text(frameRateVal, canvasW-80, 40+y); break;
      case 2:  text(numSpots, canvasW-80, 40+y); break;
      default: break;
    }
  } 

  void handleText() {
    /* Handles user text input
       for updating settings
    */
    String enteredText = "";
    
    switch(editingSetting) {
      case 0:  enteredText = str(chosenPalette); break;
      case 1:  enteredText = str(frameRateVal); break;
      case 2:  enteredText = str(numSpots); break;
      default: break;
    }
    /* Handle key presses for updating variables.
       Concept dervived from refernces [1] and [2]
    */   
    if (keyCode == BACKSPACE) {
      if (enteredText.length() > 0) {
        enteredText = enteredText.substring(0, enteredText.length()-1);
      }
    } else if (keyCode == DELETE) {
      enteredText = "";
    } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT && enteredText.length() < 7) {
      enteredText = enteredText + key;
    }
    updateSettingVar(editingSetting, enteredText);
  }
  
  void updateSettingVar(int editSetting, String enteredText) {
    /* Used to choose which variable to update,
       based upon the setting the user clicked,
       with the text they have just entered
    */   
    switch(editingSetting) {
      case 0:  chosePalette(enteredText); break;
      case 1:  choseFrameRate(enteredText); break;
      case 2:  choseNumSpots(enteredText); break;
      default: break;
    } 
    loadSettingsMenu();
    handleClick(xTextEntry, yTextEntry); 
  }
  
  void chosePalette(String Palette){
     /* Updates the palette being used*/
     int p;
     try{
       p = int(Palette);
       chosenPalette = p;
     } catch (Exception e) {
       println("Should be an integer"); 
     }
  }
 
  void choseFrameRate(String rate){
     /* Updates the Frame Rate */
     int r;
     try{
       r = int(rate);
       frameRateVal = r;
     } catch (Exception e) {
       println("Should be an integer"); 
     }   
  } 

  void choseNumSpots(String noSpots){
     /* Updates the number of spots
        generated */
     int ns;
     try{
       ns = int(noSpots);
       numSpots = ns;
     } catch (Exception e) {
       println("Should be an integer"); 
     }     
  }
  
}
