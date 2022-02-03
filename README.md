# Processing Ishihara Plate

The following Processing sketch provide a description and method for testing for deuteranopic vision.

Deutranopia is a form of anomalous colour vision (colour-blindness) that impairs the ability of the person to distinguish red and green. It is a more common form of colour vision deficiency with around 1% of the male population being deutranopes and 5% duetranomalous. [1]
The accompanying Processing sketch renders a colour plate containing a number in various shades of red and green. This plate is based upon the Ishihara colour tests.

Dr Shinobu Ishihara of the University of Tokyo developed the tests in the early part of the 20th century. The test consists of a number of plates each containing a circle with a collection of non-overlapping spots.

These spots are divided into two groups. The first being the background coloured spots rendered in one set of colours that the patient suffers a deficiency in (for example shades of red). The second, coloured spots representing a number, rendered in another set of colours the patient has problems differentiating from the deficient colour (for example shades of green).
When the two sets of spots are combined they provide a colour blindness test where the patient attempts to discern the number located against the background.


## The colour pallet

The circle background is rendered in a range of colours loaded from the colour pallet, for example a selection of shades of red. 
The number 5 is rendered in a selection of shades of a colour a duetranope would have trouble distinguishing from the background, 
for example greens and greenish-blues.

The Processing sketch gets its colour pallets from a JSON (JavaScript Object Notation) file located in the data folder. 
The JSON file provides a simple, extensible configuration mechanism. If we wished to add a new colour pallet to the test 
we simply add it to the JSON file and the sketch will automatically pick it up.

An example of the format of the JSON is displayed below:

```javascript
{ "palettes":[
              { "id":1, "bgcolour":[ "FFFA8072", "FFFFC1C1", "FFF08080"], 
                "figurecolour":["FFEEDD82", "FF8B8970", "FFD1D6AF", "FFCDC9A5", "FF9CAA94", "FF9CAB9A"]
              } 
             ]
} 
```

Here we can see the colours are stored in hexadecimal format, which should be familiar to those who work with CSS (Cascading Style Sheets).
These colours are divided into background and figure colours (for the number 5).

## Rendering the plate

The Spot class largely handles the process of rendering the plate and is responsible for selecting colours from the chosen palette to be used on the screen.
The main sketch passes the chosen colour pallet to the Spot class as it instantiates it and then renders the new spot object to the screen.

Within this class are also the mechanisms for testing if the spot being generated overlaps with any other spots, and also if the spot generated should be either a spot drawn from the background colour set, or number colour set.
This mechanism was based upon the work done by Gregor Aisch a graphics editor at the New York Times [2].
Therefore the spot generation is essentially self-contained with loose coupling, the settings being passed to the class constructor.
The settings that the class accepts include:

1. The colour palette as already discussed
2. The background colour of the sketch
3. 
The purpose of passing the background colour to the sketch is resultant on the fact that the image the sketch
uses (a number five in a circle) is made up of both block colour (black) and transparent areas (the number).
Thus we use the background colour to determine whether the area we wish to draw a spot in is the transparent numeric value, that being the five. Based upon this we can then select the correct colour from the palette.
As mentioned it is possible to change the colour palette to provide some variety to the plates drawn. The BtnMenu class handles the palette selection.


## The menu system

A menu system has been added that allows a number of settings to be changed within the application. Like the Spot class this code is encapsulated within a separate class – BtnMenu.

The first menu the user is presented with is the horizontal footer menu. This contains two options:

1. Redraw
2.  Settings

The Redraw menu simply restarts the animation. It can be pressed at any time in order to reset the screen.
The next menu item is the Settings button. When the user clicks this, presses tab, command or control they are presented with a settings menu located on the right hand side of the screen.
Within this menu the user can change:

1. The palette
2. The frame rate
3. The number of spots

The JSON file contains four colour pallets. Typing in a number between one and four inclusive will update the sketch to use a different pallet. If the user chooses a number that is not supported, the previously selected supported pallet is used instead.
Changing the frame rate allows the user to change the speed that the Ishihara plate is rendered at. By default it is set to 100.

As the plate is rendered in the draw() function located in the main sketch its speed is thus dictated by the
frame rate, which in turn is dictated by the speed of the machine’s processor. [3]
Modifying the number of spots allows us to draw a circle with more or less detail. By default 1000 spots are rendered in the plate. Below a certain threshold not enough spots are drawn to make the plate useful. Beyond a certain threshold rendering more spots results in diminishing returns with regards to time to render and improvement in image quality visible to the user.



## References

[1] Colour Blind Awareness, (2014, November, 28). Types of Colour Blindness [Online]. Available: http://www.colourblindawareness.org/colour-blindness/types-of-colour-blindness/

[2] G. Aisch, (2011, March, 7). Generating Color Blindness Test Images with Processing [Online]. Available: http://vis4.net/blog/posts/color-blindness/

[3] Processing 2 Official website (2014, November, 28). frameRate() [Online]. Available: https://www.processing.org/reference/frameRate_.html


