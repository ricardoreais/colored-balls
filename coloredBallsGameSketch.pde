// --------------------
// Colored Lines Game - Part 5 (E)
// --------------------
// Laboratório de Programação
// 19 a 26 de Maio 2016
// Autor: Ricardo Daniel Tavares Reais
// ID Mooshak: Ricardo_Reais_52333
// --------------------
// Imports
import com.onlylemi.processing.android.capture.*;
AndroidCamera ac;
AndroidSensor as;
// Window Resolution
final int myWidth = 700;
final int myHeight = 600;
// Margin
final int marginWidth = 100;
final int marginHeight = 100;
// Game Board Resolution
int myRows = 8;
int myColumns = 10;
float cellWidth = (myWidth - 2.0*marginWidth)/myColumns;
float cellHeight = (myHeight - 2.0*marginHeight)/myRows;
// Matrix
int [][] board;
int [][] distance;
int [][] path;
int [][] temporary; //Matrix for storing balls that will be deleted (5 or more Balls sequence)
// Arrays
int [] adjacent; //Stores the distances near to one position
int [] scannedColors = new int [3]; //Stores the scanned colors
int[] highscore; //Stores the biggest score of allsensorTime
int[] score = new int [1]; //Stores the current play score
String[] data; //Highscore data in the file data.txt
// Axis Points
int cell; //Ball cell
int cellX, cellY; //Ball cell coordinates
float cellCenterX, cellCenterY; //Ball cell center
int temporaryCellX, temporaryCellY; //Ball moving animation path coordinates
int previousCellColor; //Last ball clicked color
int pathSize = 0; //The amount of cells the ball will need to move to reach the final position (Ball animation)
// Colors
color windowColor;
// Controller coordinates
float x, y; //Mouse exact x and y
float sensorX = myWidth/2, sensorY = myHeight/2; //Sensor exact x and y
// Flags
boolean mouseClick; //1st mouse click is false, 2nd mouse click is true
boolean generateRandoms; //After the mouse is clicked the second sensorTime, we have permission to generate Randoms
boolean delete; //Permission to delete
boolean deleting; //We have one or more sequences on the matrix that need to be deleted (Block mouse actions)
boolean started = true; //Game launch
boolean selection; //Selection menu
boolean ended; //Game is over
boolean saved; //Only save during end screen
boolean playClassic; //Classic play mode
boolean playAndroid; //Android controller mode
boolean playScan; //Color scan mode
boolean sizeSettings; //Personalize board size
boolean colorSettings; //Personalize ball colors
boolean difficultySettings; //Personalize game difficulty
boolean medium; //Medium mode
boolean hard; //Hard mode
boolean doneColor1, doneColor2, doneColor3; //Check is colors are scanned
boolean reseted; //Check if Backspace is pressed
// Time
final int delay = 1000; //Waiting time in milliseconds
int sensorTime = millis();
int mouseClickTime = 0; //2nd mouse click time
int animationTime = 0; //Ball animation total time
int animationSpeed = 50; //Ball animation speed for each cell jump
int scanTime = 0; //Time passed since scan began
int gameStartTime = 0; //Time passed since game began
// Starting Settings
int points = 0;
int blocks = 0;
int boardThickness = 3;
String boardSize = "8x10";
String colorNumber = "6 Colors";
String difficulty = "Easy";
// Fonts
PFont openingFont;
PFont titleFont;
PFont textFont;
PFont textFontLarge;
PFont textFontXL;
PFont timerFont;
// Colors Scanned
int color1, color2, color3;
// -----------------
void settings()
{
  size(myWidth, myHeight); //Window resolution
}
// -----------------
void setup()
{  
  windowColor = white;
  modes();
  setupAndroid();
  loadFonts();
  loadScore();
}
// -----------------
void draw()
{
  background(51); //51 is dark grey
  // Update mouse values
  x = mouseX;
  y = mouseY;

  if (started)
    startScreen(); //Starting screen title
  else if (selection)
    selectionScreen(); //Selection menu screen
  if (playClassic)
  {
    if (!spaceLeft(board, 3)) //If we have no space left, end the game
      ended=true;
    gameplayScreen();
  }
  if (playAndroid)
  {
    if (!spaceLeft(board, 3)) //If we have no space left, end the game
      ended=true;
    androidScreen();
  }
  if (playScan)
    scanScreen(); //Show scanning screen
  if (sizeSettings) //Board size settings screen
    subSelectionScreen("Select the board size", "16x20", "8x10", "4x5");
  if (colorSettings) //Ball colors settings screen
    subSelectionScreen("Select the number of colors", "3", "6", "9");
  if (difficultySettings) //Difficulty settings screen
    subSelectionScreen("Select the difficulty", "Easy", "Medium", "Hard");
  if (ended) //No space left
    gameOverScreen(); //End Screen
  mouseHover(); //Mouse hover color change effect
}
// -----------------
// Loaders
void loadScore()
{
  data = loadStrings("data.txt"); //Load text file as a string
  highscore = int(split(data[0], ',')); // Convert string into an array of integers using ',' as a delimiter
}

void loadFonts()
{
  openingFont = createFont("Disolve_regular.ttf", 100);
  titleFont = createFont("Disolve_regular.ttf", 50);
  textFont = createFont("coolvetica rg.ttf", 20);
  textFontLarge = createFont("coolvetica rg.ttf", 40);
  textFontXL = createFont("coolvetica rg.ttf", 100);
  timerFont = createFont("DS-DIGI.TTF", 20);
}

void setupAndroid()
{
  as = new AndroidSensor(0);
  ac = new AndroidCamera(width, height, 20);
  as.start();
  ac.start();
}
// -----------------
// Settings
void modes()
{
  ellipseMode(CENTER);
  rectMode(CENTER);
  textAlign(CENTER, CENTER);
}

void lineSettings(color strokeColor, int strokeSize) //Change line settings
{
  stroke(strokeColor);
  strokeWeight(strokeSize);
}

