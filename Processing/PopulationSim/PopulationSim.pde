Population test;
int counter;
int popMode = 0;
int NUM_MODES = 8;

color CHILDREN_COLOR = #FF0000;
color ADULT_COLOR = #00FF00;
color SENIOR_COLOR = #FFAF00;
color NATIVE_COLOR = #FFFFFF;
color GEN1_COLOR = #999999;
color NON_NATIVE_COLOR = #ED6EE5;
color SHARED_CAR_COLOR = #8F99FC;

int SCALER_W = 5;
float SCALER_H;

float BIRTH_RATE;
int MAX_AGE;
int POP_INIT;
float IMMIGRATION; //percent of POP_INIT
float friendlyImmigration;
//int FRIENDLY_POP = 127110000; // Japanese population (2013)
int FRIENDLY_POP; // American population (2013)

void setup() {
  size(1050, 900);
  reInit(popMode);
}

void reInit(int mode) {
  
  switch(mode) {
    case 0:
      BIRTH_RATE = 1.41;
      MAX_AGE = 80;
      POP_INIT = 10000;
      IMMIGRATION = 0.008; //percent of POP_INIT
      FRIENDLY_POP = 127110000; // American population (2013)
      SCALER_H = 0.03;
      break;
    case 1:
      BIRTH_RATE = 2.0;
      MAX_AGE = 80;
      POP_INIT = 10000;
      IMMIGRATION = 0.0; //percent of POP_INIT
      FRIENDLY_POP = 127110000; // American population (2013)
      SCALER_H = 0.015;
      break;
    case 2:
      BIRTH_RATE = 1.41;
      MAX_AGE = 80;
      POP_INIT = 10000;
      IMMIGRATION = 0.31; //percent of POP_INIT
      FRIENDLY_POP = 127110000; // American population (2013)
      SCALER_H = 0.03;
      break;
    case 3:
      BIRTH_RATE = 1.88;
      MAX_AGE = 75;
      POP_INIT = 10000;
      IMMIGRATION = 0.65; //percent of POP_INIT
      FRIENDLY_POP = 316500000; // American population (2013)
      SCALER_H = 0.01;
      break;
    case 4: // Status-Quo Japan
      BIRTH_RATE = 1.41;
      MAX_AGE = 80;
      POP_INIT = 10000;
      IMMIGRATION = 0.0; //percent of POP_INIT
      FRIENDLY_POP = 127110000; // American population (2013)
      SCALER_H = 0.03;
      break;
    case 5: // Group A
      BIRTH_RATE = 1.41;
      MAX_AGE = 80;
      POP_INIT = 10000;
      IMMIGRATION = .07; //percent of POP_INIT
      FRIENDLY_POP = 127110000; // American population (2013)
      SCALER_H = 0.03;
      break;
    case 6: // Group B
      BIRTH_RATE = 1.41;
      MAX_AGE = 80;
      POP_INIT = 10000;
      IMMIGRATION = .008; //percent of POP_INIT
      FRIENDLY_POP = 127110000; // American population (2013)
      SCALER_H = 0.03;
      break;
    case 7: // Group C
      BIRTH_RATE = 1.41;
      MAX_AGE = 80;
      POP_INIT = 10000;
      IMMIGRATION = .155; //percent of POP_INIT
      FRIENDLY_POP = 127110000; // American population (2013)
      SCALER_H = 0.03;
      break;
  }
  
  background(0);
  counter = 0;
  
  fill(#FFFFFF);
  text("LOADING ... mode " + popMode, 25, 40);
  
  text("Avg. Birthrate: " + BIRTH_RATE, 25, 80);
  text("Avg. Death Age: " + MAX_AGE, 25, 100);
  text("Initial Population: " + FRIENDLY_POP/1000000.0 + " million", 25, 120);
  
//  fill(SENIOR_COLOR);
//  text("SENIORS", 100, 100 + 40);
//  fill(CHILDREN_COLOR);
//  text("CHILDREN", 100, 100 + 80);
//  fill(ADULT_COLOR);
//  text("WORKING ADULTS", 100, 100 + 60);
  
  test = new Population( POP_INIT, MAX_AGE, BIRTH_RATE, IMMIGRATION );
}

void draw() {
  
  test.iterate();
  test.printSummary();
  test.drawGraph();
  
  counter++;
  
  if (counter*SCALER_W > width) {
    noLoop();
  }
  
  //noLoop();
}

void keyPressed() {
  switch (key) {
    case ' ': 
    
      if (popMode < NUM_MODES-1)
        popMode++;
      else
        popMode = 0;
        
      reInit(popMode);
      loop();
      break;
  }
}
