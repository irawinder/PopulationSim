class Population {
  
  int popInit;
  int maxAge;
  float avgChildren;
  float immigration;
  ArrayList<Person> population;
  boolean privateCar;
  boolean watchTV;
  
  int DEATH_RANGE = 20;
  int ADULT_AGE = 18;
  int SENIOR_AGE = 65;
  int BIRTH_END_AGE = 42;
  
  int childrenCount, adultCount, seniorCount, birthCount, femaleCount, nativeCount, nonNativeCount, gen1Count, gen2Count, privateCarCount, watchTVCount;
  float verifyAvgChildren;
  
  Population(int popInit, int maxAge, float avgChildren, float immigration) {
    this.popInit = popInit;
    this.maxAge = maxAge;
    this.avgChildren = avgChildren;
    this.immigration = immigration;
    population = new ArrayList<Person>();
    
    privateCar = true;
    watchTV = true;
    
    birthCount = 0;
    
    for (int i=0; i<popInit; i++) {
      //int randomAge = int( random(maxAge-1) );
      int randomAge = int( random(MAX_AGE + random(-DEATH_RANGE, DEATH_RANGE)-1) );
      int deathAge = maxAge + int(random(-DEATH_RANGE, DEATH_RANGE));
      int numChildren = int( avgChildren + random(1.0) );
      population.add( new Person( randomAge, deathAge, numChildren, true, 2, privateCar, watchTV));
    }
  }
  
  void iterate() {
    
    if (counter == MAX_AGE) {
      privateCar = false;
      
      for (int i=0; i<population.size(); i++) {
        population.get(i).watchTV = false;
        
        if (population.get(i).age < 13) {
          if (random(1.0) < .16)
            population.get(i).watchTV = true;
        } else if (population.get(i).age < 20) {
          if (random(1.0) < .31)
            population.get(i).watchTV = true;
        } else if (population.get(i).age < 30) {
          if (random(1.0) < .24)
            population.get(i).watchTV = true;
        } else if (population.get(i).age < 40) {
          if (random(1.0) < .37)
            population.get(i).watchTV = true;
        } else if (population.get(i).age < 50) {
          if (random(1.0) < .44)
            population.get(i).watchTV = true;
        } else if (population.get(i).age < 60) {
          if (random(1.0) < .65)
            population.get(i).watchTV = true;
        } else if (population.get(i).age < 70) {
          if (random(1.0) < .78)
            population.get(i).watchTV = true;
        } else {
          if (random(1.0) < .85)
            population.get(i).watchTV = true;
        }
      }
    }
    
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
    privateCarCount = 0;
    watchTVCount = 0;
    
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
        population.add(new Person(randomAge, deathAge, numChildren, false, 0, privateCar, false));
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
              population.add(new Person(0, deathAge, numChildren, true, 1, privateCar, false));
            else
              population.add(new Person(0, deathAge, numChildren, true, 2, privateCar, false));
              
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
          
        if (population.get(i).privateCar)
          privateCarCount++;
          
        if (population.get(i).watchTV)
          watchTVCount++;
          
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
      
//      // Relative Counts
//      fill(SHARED_CAR_COLOR);
//     ellipse(counter*scalerW + scalerW/4.0, RELATIVE_GRAPH_HEIGHT - RELATIVE_GRAPH_HEIGHT*(1-float(privateCarCount)/population.size()), scalerW/2.0, scalerW/2.0);

      // Relative Counts
      fill(NON_NATIVE_COLOR);
      ellipse(counter*scalerW + scalerW/4.0, RELATIVE_GRAPH_HEIGHT - RELATIVE_GRAPH_HEIGHT*(float(watchTVCount)/population.size()), scalerW/2.0, scalerW/2.0);
    
      // Total Counts
      fill(NATIVE_COLOR);
      rect(counter*scalerW, height - 50 - scalerH*population.size(), scalerW/2.0, scalerH*population.size());
      
      // Total Counts
      fill(NON_NATIVE_COLOR);
      rect(counter*scalerW, height - 50 - scalerH*watchTVCount, scalerW/2.0, scalerH*watchTVCount);
/*      
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
*/

      if ((counter - MAX_AGE) % 10 == 0 && counter*scalerW < width) {
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
        text((counter - MAX_AGE) + "yr", counter*scalerW, RELATIVE_GRAPH_HEIGHT + 40);
        textAlign(LEFT);
        line(counter*scalerW, RELATIVE_GRAPH_HEIGHT + 50, counter*scalerW, height - 50);
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
        line(counter*scalerW, height - 50 - scalerH*population.size(), width, height - 50 - scalerH*population.size());
        text("Total Population", counter*scalerW - textWidth("Total Population") - 10, height - 50 - scalerH*population.size() + 25);
        
        stroke(NON_NATIVE_COLOR, 150);
        fill(NON_NATIVE_COLOR);
        line(counter*scalerW, height - 50 - scalerH*watchTVCount, width, height - 50 - scalerH*watchTVCount);
        text("Broadcast TV 'Viewers'", counter*scalerW - textWidth("Broadcast TV 'Viewers'") - 10, height - 50 - scalerH*watchTVCount + 5);
        
        /*
        
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
        
        */
        
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