void textSettings(color textColor, PFont textFont) //Change text settings
{
  textFont(textFont);
  fill(textColor); //Text Color
}

void boxSettings(boolean fill, color boxColor, boolean stroke, color strokeColor, int strokeSize, int opacity) //Change rect settings
{
  noFill();
  noStroke();
  if (fill)
    fill(boxColor, opacity);
  if (stroke)
    stroke(strokeColor);
  strokeWeight(strokeSize);
}
// -----------------
// Text
void title() //Colored game title
{
  textSettings(red, openingFont);
  text("C", 100, myHeight/2);
  textSettings(blue, openingFont);
  text("o", 125, myHeight/2);
  textSettings(lawngreen, openingFont);
  text("l", 160, myHeight/2);
  textSettings(magenta, openingFont);
  text("o", 200, myHeight/2);
  textSettings(cyan, openingFont);
  text("r", 250, myHeight/2);
  textSettings(yellow, openingFont);
  text("e", 290, myHeight/2);
  textSettings(orange, openingFont);
  text("d", 350, myHeight/2);
  textSettings(purple, openingFont);
  text(" L", 400, myHeight/2);
  textSettings(pink, openingFont);
  text("i", 460, myHeight/2);
  textSettings(cyan, openingFont);
  text("n", 500, myHeight/2);
  textSettings(red, openingFont);
  text("e", 550, myHeight/2);
  textSettings(blue, openingFont);
  text("s", 600, myHeight/2);
}

void smallTitle()
{
  textSettings(red, titleFont);
  text("C", 125, 50);
  textSettings(blue, titleFont);
  text("o", 150, 50);
  textSettings(lawngreen, titleFont);
  text("l", 175, 50);
  textSettings(magenta, titleFont);
  text("o", 200, 50);
  textSettings(cyan, titleFont);
  text("r", 225, 50);
  textSettings(yellow, titleFont);
  text("e", 250, 50);
  textSettings(orange, titleFont);
  text("d", 275, 50);
  textSettings(purple, titleFont);
  text(" L", 300, 50);
  textSettings(pink, titleFont);
  text("i", 325, 50);
  textSettings(cyan, titleFont);
  text("n", 350, 50);
  textSettings(red, titleFont);
  text("e", 375, 50);
  textSettings(blue, titleFont);
  text("s", 400, 50);
}

void timer() //Clock since game started
{
  int startedTime = millis() - gameStartTime; //Time since start in milliseconds
  int seconds = startedTime/1000 % 60; //Time since start in seconds
  int minutes = startedTime/(1000*60) % 60; //Time since start in minutes
  textSettings(white, textFont);
  text("Time:", myWidth - 75, 75);
  textSettings(white, timerFont);
  text(nf(minutes, 2, 0) + ":" + nf(seconds, 2, 0), myWidth - 30, 77); // nf(number, leftDigits, rightDigits) Changes number format
}

void points() //Points since game started (1 per ball)
{
  // HighScore
  textSettings(white, textFont);
  text("HiScore:", myWidth - 65, 25);
  textSettings(white, timerFont);
  text(highscore[0], myWidth - 20, 27);
  // Current score
  textSettings(white, textFont);
  text("Points:", myWidth - 68, 50);
  textSettings(white, timerFont);
  text(points, myWidth - 20, 52);
}
// -----------------
// Layers
void startScreen()
{
  title();
}

void selectionScreen()
{
  textSettings(white, textFontLarge);
  text("Select the mode", myWidth/2, 50);
  textSettings(white, textFont);
  boxSettings(false, 0, true, white, 3, 255);
  // Option1 Box
  rect(myWidth/4, myHeight/3, 150, 150);
  text("Play", myWidth/4, myHeight/3);
  // Option2 Box
  rect(myWidth/2, myHeight/3, 150, 150);
  text("Android Mode", myWidth/2, myHeight/3);
  // Option3 Box
  rect(3*myWidth / 4, myHeight/3, 150, 150);
  text("Color Scanner", 3*myWidth/4, myHeight/3);
  // Option4 Box
  rect(myWidth/4, (2*myHeight / 3) - 20, 150, 150);
  text("Board size", myWidth/4, (2*myHeight / 3) - 20);
  // Option5 Box
  rect(myWidth/2, (2*myHeight / 3) - 20, 150, 150);
  text("Number\nof colors", myWidth/2, (2*myHeight / 3) - 20);
  // Option6 Box
  rect(3*myWidth / 4, (2*myHeight / 3) - 20, 150, 150);
  text("Difficulty", 3*myWidth / 4, (2*myHeight / 3) - 20);
  // Current settings
  text("Settings:\n" + boardSize + "\n" + colorNumber + "\n" + difficulty, myWidth/2, myHeight - 80);
}

void subSelectionScreen(String title, String firstBox, String secondBox, String thirdBox) //Options subMenu
{
  textSettings(white, textFontLarge);
  text(title, myWidth/2, 50);
  textSettings(white, textFont);
  //Box 1
  boxSettings(false, 0, true, white, 3, 255);
  rect(myWidth/4, myHeight/2, 150, 150);
  text(firstBox, myWidth/4, myHeight/2);
  //Box 2
  rect(myWidth/2, myHeight/2, 150, 150);
  text(secondBox, myWidth/2, myHeight/2);
  //Box 3
  rect(3*myWidth / 4, myHeight/2, 150, 150);
  text(thirdBox, 3*myWidth / 4, myHeight/2);
}

