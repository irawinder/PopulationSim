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

class Population {
  
  int popInit;
  int maxAge;
  float avgChildren;
  float immigration;
  ArrayList<Person> population;
  
  int DEATH_RANGE = 20;
  int ADULT_AGE = 18;
  int SENIOR_AGE = 65;
  int BIRTH_END_AGE = 42;
  
  int childrenCount, adultCount, seniorCount, birthCount, femaleCount, nativeCount, nonNativeCount, gen1Count, gen2Count;
  float verifyAvgChildren;
  
  Population(int popInit, int maxAge, float avgChildren, float immigration) {
    this.popInit = popInit;
    this.maxAge = maxAge;
    this.avgChildren = avgChildren;
    this.immigration = immigration;
    population = new ArrayList<Person>();
    
    birthCount = 0;
    
    for (int i=0; i<popInit; i++) {
      //int randomAge = int( random(maxAge-1) );
      int randomAge = int( random(MAX_AGE + random(-DEATH_RANGE, DEATH_RANGE)-1) );
      int deathAge = maxAge + int(random(-DEATH_RANGE, DEATH_RANGE));
      int numChildren = int( avgChildren + random(1.0) );
      population.add( new Person( randomAge, deathAge, numChildren, true, 2));
    }
  }
  
  void iterate() {
    
    if (counter == MAX_AGE + 30) {
      if (popMode == 5) {
        avgChildren = 2.0;
        SENIOR_AGE = 70;
      }
      else if (popMode == 6) {
        avgChildren = 2.0;
        SENIOR_AGE = 65;
      }
      else if (popMode == 7) {
        avgChildren = 2.5;
        SENIOR_AGE = 70;
      }
    }

    
    childrenCount = 0;
    adultCount = 0;
    seniorCount = 0;
    femaleCount = 0;
    nativeCount = 0;
    nonNativeCount = 0;
    verifyAvgChildren = 0;
    gen1Count = 0;
    gen2Count = 0;
    
    if (counter >= MAX_AGE) {
      for (int i=0; i<immigration*popInit/100; i++) {
        int randomAge;
        if (popMode == 7)
          randomAge = int( random(26) );
        else
          randomAge = int( random(MAX_AGE + random(-DEATH_RANGE, DEATH_RANGE)-1) );
        int deathAge = maxAge + int(random(-DEATH_RANGE, DEATH_RANGE));
        int numChildren;
        numChildren = int( avgChildren + random(1.0) );
        population.add(new Person(randomAge, deathAge, numChildren, false, 0));
      }
    }
    
    for (int i=0; i<population.size(); i++) {
      
      population.get(i).birthday();
      
      if (population.get(i).alive == false)  {
        
        population.remove(i);
        
      } else {
        
        if (random(1.0) < 0.3 && population.get(i).age > ADULT_AGE && population.get(i).age < BIRTH_END_AGE) {
          if (population.get(i).numChildren < population.get(i).anticipatedChildren && population.get(i).female == true) {
            int deathAge = maxAge + int(random(-DEATH_RANGE, DEATH_RANGE));
            int numChildren;
//            if (counter > (MAX_AGE+30) && counter < (MAX_AGE+60)) // 1st Population Boom
//              numChildren = int( avgChildren + 3 + random(1.0) );
//            else if (counter > (MAX_AGE+130) && counter < (MAX_AGE+160)) // 1st Population Boom
//              numChildren = int( avgChildren + 3 + random(1.0) );
//            else
              numChildren = int( avgChildren + random(1.0) );
            
            if (population.get(i).generation == 0)
              population.add(new Person(0, deathAge, numChildren, true, 1));
            else
              population.add(new Person(0, deathAge, numChildren, true, 2));
              
            population.get(i).numChildren++;
            birthCount++;
          }
        }
        
        if (population.get(i).female) {
          femaleCount++;
          verifyAvgChildren += population.get(i).anticipatedChildren;
        }
        
        if (population.get(i).nativeBorn)
          nativeCount++;
        else
          nonNativeCount++;
          
        if (population.get(i).generation == 1)
          gen1Count++;
        else if (population.get(i).generation == 2)
          gen2Count++;
          
        if (population.get(i).age < ADULT_AGE)
          childrenCount++;
        else if (population.get(i).age < SENIOR_AGE)
          adultCount++;
        else if (population.get(i).age >= SENIOR_AGE)
          seniorCount++;
        
      }
    }
    
    verifyAvgChildren /= femaleCount;
    
  }
  
