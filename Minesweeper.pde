import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
int NUM_ROWS = 10;
int NUM_COLS = 10;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined
int numMines = 5;
int tileCount = 0;

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  mines = new ArrayList <MSButton>();
  for (int i = 0; i<NUM_ROWS; i++) {
    for (int j = 0; j<NUM_COLS; j++)
      buttons[i][j] = new MSButton(i, j);
  }
  setMines();
  for (int i = 0; i<mines.size(); i++)
    System.out.println(mines.get(i).myRow + "," + mines.get(i).myCol);
}
public void setMines()
{
  for (int i = 0; i<numMines; i++) {
    int i1 = (int)(Math.random()*NUM_ROWS);
    int j1 = (int)(Math.random()*NUM_COLS);
    if (mines.contains(buttons[i1][j1])==false)
      mines.add(buttons[i1][j1]);
    else
      i--;
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
  for (int i = 0; i < NUM_ROWS; i++) {
    for (int j = 0; j < NUM_COLS; j++) {
      buttons[i][j].draw();
    }
  }
}
public boolean isWon()
{
  int n = 0;
  for (int i = 0; i<mines.size(); i++)
    if (mines.get(i).isFlagged())
      n++;
  if (n==numMines)
    return true;
  return false;
}
public void displayLosingMessage()
{
  text("dumdum", 200, 200);
}
public void displayWinningMessage()
{
  text("yippee", 200, 200);
}
public boolean isValid(int r, int c) {
  if (r<NUM_ROWS&&c<NUM_COLS&&r>-1&&c>-1) 
    return true; 
  return false;
}
public int countMines(int row, int col)
{
  int n = 0; 
  for (int i = 0; i<NUM_ROWS; i++) {
    for (int j = 0; j<NUM_COLS; j++) {
      if (isValid(i, j)) {
        if (row==i&&j==col) {
        } else if (i>=row-1&&i<=row+1&&j>=col-1&&j<=col+1&&mines.contains(buttons[i][j])) {
          n++;
        }
      }
    }
  }
  return n;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    if (mouseButton == RIGHT) {
      flagged = !flagged;
    } else if (mines.contains(this)&&clicked) {
      displayLosingMessage();
    }
    //} else if (countMines(myRow, myCol) > 0) {
    //  if (!clicked) {
    //    tileCount +=1;
    //  }
    //  if (tileCount == 400-mines.size()) {
    //    displayWinningMessage();
    //  }
    //  clicked = true;
    //} 
    else {

      if (!clicked) {
        tileCount+=1;
      }
      if (tileCount == 400-mines.size()) {
        displayWinningMessage();
      }
      clicked = true;
      clicked = true;
      if (isValid(myRow+1, myCol+1)&&!buttons[myRow+1][myCol+1].clicked)
        buttons[myRow+1][myCol+1].mousePressed();
      if (isValid(myRow+1, myCol)&&!buttons[myRow+1][myCol].clicked)
        buttons[myRow+1][myCol].mousePressed();
      if (isValid(myRow+1, myCol-1)&&!buttons[myRow+1][myCol-1].clicked)
        buttons[myRow+1][myCol-1].mousePressed();
      if (isValid(myRow, myCol+1)&&!buttons[myRow][myCol+1].clicked)
        buttons[myRow][myCol+1].mousePressed();
      if (isValid(myRow, myCol-1)&&!buttons[myRow][myCol-1].clicked)
        buttons[myRow][myCol-1].mousePressed();
      if (isValid(myRow-1, myCol+1)&&!buttons[myRow-1][myCol+1].clicked)
        buttons[myRow-1][myCol+1].mousePressed();
      if (isValid(myRow-1, myCol)&&!buttons[myRow-1][myCol].clicked)
        buttons[myRow-1][myCol].mousePressed();
      if (isValid(myRow-1, myCol-1)&&!buttons[myRow-1][myCol-1].clicked)
        buttons[myRow-1][myCol-1].mousePressed();
    }
  }
  public void draw () 
  {    
    if (flagged) {
      fill(255, 100, 100);
    } else if (!flagged && clicked && mines.contains(this)) {
      fill(255, 0, 0);
    } else if ( flagged && mines.contains(this) ) { 
      fill(100);
    } else if (clicked) {
      fill(200);
      this.setLabel(countMines(myRow, myCol));
      text(myLabel, x, y);
    } else {
      fill(100);
    }
    rect(x, y, width, height);
    fill(0);
    if (countMines(myRow, myCol)>0)
      text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
}
