// Variables
int gameState = 0;          // 0 = menu, 1 = playing, 2 = game over
char target;
String message = "";
String pool = "asdfjklqweruiopzxcvbnmgthy";  // easiest letters first; numLetters limits how many are acc used
int numLetters = 6;
int score = 0;

int startTime = 0;
int endTime = 0;
int timeLimit = 30;

int btnW = 200;
int btnH = 60;
int btnX = 200;
int easyY = 150;
int medY = 240;
int hardY = 330;

// Peakest Setup OAT
void setup() {
  size(600, 450);
  textAlign(CENTER, CENTER);
}

// Shape and color yay
void draw() {
  background(30);

  if (gameState == 0) {
    fill(255);
    textSize(36);
    text("Typing Test", width / 2, 70);
    textSize(18);
    text("Choose a difficulty", width / 2, 110);

    drawButton(btnX, easyY, btnW, btnH, "Easy", color(80, 180, 90));
    drawButton(btnX, medY, btnW, btnH, "Medium", color(220, 170, 50));
    drawButton(btnX, hardY, btnW, btnH, "Hard", color(200, 70, 70));
  } else if (gameState == 1) {
    int timeLeft = timeLimit - (millis() - startTime) / 1000;

    // Timer check lives in draw() so the game ends even if the player stops typing cuz
    if (timeLeft <= 0) {
      timeLeft = 0;
      endTime = millis();
      message = "Time's up!";
      gameState = 2;
      println("Time's up! Final score: " + score);    
    }

    fill(255);
    textSize(18);
    text("Score: " + score, 80, 30);
    text("Time: " + timeLeft, width - 80, 30);

    textSize(140);
    text(target, width / 2, height / 2 - 20);

    fill(100, 255, 120);
    textSize(28);
    text(message, width / 2, height - 60);
  } else if (gameState == 2) {
    float seconds = (endTime - startTime) / 1000.0;
    float lettersPerMin = 0;
    if (seconds > 0) {
      lettersPerMin = score / seconds * 60;
    }

    fill(255);
    textSize(36);
    text("Game Over", width / 2, 60);

    fill(255, 120, 120);
    textSize(24);
    text(message, width / 2, 110);

    fill(255);
    textSize(22);
    text("Score: " + score, width / 2, 170);
    text("Time: " + nf(seconds, 1, 1) + " seconds", width / 2, 205);
    text("Speed: " + nf(lettersPerMin, 1, 1) + " letters/min", width / 2, 240);

    String rank;
    if (score >= 30) {
      rank = "Lightning Fingers!";
    } else if (score >= 20) {
      rank = "Fast Typist";
    } else if (score >= 10) {
      rank = "Getting There";
    } else {
      rank = "Keep Practicing";
    }
    text("Rank: " + rank, width / 2, 290);

    textSize(18);
    text("Click anywhere to return to the menu", width / 2, 380);
  }
}

// Mouse functions like Mr. Marty taught
void mousePressed() {
  if (gameState == 0) {
    // >= and <= so the borders count as part of the button
    if (mouseX >= btnX && mouseX <= btnX + btnW) {
      if (mouseY >= easyY && mouseY <= easyY + btnH) {
        startGame(6);
      } else if (mouseY >= medY && mouseY <= medY + btnH) {
        startGame(12);
      } else if (mouseY >= hardY && mouseY <= hardY + btnH) {
        startGame(26);
      }
    }
  } else if (gameState == 2) {
    gameState = 0;
    println("Returned to menu");    
  }
}

// Keyboard functions: I seriously need to practice....
void keyPressed() {
  // Nothing happens unless a game is in progress
  if (gameState != 1) {
    return;
  }

  // Ignore Shift, Ctrl, arrows, etc.
  if (key == CODED) {
    return;
  }

  // Convert uppercase to lowercase
  char typed = key;
  if (typed >= 'A' && typed <= 'Z') {
    typed = char(typed + 32);
  }

  if (typed == target) {
    score++;
    message = "Great work!";
    println("Correct! Typed: " + typed + " | Score: " + score);
    pickLetter();
    println("Next letter: " + target);      
  } else {
    endTime = millis();
    message = "Wrong! You typed '" + typed + "'";
    gameState = 2;
    println("Wrong! Typed: " + typed + " | Needed: " + target);            
    println("Final score: " + score);                                   
    println("Time played: " + (endTime - startTime) / 1000 + "s");        
  }
}

// outro
void startGame(int letters) {
  numLetters = letters;
  score = 0;
  message = "";
  startTime = millis();

  if (letters == 6) {                    
    println("Level chosen: Easy");
  } else if (letters == 12) {
    println("Level chosen: Medium");
  } else {
    println("Level chosen: Hard");
  }

  pickLetter();
  println("Letters in play: " + numLetters);                                
  println("First letter: " + target);                                       
  gameState = 1;
}

void pickLetter() {
  int index = int(random(numLetters));   // numLetters lowk cant exceed pool.length() // Randomness best topic in processing 
  target = pool.charAt(index);
}

void drawButton(int x, int y, int w, int h, String label, color c) {
  fill(c);
  stroke(255);
  strokeWeight(2);
  rect(x, y, w, h);
  fill(255);
  textSize(26);
  text(label, x + w / 2, y + h / 2);
}