void gameplayScreen()
{
  gameUI();
  if (playClassic) 
    drawCircle(myColors, cellX, cellY);
  if (playAndroid) //When playing android we need to keep track of the cell we clicked (In order to change cell and maintaining the first cell small)
    drawCircle(myColors, temporaryCellX, temporaryCellY);
  update(); //Check for something to delete
  if (millis() - gameStartTime >= animationTime) //Draw animation, gameStartTime is when the game starts, animation time counts
    pathAnimation();
  if (millis() >= mouseClickTime + delay) //Delete waiting time since last click
    delete=true; //Deletes circles if there's a sequence of 5 or more of the same color (same value) 
  else if (millis() >= mouseClickTime + pathSize*animationSpeed && generateRandoms && !deleting && !delete) //Only add 3 random balls, after the path animation has endeded and the matrix does not need to delete something
  {
    fillRandom(3); //Fill with 3 random balls from random colors if nothing was deleted this turn
    generateRandoms = false; //Not allowed to generate more randoms
  }
}

void androidScreen() //Option 2
{
  gameplayScreen(); //The controller is different but the gameplay is the same
  float proximityValue = as.getProximitySensorValues(); 
  float[] sensorCoordinates = as.getAccelerometerSensorValues();
  sensorX = -sensorCoordinates[0]*28+(myWidth/2); //Phone rotation in X axis
  sensorY = -sensorCoordinates[1]*28+(myHeight/2); //Phone rotation in Y axis
  textSettings(white, textFont);
  text("X: "+cellX+"\nY: "+cellY, myWidth - 125, 50);
  if (sensorCoordinates[0] != 0.0 && sensorX > marginWidth && sensorX < myWidth-marginWidth && sensorY > marginHeight && sensorY < myHeight-marginHeight) //If accelerometer has started && we're inside the matrix
  {
    getCellAxis(sensorX, sensorY, cellWidth, cellHeight, marginWidth, marginHeight);
    getCellCenter(cellX, cellY, cellWidth, cellHeight, marginWidth, marginHeight);
    boxSettings(false, 0, true, lawngreen, 6, 255);
    rect(cellCenterX, cellCenterY, cellWidth, cellHeight);
    proximityValue=99; //while we are controlling the cell we use proximity value is set to 99 (this way we don't press by accident)
  }
  if (millis() >= sensorTime + 1000 && proximityValue < 5) //Every 2 seconds detected sensor, if the the sensor is "pressed"
  {
    sensorTime = millis();
    sensorPressed(cellX, cellY); //Sensor pressed actions (similar to mouse click)
  }
}

void scanScreen() //Option 3
{
  int scanCountdown = (millis() - scanTime)/1000; //Time passed since scan started (in seconds)
  int currentColor = ac.getColor(); //Get current camera color
  int countdown = 10; //Start from 10 until 0
  // Current Color
  boxSettings(true, currentColor, false, 0, 6, 255);
  rect(myWidth/2, myHeight/3, 150, 150);
  textSettings(white, textFont);
  text("Color Being Captured", myWidth/2, myHeight/3 + 83);
  //Color One
  if (doneColor1)
    boxSettings(true, color1, true, lawngreen, 6, 255); //If color is already scanned turn from red to green
  else
    boxSettings(true, color1, true, red, 6, 255);
  rect(myWidth/4, (2*myHeight / 3) - 20, 150, 150);
  textSettings(white, textFont);
  text("Color 1", myWidth/4, (2*myHeight / 3) + 70);
  //Color Two
  if (doneColor2)
    boxSettings(true, color2, true, lawngreen, 6, 255);
  else
    boxSettings(true, color2, true, red, 6, 255);
  rect(myWidth/2, (2*myHeight / 3) - 20, 150, 150);
  textSettings(white, textFont);
  text("Color 2", myWidth/2, (2*myHeight / 3) + 70);
  //Color Three
  if (doneColor3)
    boxSettings(true, color3, true, lawngreen, 6, 255);
  else
    boxSettings(true, color3, true, red, 6, 255);
  rect(3*myWidth / 4, (2*myHeight / 3) - 20, 150, 150);
  textSettings(white, textFont);
  text("Color 3", 3*myWidth / 4, (2*myHeight / 3) + 70);
  textSettings(white, textFontLarge);
  if (scanCountdown < 10) //1st Step, preparing to scan colors
  {
    countdown -= scanCountdown;
    text("Get ready to scan...\n" + countdown, myWidth/2, 45);
  }
  if (scanCountdown < 15 && scanCountdown >= 10) //2nd Step, scan the first color
  {
    countdown = 15 - scanCountdown;
    color1 = currentColor;
    doneColor1 = true;
    text("Scanning color one...\n" + countdown, myWidth/2, 45);
  }
  if (scanCountdown < 20 && scanCountdown >= 15) //3rd Step, scan the second color
  {
    countdown = 20 - scanCountdown;
    color2 = currentColor;
    doneColor2 = true;
    text("Scanning color two...\n" + countdown, myWidth/2, 45);
  }
  if (scanCountdown < 25 && scanCountdown >= 20) //4th Step, scan the third color
  {
    countdown = 25 - scanCountdown;
    color3 = currentColor;
    doneColor3 = true;
    text("Scanning color three...\n" + countdown, myWidth/2, 45);
  }
  if (scanCountdown < 30 && scanCountdown >= 25) //5th Step, saving the scanned colors
  {
    text("Finished Scanning", myWidth/2, 50);
    scannedColors[0] = color1;
    scannedColors[1] = color2;
    scannedColors[2] = color3;
    myColors = scannedColors;
  }
  if (scanCountdown >= 30) //6th Step, start the game with the scanned colors
  {
    gameSetup(); //Load game settings
    playScan = false; //Stop the scanning
    gameStartTime = millis();
    selection = false;
    playClassic = true;
  }
}

void gameOverScreen()
{
  playClassic = false; //Stop playing
  playAndroid = false; //Stop playing
  drawBoard();
  drawBlocks();
  drawCircle(myColors, cellX, cellY);
  smallTitle();
  points();
  saveHighScore();
  textSettings(white, textFont);
  text("Press backspace to Restart", myWidth/4 + 45, myHeight - 75);
  textSettings(black, textFontXL);
  text("Game Over", myWidth/2, myHeight/2 - 20);
}
// -----------------
// Game User Interface
void scoreBoard()
{
  points();
  timer();
}

