#Processing Ishihara Plate

The colour pallet

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

Here we can see the colours are stored in hexadecimal format, which should be familiar to those who work with CSS (Cascading Style Sheets).
These colours are divided into background and figure colours (for the number 5).
