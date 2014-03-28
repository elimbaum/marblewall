/* Triangle display for the Eli Whitney Marble Wall.
 *
 * Microswitches on the triangle are wired into a keyboard.
 * Processing watches for the key presses and makes nice
 * graphics. Bars display the percent of marbles per switch.
 *
 * There are 16 microswitches on the triangle, keys:
 * 0 1 2 3 4 5 6 7 8 9 a b c d e f
 *
 * The front panel button (switch modes) will go to [space]
 *
 * Debug mode by pressing period .
 *
 * By Eli Baum, 2014.
 */
 
 
// TODO 28 Mar: this could be done better with matrices.

/*  Constants for drawing the bars  */
final int NUM_BARS = 16;

final int HZ_PAD = 64; //px, on the left and right of the bars
final int BAR_WIDTH = 32;
final int TOP_PAD = 64;
final int BOT_PAD = 32;
int BAR_HEIGHT;

// upper limit for the graph (percent).
final float GRAPH_UPPER = 0.3;

color BAR_COLOR = color(79, 145, 187);

// histogram is true; stats is false.
boolean mode = true;

PFont helv;
int[] marbles = new int[16];
int totalToday = 0;

void setup() {
  background(0);
  helv = loadFont("Helvetica-Bold-48.vlw");
  size(800, 600);
  BAR_HEIGHT = height - TOP_PAD - BOT_PAD;
}

void draw() {
  background(0);
  
  if (mode) {
    histogram();
  } else {
    // draw stats
  }
}


void keyPressed() {
  // 0-9, a-f are the microswitch-hacked keys.
  if (key >= '0' && key <= '9') {
    marbles[key - '0']++;
    totalToday++;
  } else if (key >= 'a' && key <= 'f') {
    marbles[key - 'a' + 10]++;
    totalToday++;
  }
  
  else if (key == ' ') {
    // switch modes
    mode = !mode;
  }
}



void histogram() {
  // Draws the histogram.
  
  // Bars first.
  int i = 0;
  
  for(int x = HZ_PAD;
      x < width - HZ_PAD;
      x += (width - 2 * HZ_PAD) / NUM_BARS) {
     
    float percent = 0.0;
    
    stroke(255);
    fill(64);
    rect(x, TOP_PAD, BAR_WIDTH, BAR_HEIGHT);
    
    if(totalToday > 0) {
      noStroke();
      fill(BAR_COLOR);
      /* now draw the rectangles. min is to get the upper limit of the graph
       * truncate if it is too high. i.e. if percent is 51%, then it will
       * only draw a bar to the max.
       */
      percent = float(marbles[i])/totalToday;
      rect(x + 1, height - BOT_PAD, BAR_WIDTH - 1,
             -min(percent, GRAPH_UPPER)/GRAPH_UPPER * (BAR_HEIGHT - 1));
      i++;
    }
    
    /* draw percent text at bottom of bar.
     */
    textFont(helv, 16);
    textAlign(CENTER);
    fill(255);
    text(round(percent * 100), x + BAR_WIDTH/2,
          TOP_PAD + BAR_HEIGHT - 2);
  }
  
  // Draw the text
  fill(255);
  textAlign(CENTER, TOP);
  textFont(helv, 24);
  text("30%", HZ_PAD/2, TOP_PAD);
  
  textAlign(CENTER, BOTTOM);
  text("0%", HZ_PAD/2, height - BOT_PAD); 
  
  textFont(helv, 48);
  textAlign(CENTER);
  /* Title vertical offset is slightly arbitrary, so its not too
   * high or low. May need adjustment for different screen sizes.
   */
  text("Marble Distribution", width/2, 3*TOP_PAD/4);
  
  // Bottom counter text
  textFont(helv, 20);
  textAlign(RIGHT);
  text("Total marbles today: " + totalToday, width - 5, height - 5);
}