void gameUI()
{
  drawBoard();
  drawBlocks(); //Draw occupied cells with blocks
  smallTitle();
  scoreBoard(); //ScoreBoard & Timer
  textSettings(white, textFont);
  text("Press backspace to Restart", myWidth/4 + 45, myHeight - 75);
}
// -----------------
// Draws
void drawBoard()
{
  lineSettings(white, boardThickness);  
  for (int i = 0; i <= myColumns; i++)
    line(i*cellWidth + marginWidth, marginHeight, i*cellWidth + marginWidth, myRows*cellHeight + marginHeight);
  for (int i = 0; i <= myRows; i++)
    line(marginWidth, i*cellHeight + marginHeight, myColumns*cellWidth + marginWidth, i*cellHeight + marginHeight);
}

void drawCircle(int[] colors, int cellX, int cellY) //Draw game balls if the color is not 0 (black)
{
  noStroke();
  for (int i = 0; i < myRows; i++)
    for (int j = 0; j < myColumns; j++)
      if (board[i][j] > 0 && board[i][j] != 404) //The value 404 means it's a block, not a ball
      {
        fill(colors[board[i][j] - 1]);
        getCellCenter(j, i, cellWidth, cellHeight, marginWidth, marginHeight); //Gets the exact cell center position
        if (i == cellY && j == cellX && mouseClick)
          ellipse(cellCenterX, cellCenterY, cellWidth*0.75 - boardThickness, cellHeight*0.75 - boardThickness);//polygon(cellCenterX, cellCenterY, cellWidth*0.75-20, 8);
        else
          ellipse(cellCenterX, cellCenterY, cellWidth - boardThickness, cellHeight - boardThickness);//polygon(cellCenterX, cellCenterY, cellWidth-26, 8);
      }
}

void drawBlocks()
{
  boxSettings(true, white, false, 0, 0, 255);
  for (int i = 0; i < myRows; i++)
    for (int j = 0; j < myColumns; j++)
      if (board[i][j] == 404)
      {
        getCellCenter(j, i, cellWidth, cellHeight, marginWidth, marginHeight); //Gets the exact cell center position
        rect(cellCenterX, cellCenterY, cellWidth, cellHeight);
      }
}
// -----------------
// Game Engine
int getCell(float x, float y, float w, float h, int c, int marginWidth, int marginHeight) //getCell version2, recognizes a margin
{
  int x0 = int((x-marginWidth) / w);
  int y0 = int((y-marginHeight) / h);
  cell = y0*c + x0;
  return cell;
}

void getCellAxis(float x, float y, float w, float h, int marginWidth, int marginHeight) //Obtains the matrix coordinates of a cell
{
  cellX = int((x-marginWidth) / w);
  cellY = int((y-marginHeight) / h);
}

void getCellCenter(float x, float y, float w, float h, int marginWidth, int marginHeight) //Obtains the exact center values of a cell
{
  cellCenterX = x*w + marginWidth + w/2.0;
  cellCenterY = y*h + marginHeight + h/2.0;
}

void gameSetup() //Loads the game
{
  board = new int[myRows][myColumns];
  distance = new int[myRows][myColumns]; //Matrix with the distance values (-1 means inaccessible)
  path = new int [myRows][myColumns];
  temporary = new int[myRows][myColumns]; // Matrix for storing balls that will be deleted (5 or more Balls sequence)
  adjacent = new int [4]; //Stores the distances near to one position
  matrixSetup(distance, -1); //Fills the matrix with the value -1
  // Fill board
  fillRandom(3); //Gameplay the board with 3 random balls
  fillRandomBlocks(blocks); //Fill board with blocks, if the difficulty is medium or hard
}

void saveHighScore()
{
  if (points > highscore[0] && !saved) //If the final game score is bigger than the High score, and is not saved yet
  {
    score[0] = points;
    String[] s = str(score);
    saveStrings("data.txt", s); //Save new score to data.txt file
    saved = true; //Is saved
  }
}

void valueSwitcher(int[][] m, int rows, int columns, int n, int newX, int r, int c, int dv, int dh) //Deletes a sequence of same color pieces
{ 
  while (r >= 0 && c >= 0 && r <= rows - 1 && c <= columns - 1 && n > 0) //If we are inside the game board and the color hasn't changed
  {
    m[r][c] = newX; //Switches value in the current position 
    r += dv; //Moves vertically again
    c += dh; //Moves horizontally again
    n--;
  }
}

void update()
{
  int countS, countE, countSE, countNE; //Counts a sequence of same color pieces in every direction (needed)
  matrixSetup(temporary, 0); //Reset the temporary matrix
  for (int i = 0; i < myRows; i++)
    for (int j = 0; j < myColumns; j++)
      if (previousCellColor != 0)
      {
        //Note: we only verify 4 directions because, when we verify cell (0,0) east we are also verifying cell (5,0) west
        countS = countWhile(board, myRows, myColumns, previousCellColor, i, j, 1, 0); //SOUTH
        countE = countWhile(board, myRows, myColumns, previousCellColor, i, j, 0, 1); //EAST
        countSE = countWhile(board, myRows, myColumns, previousCellColor, i, j, 1, 1); //SOUTH EAST 
        countNE = countWhile(board, myRows, myColumns, previousCellColor, i, j, -1, 1); //NORTH EAST
        if (countS > 4)  //Vertical line
          valueSwitcher(temporary, myRows, myColumns, countS, 1, i, j, 1, 0); //We have to add 1
        if (countE > 4) //Diagonal line
          valueSwitcher(temporary, myRows, myColumns, countE, 1, i, j, 0, 1);
        if (countSE > 4)  //Vertical line
          valueSwitcher(temporary, myRows, myColumns, countSE, 1, i, j, 1, 1); 
        if (countNE > 4) //Diagonal line
          valueSwitcher(temporary, myRows, myColumns, countNE, 1, i, j, -1, 1);
      }
  if (delete) //If we have permission to delete (Delay time may change this permission)
    deleteMatrix();
  deleting = isDeleting(); //Check if something needs to be deleted, Note: something may need to be deleted and we don't have permission to delete it (yet)
}

