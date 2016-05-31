class Person {
  
  int age;
  int deathAge;
  int anticipatedChildren;
  boolean alive;
  int numChildren;
  boolean female;
  boolean nativeBorn;
  int generation;
  boolean privateCar;
  boolean watchTV;
  
  Person(int age, int deathAge, int anticipatedChildren, boolean nativeBorn, int generation, boolean privateCar, boolean watchTV) {
    this.age = age;
    this.deathAge = deathAge;
    this.anticipatedChildren = anticipatedChildren;
    this.nativeBorn = nativeBorn;
    this.generation = generation;
    this.privateCar = privateCar;
    this.watchTV = watchTV;
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
