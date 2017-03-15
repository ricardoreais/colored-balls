# Colored Lines

Colored Lines is a "Connect Four" look-a-like made with Processing. 

Original Game rules:

* Click a ball, then click an empty square to move.
* You can only move along unblocked paths.
* Build rows of 5 or more balls of one color to score.

Custom features:

* The player can choose between three board sizes (16x20, 8x10 or 4x5).
* The player can choose the number of colors (3, 6 or 9).
* The player can start the game with pre-set occupied squares, by choosing the dificulty (medium or hard).
* The player can choose Android Mode, and use a smartphone as a controller, see more info below.
* The player can choose Color Scanner, use a smartphone camera to scan real life colors (e.g. yellow banana) and use them in-game, see more info below.



![screenshot 1](https://github.com/ricardoreais/colored-lines/blob/master/examples/intro.png "Intro screen")

![screenshot 2](https://github.com/ricardoreais/colored-lines/blob/master/examples/mode1.png "Game mode 1")

[Click here for more  in-game screenshots](https://github.com/ricardoreais/colored-lines/tree/master/examples)

## Code Example

The game main engine is the shortest path selector, which determines the next position of the ball (i.e. the ball path). Checking if the path between the ball and the user click isn't blocked.

```Processing
void shortestPath(int [][] d, int r, int c, int[][] p) //Generate the shortest path possible
{
  int currentDistance = d[r][c];
  while (currentDistance >= 1)
  {
    p[r][c] = 1;
    int direction = -1; //currentDistance direction is -1
    sDistance(d, r, c); //southCell direction is 0
    nDistance(d, r, c); //northCell direction is 1
    eDistance(d, r, c); //eastCell direction is 2
    wDistance(d, r, c); //westCell direction is 3  
    for (int i = 0; i < 4; i++) //Checks the lowest distance available
      if (currentDistance > adjacent[i]  && adjacent[i] >= 0)
      {
        currentDistance = adjacent[i];
        direction = i;
      } 
    if (currentDistance != 0)
    {
      if (direction == -1) //If the lowest distance is the current, stay
        p[r][c] = 1;
      if (direction == 0) //If the lowest distance is south, move south
        p[r++][c] = 1;
      if (direction == 1) //If the lowest distance is north, move north
        p[r--][c] = 1;
      if (direction == 2) //If the lowest distance is east, move east
        p[r][c++] = 1;
      if (direction == 3) //If the lowest distance is west, move west
        p[r][c--] = 1;
    }
  }
}
```

## Getting Started
### Prerequisites

You will need to download processing version 3.x.

[Click here to download Processing](https://processing.org/download/)

To play the Android Mode or Scan color you will also need to download the android application for your Android 5.0.1 smartphone.

[Click here to download the android app](http://www.wandoujia.com/apps/com.onlylemi.android.capture)

### Opening the project

Once you have to Processing editor on the left upper corner, click on File>open...>coloredLines.pde

This will open the game project.

## Running the game

You can run the game by clicking the "Play" button on the processing IDE.

### Instructions for Android Mode & Color scan
To use your smartphone as a controller open the android capture app on your android smartphone, swipe from left to right (on the left edge of the screen), this will show you a list of settings, press Setting IP, here you will put your PC IP address (They need to be connected to the same network).

After establishing the connection, turn on the phone accelerometer and proximity sensor. Your smartphone is now ready to be used as a controller!

On the pc click on Android Mode. Now you can play by using your smartphone like a laser pointer at the computer screen. To select a ball place your thumb over the proximity sensor, like a button, then select an empty space using the same method.

For color scan, select the color recognition on the android app. Then on the computer select the Color scanner option, this will start a timer until the color is selected, grab your smartphone and point the camera at something with a nice color (e.g. yellow banana), wait for the timer and repeat again two more times, then the game will start using the colors you scanned.

```diff
+ (Working on Android 5.0.1)
- (Not working on Android 6.0)
```

## Deployment

Export the application and make an executable file. On the left upper corner, click on File>Export application...

## Built With

* [Processing 3.3](https://processing.org/download/) - The IDE used.
* [AndroidCapture](https://github.com/onlylemi/processing-android-capture) - The Processing Android library.
* [Adobe photoshop](https://www.adobe.com/pt/products/photoshop.html?promoid=KLXLS&mv=search&s_kwcid=AL!3085!3!180232924738!b!!g!!adobe%20photoshop%20gr%C3%A1tis&ef_id=WL7ZFwAAACZ40aWn:20170314164153:s) - The artwork editor.

## Authors

* **Ricardo Reais** - *Initial work* - [My profile](https://github.com/ricardoreais)

See also the list of [contributors](https://github.com/ricardoreais/colored-lines/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* Thanks to [Janbin Qi](https://github.com/onlylemi) @onlylemi for helping me with the android app. 
* Credits to the [Games for the brain version](http://www.gamesforthebrain.com/game/colorlines/)
