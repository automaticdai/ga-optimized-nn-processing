public class Agent {
  int     agent_id = 0;
  PVector loc;
  PVector vel = new PVector(0,0);
  PVector acc = new PVector(0,0);
  
  float   error_avg = 0;
  long    iter      = 1;
  
  int number_of_hidden = 8;
  float[][] weight_in = new float[2][number_of_hidden];
  float[][] weight_out = new float[number_of_hidden][2];
  
  Agent() {
    for (int j = 0; j < 2; j++) {
      for (int i = 0; i < number_of_hidden; i++) {
        weight_in[j][i] = random(-0.1, 0.1);
      }
    }
    
   for (int j = 0; j < number_of_hidden; j++) {
      for (int i = 0; i < 2; i++) {
        weight_out[j][i] = random(-0.1, 0.1);
      }
    }
    
    float ang = random(TWO_PI);
    
    loc = new PVector(400*sin(ang) + width/2, 400*cos(ang) + height/2);
    
  }
  
  public void move() {
    PVector center = new PVector(width/2, height/2);
    PVector error  = PVector.sub(center, loc);
    
    float[] weight_fire = new float[number_of_hidden];
    PVector acc_fire = new PVector(0, 0);
    
    error_avg = error_avg * iter / (iter + 1) + error.mag() / (iter + 1);
    iter += 1;
    
    for (int i = 0; i < weight_fire.length; i++) {
      weight_fire[i] = error.x * weight_in[0][i] + error.y * weight_in[1][i];
      acc_fire.x += weight_fire[i] * weight_out[i][0];
      acc_fire.y += weight_fire[i] * weight_out[i][1];
    }
    
    acc = acc_fire;
    acc.x = constrain(acc.x, -20, 20);
    acc.y = constrain(acc.y, -20, 20);
    
    vel.add(acc);
    vel.x = constrain(vel.x, -10, 10);
    vel.y = constrain(vel.y, -10, 10);
    
    loc.add(vel);
    loc.x = constrain(loc.x, 0, width);
    loc.y = constrain(loc.y, 0, height);
  }
  
  public void learn(){
    
    if (iter == 600) {
      
      if (error_avg > 100) {
        regenerate();
      }
      iter = 1;
      
      println(error_avg);
      error_avg = 0; 
    }
  }
  
  public void show() {
    pushMatrix();
    
    float r = constrain(error_avg/10, 1, 10);
    fill(10*(10-r));
    
    translate(loc.x, loc.y);
    rotate(vel.heading());
    triangle(-5, 9, 0, 0, 5, 9);
    //showWeights();
    popMatrix();
  }
  
  public void showWeights() {
    for (int j = 0; j < weight_in.length; j++) {
      for (int i = 0; i < weight_in[0].length; i++) {
        String s = Float.toString(weight_in[j][i]);
        text(s, 0 + 100 * j, 10 + 10*i);
      }
    }
  }
  
  public void regenerate() {
    for (int j = 0; j < 2; j++) {
      for (int i = 0; i < number_of_hidden; i++) {
        weight_in[j][i] = random(-0.01, 0.01);
      }
    }
  }

/*  
 @Override
  public String toString() {
    ;
  }
*/

}
