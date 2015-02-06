import processing.video.*;

Capture video;
Movie movie;

PImage backgroundImage, bg;

float threshold = 20;

boolean bStarted;

void setup() {
  size( 1280, 720 );
  
  movie = new Movie(this, "jcvd.mp4");
  
  video = new Capture(this, width, height, 30);
  video.start();
  
  backgroundImage = createImage( video.width, video.height, RGB );
  bg = loadImage( "bg.png" );
}

void movieEvent(Movie m) {
  m.read();
}

void captureEvent(Capture c) {
  c.read();
}

void draw() {
  if( !bStarted ) {
    bStarted = true;
    
    movie.loop();
  }
  
  background( 255 );
  image( bg, 0, 0 );
  
  //loadPixels();
  video.loadPixels(); 
  PImage newImage = createImage( movie.width, movie.height, ARGB );
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width; // Step 1, what is the 1D pixel location
      color fgColor = video.pixels[loc]; // Step 2, what is the foreground color
      
      // Step 3, what is the background color
      color bgColor = backgroundImage.pixels[loc];
      
      // Step 4, compare the foreground and background color
      float r1 = red(fgColor);
      float g1 = green(fgColor);
      float b1 = blue(fgColor);
      float r2 = red(bgColor);
      float g2 = green(bgColor);
      float b2 = blue(bgColor);
      float diff = dist(r1,g1,b1,r2,g2,b2);
      
      // Step 5, Is the foreground color different from the background color
      if (diff > threshold) {
        // If so, display the foreground color
        newImage.pixels[loc] = fgColor;
      } else {
        // If not, display green
        newImage.pixels[loc] = color( 0, 0, 0, 0 );
      }
    }
  }
  
  image( newImage, 0, 0 );
  
  movie.loadPixels();
  newImage = createImage( movie.width, movie.height, ARGB );
  for (int x = 0; x < movie.width; x ++ ) {
    for (int y = 0; y < movie.height; y ++ ) {
      int loc = x + y*movie.width; // Step 1, what is the 1D pixel location
      color fgColor = movie.pixels[loc]; // Step 2, what is the foreground color
      
      // Step 3, what is the background color
      color bgColor = color(85, 250, 59);
      
      // Step 4, compare the foreground and background color
      float r1 = red(fgColor);
      float g1 = green(fgColor);
      float b1 = blue(fgColor);
      float r2 = red(bgColor);
      float g2 = green(bgColor);
      float b2 = blue(bgColor);
      float diff = dist(r1,g1,b1,r2,g2,b2);
      
      // Step 5, Is the foreground color different from the background color
      if (diff > 95) {
        // If so, display the foreground color
        //pixels[loc] = fgColor;
        newImage.pixels[loc] = fgColor;
      } else {
        // If not, display green
        //pixels[loc] = color(0,255,0); // We could choose to replace the background pixels with something other than the color green!
        newImage.pixels[loc] = color( 0, 0, 0, 0 );
      }
    }
  }
  
  image( newImage, 0, 0 );
}

void mousePressed() {
  // Copying the current frame of video into the backgroundImage object
  // Note copy takes 5 arguments:
  // The source image
  // x,y,width, and height of region to be copied from the source
  // x,y,width, and height of copy destination
  backgroundImage.copy(video,0,0,video.width,video.height,0,0,video.width,video.height);
  backgroundImage.updatePixels();
  
  float m = map( mouseY, 0, height, 0, 100 );
  threshold = m;
  
  println( threshold );
}