boolean isDeleting() //In the temporary matrix, each cell with the value 1 belongs to a sequence, so if we have a sequence something needs to be deleted
{
  boolean result=false;
  for (int i = 0; i < myRows; i++)
    for (int j = 0; j < myColumns; j++)
      if (temporary[i][j] == 1)
        result = true;     
  return result;
}

void deleteMatrix() //In the temporary matrix, each cell with the value 1 is deleted, because it belongs to a sequence
{
  for (int i = 0; i < myRows; i++)
    for (int j = 0; j < myColumns; j++)
      if (temporary[i][j] == 1)
      {
        points++;
        board[i][j] = 0;
      }
}

void matrixSetup(int[][] m, int x) //gameplays up a matrix with the value x in every position
{
  for (int i = 0; i < myRows; i++)
    for (int j = 0; j < myColumns; j++)
      m[i][j] = x;
}

int countWhile(int[][] m, int rows, int columns, int x, int r, int c, int dv, int dh) //Counts while the color doesn't change in one direction
{
  int result = 0;
  while (r >= 0 && c >= 0 && r <= rows - 1 && c <= columns - 1 && m[r][c] == x && m[r][c]!=404) //If we are inside the game board and the color hasn't changed
  {
    result++; //Confirms another same color piece on the board
    r += dv; //Moves vertically again
    c += dh; //Mover horizontally again
  }
  return result;
}

void pathAnimation() //Creates the illusion of a moving ball (ball jumps from cell to cell at a certain animationSpeed)
{
  animationTime += animationSpeed; //Each cell movement adds to the animationTime
  sPath(path, temporaryCellY, temporaryCellX); //Begin to check if we have adjacent path
}

void distances(int[][] m, int rows, int columns, int r, int c, int[][] d) //Generate all distances, gameplaying from the cell [r][c]
{
  d[r][c] = 0; //Clicked position is the gameplay
  int x = 0; //Distance gameplays at zero
  int loop = 0;
  while (loop < rows*columns) //(Optimize)
  {   
    for (int i = 0; i < rows; i++)
      for (int j = 0; j < columns; j++)
        if (d[i][j] == x) //Calculate the distance to (r,c)
        {
          S(m, d, i, j, x);
          N(m, d, i, j, x);
          E(m, d, i, j, x);
          W(m, d, i, j, x);
        }
    loop++;
    x++; //Next distance
  }
}

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

boolean spaceLeft(int[][] m, int x) //Checks if the board has x or more spaces left
{
  int emptySpaces = 0;
  boolean result = false;
  for (int i = 0; i < myRows; i++)
    for (int j = 0; j < myColumns; j++)
      if (m[i][j] == 0)
        emptySpaces++;
  if (emptySpaces > x)
    result = true;
  return result;
}

int cellsAmount(int[][] m, int x) //Obtains the number of cells with the value x on the matrix m
{
  int result = 0;
  for (int i = 0; i < myRows; i++)
    for (int j = 0; j < myColumns; j++)
      if (m[i][j] == x)
        result++;
  return result;
}

int[] emptyCellsPositions() //Obtains the cell number of the empty cells
{
  int[] result = new int[cellsAmount(board, 0)];
  int result2 = 0;
  for (int i = 0; i < myRows; i++)
    for (int j = 0; j < myColumns; j++)
      if (board[i][j] == 0)
        result[result2++] = i*myColumns + j;
  return result;
}
// -----------------
// Random Generators
void ints_exchange(int[] a, int x, int y)
{
  int m = a[x];
  a[x] = a[y];
  a[y] = m;
}

void ints_shuffle(int[] a) //Knuth algoritm to shuffle arrays without duplicates
{
  int n = a.length;
  for (int i = 0; i < n-1; i++)
    ints_exchange(a, i, i+int(random(n-1-i)));
}

int[] randomEmptyCells(int n) //Returns n random empty cells numbers (positions)
{
  int[] emptyCells = emptyCellsPositions();
  int[] rEmptyCells = new int[n]; 
  ints_shuffle(emptyCells); //Shuffles the emptyCells array (no duplicates)
  for (int i = 0; i < n; i++)
    rEmptyCells[i] = emptyCells[i];
  return rEmptyCells;
}

int[] randomColors(int n) //Returns n random colors index (positions)
{
  int[] rColors = new int [n];
  for (int i = 0; i < n; i++)
  {
    int rIndex = int(random(myColors.length) + 1); //we add 1 to the color index because, 0 means no color (empty cell), Note:Subtracted later in the myColors array, to obtain the position 0
    rColors[i] = rIndex;
  }
  return rColors;
}

void fillRandom(int n) //Fill n cells, with n random colors
{
  int[] rPositions = randomEmptyCells(n);
  int[] rColors = randomColors(n);
  int k = 0;
  while (k < n)
  {
    for (int i = 0; i < myRows; i++)
      for (int j = 0; j < myColumns; j++)
        if (i*myColumns + j == rPositions[k])
          board[i][j] = rColors[k];
    k++;
  }
}