  void printSummary() {
    
    println("Year: +" + counter);
    println("Children (18-): " + childrenCount + " (" + int(10000*float(childrenCount)/population.size())/100.0 + "%)");
    println("Working Adults: " + adultCount + " (" + int(10000*float(adultCount)/population.size())/100.0 + "%)");
    println("Seniors (65+): " + seniorCount + " (" + int(10000*float(seniorCount)/population.size())/100.0 + "%)");
    println("Females: " + femaleCount + " (" + int(10000*float(femaleCount)/population.size())/100.0 + "%)");
    println("Natives: " + nativeCount + " (" + int(10000*float(nativeCount)/population.size())/100.0 + "%)");
    println("Verified Birth Rate: " + verifyAvgChildren);
    println("Total: " + population.size() + " (100.00%)");
    
//    if (population.size() > 0) {
//      int i = 0;
//      println("Person " + i + ":");
//      println("Female: " + population.get(i).female);
//      println("Age: " + population.get(i).age);
//      println("deathAge: " + population.get(i).deathAge);
//      println("numChildren: " + population.get(i).numChildren);
//      println("anticipatedChildren: " + population.get(i).anticipatedChildren);
//    }
    
    println("---");
  }
  
  void drawGraph() { 
    
    int diameter = 3;
    int scalerW = SCALER_W;
    float scalerH = SCALER_H;
    float RELATIVE_GRAPH_HEIGHT = 300;
    
    if (counter >= MAX_AGE) {
      
      noStroke();
      fill(CHILDREN_COLOR);
//      // Total Counts
//      ellipse(counter*scalerW, height - 50 - scalerH*childrenCount, diameter, diameter);
      //Percent Counts
      rect(counter*scalerW, 0, scalerW/2.0, RELATIVE_GRAPH_HEIGHT);
      
      fill(ADULT_COLOR, 150);
//      // Total Counts
//      ellipse(counter*scalerW, height - 50 - scalerH*adultCount, diameter, diameter);
      //Percent Counts
      rect(counter*scalerW, 0, scalerW/2.0, RELATIVE_GRAPH_HEIGHT*float(adultCount+seniorCount)/population.size());
      
      fill(SENIOR_COLOR);
//      // Total Counts
//      ellipse(counter*scalerW, height - 50 - scalerH*seniorCount, diameter, diameter);
      //Percent Counts
      rect(counter*scalerW, 0, scalerW/2.0, RELATIVE_GRAPH_HEIGHT*float(seniorCount)/population.size());
      
      // Relative Counts
      fill(NATIVE_COLOR);
      ellipse(counter*scalerW + scalerW/4.0, RELATIVE_GRAPH_HEIGHT - RELATIVE_GRAPH_HEIGHT*float(nativeCount)/float(nativeCount + nonNativeCount), scalerW/2.0, scalerW/2.0);
      
      // Total Counts
      fill(NATIVE_COLOR);
      rect(counter*scalerW, height - 50 - scalerH*nativeCount, scalerW/2.0, scalerH*nativeCount);
      
      // Total Counts
      fill(NATIVE_COLOR);
      rect(counter*scalerW, height - 50 - scalerH*gen2Count, scalerW/2.0, scalerH*gen2Count);
      
      // Total Counts
      fill(GEN1_COLOR);
      rect(counter*scalerW, height - 50 - scalerH*(gen2Count + gen1Count), scalerW/2.0, scalerH*gen1Count);
      
      // Total Counts
      fill(NON_NATIVE_COLOR);
      rect(counter*scalerW, height - 50 - scalerH*(nonNativeCount + nativeCount), scalerW/2.0, scalerH*nonNativeCount);
      
      if ((counter - MAX_AGE) % 30 == 0 && counter*scalerW < width) {
        fill(#FFFFFF);
        if (counter == MAX_AGE) {
          stroke(#FFFFFF);
          strokeWeight(3);
       }
        else {
          stroke(#FFFFFF, 150);
          strokeWeight(1);
        }
        textAlign(CENTER);
        text( (counter - MAX_AGE) + " yr", counter*scalerW, RELATIVE_GRAPH_HEIGHT + 70);
        textAlign(LEFT);
        line(counter*scalerW, RELATIVE_GRAPH_HEIGHT + 80, counter*scalerW, height - 50);
      }
      
      stroke(CHILDREN_COLOR, 150);
      fill(#000000, 50);
      noStroke();
      rect(MAX_AGE*scalerW + 35, RELATIVE_GRAPH_HEIGHT - 0.125*RELATIVE_GRAPH_HEIGHT - 8, textWidth("CHILDREN") + 10, 20);
      strokeWeight(1);
      fill(CHILDREN_COLOR);
      text("CHILDREN", MAX_AGE*scalerW + 40, RELATIVE_GRAPH_HEIGHT - 0.125*RELATIVE_GRAPH_HEIGHT + 6);
      
      stroke(ADULT_COLOR, 150);
      fill(0, 100);
      noStroke();
      rect(MAX_AGE*scalerW + 35, RELATIVE_GRAPH_HEIGHT - 0.5*RELATIVE_GRAPH_HEIGHT - 8, textWidth("WORKING ADULTS") + 10, 20);
      strokeWeight(1);
      fill(ADULT_COLOR);
      text("WORKING ADULTS", MAX_AGE*scalerW + 40, RELATIVE_GRAPH_HEIGHT - 0.5*RELATIVE_GRAPH_HEIGHT + 6);
      
      stroke(SENIOR_COLOR, 150);
      fill(0, 100);
      noStroke();
      rect(MAX_AGE*scalerW + 35, RELATIVE_GRAPH_HEIGHT - 0.875*RELATIVE_GRAPH_HEIGHT - 8, textWidth("SENIORS") + 10, 20);
      strokeWeight(1);
      fill(SENIOR_COLOR);
      text("SENIORS", MAX_AGE*scalerW + 40, RELATIVE_GRAPH_HEIGHT - 0.875*RELATIVE_GRAPH_HEIGHT + 6);
      
    } 
    
    if (counter <= MAX_AGE) {
      
      fill(#FFFFFF);
      
      if (counter < MAX_AGE - 10)
        text(".", counter*scalerW, 50);
      
      if (counter == MAX_AGE) {
        
        stroke(NATIVE_COLOR, 150);
        fill(NATIVE_COLOR);
        line(counter*scalerW, height - 50 - scalerH*gen2Count, width, height - 50 - scalerH*gen2Count);
        text("NATIVE-BORN GEN. 2+ POPULATION", counter*scalerW - textWidth("NATIVE-BORN GEN. 2+ POPULATION") - 10, height - 50 - scalerH*nativeCount + 25);
        
        stroke(GEN1_COLOR, 150);
        fill(GEN1_COLOR);
        line(counter*scalerW, height - 50 - scalerH*gen1Count, width, height - 50 - scalerH*gen1Count);
        text("NATIVE-BORN GEN. 1 POPULATION", counter*scalerW - textWidth("NATIVE-BORN GEN. 1 POPULATION") - 10, height - 50 - scalerH*nativeCount + 5);
        
        stroke(NON_NATIVE_COLOR, 150);
        fill(NON_NATIVE_COLOR);
//        line(counter*scalerW, height - 50 - scalerH*nonNativeCount, width, height - 50 - scalerH*nonNativeCount);
        text("NON NATIVE-BORN POPULATION", counter*scalerW - textWidth("NON NATIVE-BORN POPULATION") - 10, height - 50 - scalerH*nativeCount - 15);
        
        strokeWeight(3);
        stroke(#FFFFFF);
        line(counter*scalerW, height - 50, width, height - 50);
        strokeWeight(1);
        
        stroke(#FFFFFF, 150);
        fill(#FFFFFF);        
        for (int i=9; i>0; i--) {
          text(i*10 + "%", counter*scalerW - 30, RELATIVE_GRAPH_HEIGHT - i*0.1*RELATIVE_GRAPH_HEIGHT + 6);
          line(counter*scalerW, RELATIVE_GRAPH_HEIGHT - i*0.1*RELATIVE_GRAPH_HEIGHT, width, RELATIVE_GRAPH_HEIGHT - i*0.1*RELATIVE_GRAPH_HEIGHT);
        }
        
        friendlyImmigration = FRIENDLY_POP * (immigration*popInit/100) / (childrenCount+ adultCount + seniorCount);
        text("Immigration: " + int(1000*friendlyImmigration/1000000)/1000.0 + " million / yr", 25, 140);
        
      }
    }

  }
  
}


class Person {
  
  int age;
  int deathAge;
  int anticipatedChildren;
  boolean alive;
  int numChildren;
  boolean female;
  boolean nativeBorn;
  int generation;
  
  Person(int age, int deathAge, int anticipatedChildren, boolean nativeBorn, int generation) {
    this.age = age;
    this.deathAge = deathAge;
    this.anticipatedChildren = anticipatedChildren;
    this.nativeBorn = nativeBorn;
    this.generation = generation;
    numChildren = 0;
    alive = true;
    
    if (random(100) >= 50) 
      female = true;
  }
  
  void birthday() {
    age++;
    if (age > deathAge) alive = false;
  }  
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
