/* Triangle display for the Eli Whitney Marble Wall.
 *
 * Microswitches on the triangle are wired into a keyboard.
 * Processing watches for the key presses and makes nice
 * graphics. Bars display the percent of marbles per switch.
 *
 * There are 16 microswitches on the triangle, keys:
 * 0 1 2 3 4 5 6 7 8 9 a b c d e f
 *
 * The front panel button (switch modes) will go to [space] [TODO]
 *
 * Debug mode by pressing period . [TODO]
 *
 * By Eli Baum, 2014.
 */


/*  Constants for drawing the bars  */
final int NUM_BARS = 16;

final int HZ_PAD = 64; //px, on the left and right of the screen
final int BAR_WIDTH = 32;
final int TOP_PAD = 64;
final int BOT_PAD = 32;
int BAR_HEIGHT;
int spacing;

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
  
  spacing = (width - 2 * HZ_PAD) / NUM_BARS; // between bars
}

void draw() {
  background(0);
  
  if (mode) {
    histogram();
  } else {
    /* draw stats
     * not implemented yet.
     */
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
  
  /* not implemented for now.
  else if (key == ' ') {
    // switch modes
    mode = !mode;
  }
  */
}



void histogram() {
  // Draws the histogram.
  
  pushMatrix();
  
  translate(HZ_PAD, height - BOT_PAD);
  
  for(int b = 0; b < NUM_BARS; b++) {
    noStroke();
    fill(0, 64, 128);
    
    if (totalToday > 0) {
      float p = min((float)marbles[b] / totalToday, GRAPH_UPPER);
      rect(0, 0, BAR_WIDTH, -BAR_HEIGHT * p / GRAPH_UPPER);
    }
    
    stroke(255);
    fill(0, 0); // that's transparent black, so we can see the bar underneath.
    rect(0, 0, BAR_WIDTH, -BAR_HEIGHT);

    // TODO implement percent-text labels.
  
    translate(spacing, 0); // move over to next position
  }
  
  popMatrix();
  
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