void fillRandomBlocks(int n) //Fill n cells, with n random colors
{
  int[] rPositions = randomEmptyCells(n);
  int k = 0;
  while (k < n)
  {
    for (int i = 0; i < myRows; i++)
      for (int j = 0; j < myColumns; j++)
        if (i*myColumns + j == rPositions[k])
          board[i][j] = 404;
    k++;
  }
}
// -----------------
// Cardinal Points (North, South, East, West)
// Generate adjacent distances
void S(int[][] m, int[][] d, int i, int j, int x) //SOUTH
{
  if (i < myRows-1 && d[i+1][j] == -1 && m[i+1][j] == 0) //If we are inside the matrix && the value is an empty position && the empty position does not have one ball
    d[i+1][j]=x+1;
}
void N(int[][] m, int[][] d, int i, int j, int x) //NORTH
{
  if (i > 0 && d[i-1][j] == -1 && m[i-1][j] == 0)
    d[i-1][j] = x+1;
}
void E(int[][] m, int[][] d, int i, int j, int x) //EAST
{
  if (j < myColumns-1 && d[i][j+1] == -1 && m[i][j+1] == 0)
    d[i][j+1] = x+1;
}
void W(int[][] m, int[][] d, int i, int j, int x) //WEST
{
  if (j > 0 && d[i][j-1] == -1 && m[i][j-1] == 0)
    d[i][j-1] = x+1;
}
// Adjacent distances
void sDistance(int[][] d, int i, int j) //SOUTH
{
  if (i < myRows-1) //If we are inside the matrix
    adjacent[0] = d[i+1][j];
  else
    adjacent[0] = 9999; //Outside the matrix the distance is the "infinity"
}
void nDistance(int[][] d, int i, int j) //NORTH
{
  if (i > 0)
    adjacent[1] = d[i-1][j];
  else
    adjacent[1] = 9999;
}
void eDistance(int[][] d, int i, int j) //EAST
{
  if (j < myColumns-1)
    adjacent[2] = d[i][j+1];
  else
    adjacent[2] = 9999;
}
void wDistance(int[][] d, int i, int j) //WEST
{
  if (j > 0)
    adjacent[3] = d[i][j-1];
  else
    adjacent[3] = 9999;
}
// Adjacent path
void sPath(int[][] m, int i, int j) //Checks if we have path to move SOUTH
{
  if (i < myRows-1 && m[i+1][j] == 1) //If we are inside the matrix && the value is an empty position && the empty position does not have one ball
  {
    board[i][j] = 0; //To create the animation, the cell behind must disappear
    m[i+1][j] = 0; //We have no path in the current position
    temporaryCellY++; //Move south
    board[temporaryCellY][temporaryCellX] = previousCellColor;//Place a cell south
  }
  else
    nPath(path, temporaryCellY, temporaryCellX); //Can't move south try north
}
void nPath(int[][] m, int i, int j) //Checks if we have path to move NORTH
{
  if (i > 0 && m[i-1][j] == 1)
  {
    board[i][j] = 0;
    m[i-1][j] = 0;
    temporaryCellY--;
    board[temporaryCellY][temporaryCellX] = previousCellColor;
  }
  else
    ePath(path, temporaryCellY, temporaryCellX); //Can't move south try east
}
void ePath(int[][] m, int i, int j) //Checks if we have path to move EAST
{
  if (j < myColumns-1 && m[i][j+1] == 1)
  {
    board[i][j] = 0;
    m[i][j+1] = 0;
    temporaryCellX++;
    board[temporaryCellY][temporaryCellX] = previousCellColor;
  }
  else
    wPath(path, temporaryCellY, temporaryCellX); //Can't move south try west
}
void wPath(int[][] m, int i, int j) //Checks if we have path to move WEST
{
  if (j > 0 && m[i][j-1] == 1)
  {
    board[i][j] = 0;
    m[i][j-1] = 0;  
    temporaryCellX--;
    board[temporaryCellY][temporaryCellX] = previousCellColor;
  }
}
// -----------------
// Action Events
void mouseHover()
{
  if (selection)
  {
    if (x > myWidth/4 - 75 && x < myWidth/4 + 75 && y > myHeight/3 - 75 && y < myHeight/3 + 75) //playClassic
    {
      boxSettings(false, 0, true, lawngreen, 6, 255);
      rect(myWidth/4, myHeight/3, 150, 150);
    }
    else if (x > myWidth/2 - 75 && x < myWidth/2 + 75 && y > myHeight/3 - 75 && y < myHeight/3 + 75) //playAndroid
    {
      boxSettings(false, 0, true, red, 6, 255);
      rect(myWidth/2, myHeight/3, 150, 150);
    }
    else if (x > (3*myWidth)/4 - 75 && x < (3*myWidth)/4 + 75 && y > myHeight/3 - 75 && y < myHeight/3 + 75) //playScan
    {
      boxSettings(false, 0, true, cyan, 6, 255);
      rect(3*myWidth/4, myHeight/3, 150, 150);
    }
    else if (x > myWidth/4 - 75 && x < myWidth/4 + 75 && y > 2*myHeight/3 - 95 && y < 2*myHeight/3 + 55) //sizeSettings
    {
      boxSettings(false, 0, true, blue, 6, 255);
      rect(myWidth/4, 2*myHeight/3 - 20, 150, 150);
    }
    else if (x > myWidth/2 - 75 && x < myWidth/2 + 75 && y > 2*myHeight/3 - 95 && y < 2*myHeight/3 + 55) //colorSettings
    {
      boxSettings(false, 0, true, magenta, 6, 255);
      rect(myWidth/2, 2*myHeight/3 - 20, 150, 150);
    }
    else if (x > (3*myWidth)/4 - 75 && x < (3*myWidth)/4 + 75 && y > 2*myHeight/3 - 95 && y < 2*myHeight/3 + 55) //difficultySettings
    {
      boxSettings(false, 0, true, yellow, 6, 255);
      rect(3*myWidth/4, 2*myHeight/3 - 20, 150, 150);
    }
  }
  else if (sizeSettings)
    subMenuHover();
  else if (colorSettings)
    subMenuHover();
  else if (difficultySettings)
    subMenuHover();
}

