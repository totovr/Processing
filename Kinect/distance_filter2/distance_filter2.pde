/******************************************************************
 
 FILTERS THE KINECT IMAGE BASED ON A DISTANCE RANGE
 (ONLY SHOW OBJECTS BETWEEN 500-1500mm FOR INSTANCE)
 CAN BE USED AS A REPLACEMENT FOR BLUE- AND GREEN SCREEN TECHNIQUES
 
 Uses SimpleOpenNI (http://code.google.com/p/simple-openni/)
 
 Release v16-07-2013
 
 (c) 2012-2013 Rolf van Gelder, CAGE web design
 
 http://cagewebdev.com, info@cagewebdev.com
 
 ******************************************************************/

// KINECT INTERFACE
import SimpleOpenNI.*;
SimpleOpenNI simpleOpenNI;

// IMAGES
PImage maskImage;
PImage rgbImage;

// KINECT DEPTH VALUES
int[] depthValues;

// RADIUS FOR BLUR (PIXELS)
int currentRadius = 3;

// DISTANCE RANGE IN MILLIMETERS (FOR THE FILTER)
int minDistance  = 500;  // 50cm
int maxDistance  = 1500; // 1.5m

// SIZES
int canvasWidth  = 640;
int canvasHeight = 480;

int kinectWidth  = 640;
int kinectHeight = 480;

boolean showFrameRate = false;

// FOR TAKING AUTOMATIC SCREEN GRABS
int     startTime        = millis();
boolean saved            = false;
// TAKE AN AUTOMATIC SCREENGRAB AFTER screenGrabMillis MILLIS
boolean takeScreenGrab   = false;
// TIME BEFORE THE AUTOMATIC SCREENGRAB WILL BE TAKEN
int     screenGrabMillis = 40000;


/*************************************************************
 
 INITIALIZATION
 
 *************************************************************/
void setup()
{
  size(640, 480);

  // INITIALIZE THE KINECT
  initKinect();

  // MASK FOR MASKING THE MOVIE
  maskImage  = createImage(kinectWidth, kinectHeight, RGB);

  textSize(20);
  frameRate(100);

  println("<M/m>   = in-/decrease MINIMUM distance");
  println("<X/x>   = in-/decrease MAXIMUM distance");
  println("<B/b>   = in-/decrease BLUR");
  println("<F/f>   = show FRAME RATE (toggle)");
  println("<I/i>   = show current SETTINGS");
  println("<SPACE> = take a screengrab");
} // setup()


/*************************************************************
 
 INITIALIZE KINECT
 
 *************************************************************/
void initKinect()
{
  // NEW OPENNI CONTEXT INSTANCE
  simpleOpenNI = new SimpleOpenNI(this);

  // MIRROR THE KINECT IMAGE
  simpleOpenNI.setMirror(true);

  // ENABLE THE DEPTH MAP
  if (simpleOpenNI.enableDepth() == false)
  { // COULDN'T ENABLE DEPTH MAP
    println("Can't open the depthMap, maybe the Kinect is not connected!"); 
    exit();
    return;
  }

  // ENABLE THE RGB IMAGE
  if (simpleOpenNI.enableRGB() == false)
  { // COULDN'T ENABLE DEPTH MAP
    println("Can't open the Kinect cam, maybe the Kinect is not connected!"); 
    exit();
    return;
  }

  // ALIGN DEPTH DATA TO IMAGE DATA
  simpleOpenNI.alternativeViewPointDepthToImage();
} // initKinect()


/*************************************************************
 
 PROCESSING LOOP
 
 *************************************************************/
void draw()
{
  // BLACK BACKGROUND
  background(0);

  // UPDATE THE KINECT IMAGES
  simpleOpenNI.update();

  // GET DEPTH VALUES IN MILLIMETERS
  depthValues = simpleOpenNI.depthMap();

  maskImage.loadPixels();
  for (int pic = 0; pic < depthValues.length; pic++)
    if (depthValues[pic] > minDistance && depthValues[pic] < maxDistance)
      // IN RANGE: WHITE PIXEL
      maskImage.pixels[pic] = color(255);
    else
      maskImage.pixels[pic] = color(0);
  maskImage.updatePixels();

  // BLUR THE B/W IMAGE
  if (currentRadius > 0) superFastBlur(currentRadius);

  // MASK THE RGB CAM IMAGE
  rgbImage = simpleOpenNI.rgbImage();
  rgbImage.mask(maskImage);

  // COMPENSATE FOR alternativeViewPointDepthToImage
  image(rgbImage, -50, -50, canvasWidth+50, canvasHeight+50);

  if (showFrameRate) text("FPS: "+nfc(frameRate, 1), 10, 25);

  if (takeScreenGrab && !saved && (millis()-startTime>screenGrabMillis))
  { // SAVE SCREENGRAB (ONCE, AFTER screenGrabMillis MS)
    takePicture();
    saved = true;
    println("AUTOMATIC SCREENGRAB SAVED.....................");
  }
} // draw()


/*************************************************************
 
 KEY HANDLER
 
 *************************************************************/
void keyPressed()
{
  boolean validKey = false;

  // KEY HANDLER
  switch(key)
  {
  case ' ':
    // MAKE A SCREEN GRAB
    takePicture();
    return;
  case 'B':
    // INCREASE BLUR
    currentRadius++;
    validKey = true;
    break;
  case 'b':
    // DECREASE BLUR
    if (currentRadius>0) currentRadius--; 
    validKey = true;
    break;
  case 'F':
  case 'f':
    // SHOW FRAME RATE
    showFrameRate = !showFrameRate;   
    break;
  case 'I':
  case 'i':
    // SHOW CURRENT SETTINGS
    validKey = true;    
    break;
  case 'M':
    // INCREASE THE MINIMUM DISTANCE BY 100mm
    minDistance += 100;
    validKey = true;    
    break;
  case 'm':
    // DECREASE THE MINIMUM DISTANCE BY 100mm
    minDistance -= 100;
    validKey = true;
    break;
  case 'X':
    // INCREASE THE MAXIMUM DISTANCE BY 100mm
    maxDistance += 100;
    validKey = true;    
    break;
  case 'x':
    // DECREASE THE MAXIMUM DISTANCE BY 100mm
    maxDistance -= 100;
    validKey = true;    
    break;
  }
  // SHOW CURRENT SETTINGS
  if (validKey) showSettings();
} // keyPressed()


/*************************************************************
 
 SHOW CURRENT SETTINGS
 
 *************************************************************/
void showSettings()
{
  println("Blur: "+currentRadius+" Min: "+minDistance+" Max: "+maxDistance);
} // showSettings()


/*************************************************************
 
 MAKE A SCREENGRAB
 
 *************************************************************/
void takePicture()
{
  save("capture_"+timestamp()+".png");
  println("Picture taken...");
} // takePicture()


/*****************************************************************************************
 *
 * CREATE A TIME STAMP (YYYYMMDDHHMMSS)
 * 
 *****************************************************************************************/
String timestamp()
{
  return year()+nf(month(), 2)+nf(day(), 2)+nf(hour(), 2)+nf(minute(), 2)+nf(second(), 2);
} // timestamp()


/*************************************************************
 
 FINISH
 
 *************************************************************/
void stop()
{
  simpleOpenNI.dispose();

  super.stop();
} // stop()
