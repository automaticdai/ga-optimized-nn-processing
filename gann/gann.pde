import java.util.*;

ArrayList<Agent> agents = new ArrayList<Agent>();

int population = 200;

float[] fitness_cdf;

int iter = 0;
int step = 0;

void setup() {
  size(800, 800);
  
  // initilize population
  for (int i = 0; i < population; i++) {
    Agent a = new Agent();
    agents.add(a);
  }
  
  // initilize fitness
  fitness_cdf = new float[agents.size()];
}


void draw() {
  background(255);
  noStroke();
  
  disp_debug_info();
  
  for (int i = 0; i < agents.size(); i++) {
      agents.get(i).move();
      agents.get(i).show();
  }
  
  step += 1;
  
  if (step == 500) {
    evoluation();
    
    iter += 1;
    step = 0;
  }
  
}

//

void disp_debug_info() {
  
  String s = "iter: " + iter;
  text(s, 10, 20);
  
  s = "step: " + step;
  text(s, 10, 30);
}


void evoluation() {
  ArrayList<Agent> agents_new = new ArrayList<Agent>();
  
  // decide fitness function
  float error_sum = 0;
  for (int i = 0; i < agents.size(); i++) {
      error_sum += 1.0 / (agents.get(i).error_avg);
  }
  
  for (int i = 0; i < agents.size(); i++) {
      fitness_cdf[i] = (1.0 / agents.get(i).error_avg) / error_sum;
      if (i != 0) {
        fitness_cdf[i] += fitness_cdf[i - 1]; 
      }
  }
  //println(fitness_cdf);
  
  // generate population
  for (int p = 0; p < agents.size(); p++) {
    int i = 0;
    int j = 0;
    float f;
    // parent A
    f = random(1);
    for (i = 0; i < fitness_cdf.length; i++) {
      if (fitness_cdf[i] > f) {
        break;
      }
    }
    // parent B
    f = random(1);
    for (j = 0; j < fitness_cdf.length; j++) {
      if (fitness_cdf[j] > f) {
        break;
      }
    } 
    //println(i, j);
    Agent child_new = crossover(agents.get(i), agents.get(j)); 
     
    agents_new.add(child_new);
  }
  
  agents = agents_new;
}


Agent crossover(Agent parentA, Agent parentB) {
  Agent child = new Agent();
  
  // weight_in
  for (int j = 0; j < 2; j++) {
    for (int i = 0; i < 8; i++) {
      float s = random(1);
      if (s > 0.5) {
        child.weight_in[j][i] = parentA.weight_in[j][i];
      }
      else {
        child.weight_in[j][i] = parentB.weight_in[j][i];
      }
      
      //child.weight_in[j][i] = mutation(child.weight_in[j][i]); 
    }
  }
  
  // weight_out
  for (int j = 0; j < 8; j++) {
    for (int i = 0; i < 2; i++) {
      float s = random(1);
      if (s > 0.5) {
        child.weight_out[j][i] = parentA.weight_out[j][i]; 
      }
      else {
        child.weight_out[j][i] = parentB.weight_out[j][i];
      }
      
      //child.weight_out[j][i] = mutation(child.weight_out[j][i]);
    }
  }
  
  return child;
  
}


float mutation(float dna) {
  float new_dna;
  float p = random(1);
  
  if (p < 0.01) {
    new_dna = random(-0.1, 0.1);
  } else {
    new_dna = dna;
  }
  
  return new_dna;
  
}