void subMenuHover()
{
  if (x > myWidth/4 - 75 && x < myWidth/4 + 75 && y > myHeight/2 - 75 && y < myHeight/2 + 75) //Option 4, 1st Box
  {
    boxSettings(false, 0, true, lawngreen, 6, 255);
    rect(myWidth/4, myHeight/2, 150, 150);
  }
  else if (x > myWidth/2 - 75 && x < myWidth/2 + 75 && y > myHeight/2 - 75 && y < myHeight/2 + 75) //Option 4, 2nd Box
  {
    boxSettings(false, 0, true, blue, 6, 255);
    rect(myWidth/2, myHeight/2, 150, 150);
  }
  else if (x > (3*myWidth)/4 - 75 && x < (3*myWidth)/4 + 75 && y > myHeight/2 - 75 && y < myHeight/2 + 75) //Option 4, 3rd Box
  {
    boxSettings(false, 0, true, red, 6, 255);
    rect(3*myWidth/4, myHeight/2, 150, 150);
  }
}

void keyPressed() 
{
  if (keyCode  == BACKSPACE) //Restart key
  {
    ended = false;
    playClassic = false;
    playAndroid = false;
    playScan = false;
    sizeSettings = false;
    colorSettings = false;
    difficultySettings = false;
    doneColor1 = false;
    doneColor2 = false;
    doneColor3 = false;
    color1 = 0;
    color2 = 0;
    color3 = 0;
    saved = false;
    animationTime = 0;
    temporaryCellX = 0;
    temporaryCellY = 0;
    points = 0;
    loadScore();
    reseted=true;
    selection=true;
  }
}

void sensorPressed(int x, int y)
{
  if (millis() >= mouseClickTime + pathSize*animationSpeed && playAndroid && !selection) //Checks if the mouse is not clicking the margin && nothing needs to be deleted
  {  
    if (mouseClick && (distance[y][x] == 0 || board[y][x] == 404)) //If the second click is in the same ball, we get to choose another ball (Reset)
    { 
      mouseClick = !mouseClick; //Go back to ball selection (1st click)
      matrixSetup(distance, -1); //Reset the distances, because a new ball has new distances
    } 
    else if (mouseClick && distance[y][x] > 0) //Second click, delete last position, fill the new position and generate randoms
    {
      mouseClickTime = millis(); //2nd mouse click time
      shortestPath(distance, y, x, path); //Generate path
      pathSize = cellsAmount(path, 1); //Check the size of the path (to calculate animation time)
      delete = false; //We don't want to delete a sequence right after the click 
      generateRandoms = true; //Permission to generate randoms (unless we have a sequence, has refered in line 87)
      matrixSetup(distance, -1); //Resets the distance matrix
      mouseClick = !mouseClick; //Switch to 1st click
    } 
    else if (mouseClick && board[y][x] > 0 && board[y][x] != 404) //Second click, on another ball
    {
      matrixSetup(distance, -1); //Resets the distance matrix
      //gameplays from the beggining, but with the new ball
      distances(board, myRows, myColumns, y, x, distance);
      matrixSetup(path, 0);
      temporaryCellX = x;
      temporaryCellY = y;
      previousCellColor = board[y][x];
    }
    //First click, saves the position clicked, to use later on the second click
    else if (!mouseClick && board[y][x] > 0 && board[y][x] != 404) //The else if is used, so that the mousePressed function only activates one of the clicks
    {
      distances(board, myRows, myColumns, y, x, distance); //Generates the distances from the clicked cell
      matrixSetup(path, 0);
      temporaryCellX = x;
      temporaryCellY = y; //OPTIMIZE
      previousCellColor = board[y][x]; //OPTIMIZE
      mouseClick = !mouseClick; //Switch to 2nd click
    }
  }
}  

void mousePressed()
{
  x = mouseX;
  y = mouseY;

  if (x > marginWidth && x < myWidth-marginWidth && y > marginHeight && y < myHeight-marginHeight && !deleting && millis() >= mouseClickTime + pathSize*animationSpeed && playClassic && !selection) //Checks if the mouse is not clicking the margin && nothing needs to be deleted
  {  
    getCellAxis(x, y, cellWidth, cellHeight, marginWidth, marginHeight); //Gets cell coordinates

    if (mouseClick && (distance[cellY][cellX] == 0 || board[cellY][cellX] == 404)) //If the second click is in the same ball, we get to choose another ball (Reset)
    { 
      mouseClick = !mouseClick; //Go back to ball selection (1st click)
      matrixSetup(distance, -1); //Reset the distances, because a new ball has new distances
    }
    else if (mouseClick && distance[cellY][cellX] > 0) //Second click, delete last position, fill the new position and generate randoms
    {
      mouseClickTime = millis(); //2nd mouse click time
      shortestPath(distance, cellY, cellX, path); //Generate path
      pathSize = cellsAmount(path, 1); //Check the size of the path (to calculate animation time)
      delete = false; //We don't want to delete a sequence right after the click 
      generateRandoms = true; //Permission to generate randoms (unless we have a sequence, has refered in line 87)
      matrixSetup(distance, -1); //Resets the distance matrix
      mouseClick = !mouseClick; //Switch to 1st click
    }
    else if (mouseClick && board[cellY][cellX] > 0 && board[cellY][cellX] != 404) //Second click, on another ball
    {
      matrixSetup(distance, -1); //Resets the distance matrix
      //gameplays from the beggining, but with the new ball
      distances(board, myRows, myColumns, cellY, cellX, distance);
      matrixSetup(path, 0);
      temporaryCellX = cellX;
      temporaryCellY = cellY;
      previousCellColor = board[cellY][cellX];
    }
    //First click, saves the position clicked, to use later on the second click
    else if (!mouseClick && board[cellY][cellX] > 0 && board[cellY][cellX] != 404) //The else if is used, so that the mousePressed function only activates one of the clicks
    {
      distances(board, myRows, myColumns, cellY, cellX, distance); //Generates the distances from the clicked cell
      matrixSetup(path, 0);
      temporaryCellX = cellX;
      temporaryCellY = cellY; //OPTIMIZE
      previousCellColor = board[cellY][cellX]; //OPTIMIZE
      mouseClick = !mouseClick; //Switch to 2nd click
    }
  }
  settingsPressed();
}

void settingsPressed()
{
  if (started)
  {
    started = false;
    selection = true;
  }
  else if (selection)
  {
    if (x > myWidth/4 - 75 && x < myWidth/4 + 75 && y > myHeight/3 - 75 && y < myHeight/3 + 75) //playClassic
    {
      gameStartTime = millis();
      gameSetup();
      selection = false;
      playClassic = true;
    }
    else if (x > myWidth/2 - 75 && x < myWidth/2 + 75 && y > myHeight/3 - 75 && y < myHeight/3 + 75) //playAndroid
    {
      gameStartTime = millis();
      gameSetup();
      selection = false;
      playAndroid = true;
    }
    else if (x > (3*myWidth)/4 - 75 && x < (3*myWidth)/4 + 75 && y > myHeight/3 - 75 && y < myHeight/3 + 75) //playScan
    {
      scanTime = millis();
      selection = false;
      playScan = true;
    }
    else if (x > myWidth/4 - 75 && x < myWidth/4 + 75 && y > 2*myHeight/3 - 95 && y < 2*myHeight/3 + 55) //sizeSettings
    {
      selection = false;
      sizeSettings = true;
    }
    else if (x > myWidth/2 - 75 && x < myWidth/2 + 75 && y > 2*myHeight/3 - 95 && y < 2*myHeight/3 + 55) //colorSettings
    {
      selection = false;
      colorSettings = true;
    }
    else if (x > (3*myWidth)/4 - 75 && x < (3*myWidth)/4 + 75 && y > 2*myHeight/3 - 95 && y < 2*myHeight/3 + 55) //difficultySettings
    {
      selection = false;
      difficultySettings = true;
    }
  }
  else if (sizeSettings)
    sizeSettings();
  else if (colorSettings)
    colorSettings();
  else if (difficultySettings)
    difficultySettings();
}

void sizeSettings()
{
  if (x > myWidth/4 - 75 && x < myWidth/4 + 75 && y > myHeight/2 - 75 && y < myHeight/2 + 75) //Option 4, 1st Box
  {
    sizeSettings=false;
    selection=true;
    myRows=16;
    myColumns=20;
    cellWidth = (myWidth - 2.0*marginWidth)/myColumns;
    cellHeight = (myHeight - 2.0*marginHeight)/myRows;
    if (medium)
      blocks= int(myColumns*myRows * 0.10);
    if (hard)
      blocks= int(myColumns*myRows * 0.20);
    boardSize="16x20";
  } else if (x > myWidth/2 - 75 && x < myWidth/2 + 75 && y > myHeight/2 - 75 && y < myHeight/2 + 75) //Option 4, 2nd Box
  {
    sizeSettings=false;
    selection=true;
    myRows=8;
    myColumns=10;
    cellWidth = (myWidth - 2.0*marginWidth)/myColumns;
    cellHeight = (myHeight - 2.0*marginHeight)/myRows;
    if (medium)
      blocks= int(myColumns*myRows * 0.10);
    if (hard)
      blocks= int(myColumns*myRows * 0.20);
    boardSize="8x10";
  } else if (x > (3*myWidth)/4 - 75 && x < (3*myWidth)/4 + 75 && y > myHeight/2 - 75 && y < myHeight/2 + 75) //Option 4, 3rd Box
  {
    sizeSettings=false;
    selection=true;
    myRows=4;
    myColumns=5;
    cellWidth = (myWidth - 2.0*marginWidth)/myColumns;
    cellHeight = (myHeight - 2.0*marginHeight)/myRows;
    if (medium)
      blocks= int(myColumns*myRows * 0.10);
    if (hard)
      blocks= int(myColumns*myRows * 0.20);
    boardSize="4x5";
  }
}

void colorSettings()
{
  if (x > myWidth/4 - 75 && x < myWidth/4 + 75 && y > myHeight/2 - 75 && y < myHeight/2 + 75) //Option 5, 1st Box
  {
    colorSettings = false;
    selection = true;
    myColors = myColors3;
    colorNumber = "3 Colors";
  }
  else if (x > myWidth/2 - 75 && x < myWidth/2 + 75 && y > myHeight/2 - 75 && y < myHeight/2 + 75) //Option 5, 2nd Box
  {
    colorSettings = false;
    selection = true;
    myColors = myColors6;
    colorNumber = "6 Colors";
  }
  else if (x > (3*myWidth)/4 - 75 && x < (3*myWidth)/4 + 75 && y > myHeight/2 - 75 && y < myHeight/2 + 75) //Option 5, 3rd Box
  {
    colorSettings = false;
    selection = true;
    myColors = myColors9;
    colorNumber = "9 Colors";
  }
}

void difficultySettings()
{
  if (x > myWidth/4 - 75 && x < myWidth/4 + 75 && y > myHeight/2 - 75 && y < myHeight/2 + 75) //Option 6, 1st Box
  {
    difficultySettings = false;
    selection = true;
    blocks = 0;
    difficulty = "Easy";
  }
  else if (x > myWidth/2 - 75 && x < myWidth/2 + 75 && y > myHeight/2 - 75 && y < myHeight/2 + 75) //Option 6, 2nd Box
  {
    medium = true;
    hard = false;
    difficultySettings = false;
    selection = true;
    blocks = int(myColumns*myRows * 0.10); //10% of the blocks are locked
    difficulty = "Medium";
  }
  else if (x > (3*myWidth)/4 - 75 && x < (3*myWidth)/4 + 75 && y > myHeight/2 - 75 && y < myHeight/2 + 75) //Option 6, 3rd Box
  {
    medium = false;
    hard = true;
    difficultySettings = false;
    selection = true;
    blocks = int(myColumns*myRows * 0.20);
    difficulty = "Hard";
  }
}