import SimpleOpenNI.*;

float theta1;
float theta2;
float yval;
float xval;

SimpleOpenNI  context;
color[]       userClr = new color[]{ color(255,0,0),
                                     color(0,255,0),
                                     color(0,0,255),
                                     color(255,255,0),
                                     color(255,0,255),
                                     color(0,255,255)
                                   };
//PVector com = new PVector();                                   
//PVector com2d = new PVector();                                   

void setup()
{
  size(960,540);
  
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }

  context.setMirror(true);
  
  // enable depthMap generation 
  context.enableDepth();
   
  // enable skeleton generation for all joints
  context.enableUser();
 
  background(255,255,255);

  stroke(0,255,0);
  strokeWeight(3);
  smooth();  
}

void draw()
{
  // update the cam
  context.update();
  background(255,255,255);
   textSize(20);

  
  // draw depthImageMap
  //image(context.depthImage(),0,0);
  //image(context.userImage(),0,0);
  
  // draw the skeleton if it's available
  int[] userList = context.getUsers();
  for(int i=0;i<userList.length;i++)
  {
    if(context.isTrackingSkeleton(userList[i]))
    {
      stroke(userClr[ (userList[i] - 1) % userClr.length ] );
      drawSkeleton(userList[i]);


    }      
      
  }    
}

// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{
  // to get the 3d joint data
  /*
  PVector jointPos = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,jointPos);
  println(jointPos);
  */


  PVector torso = new PVector(); 
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_TORSO,torso);
  PVector convertedTorso = new PVector();
  context.convertRealWorldToProjective(torso, convertedTorso);


  PVector rightHand = new PVector(); 
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,rightHand);
  PVector convertedRightHand = new PVector();
  context.convertRealWorldToProjective(rightHand, convertedRightHand);
  //float rightEllipseSize = map(convertedRightHand.z, 700, 2500,  50, 1);
  ellipse(convertedRightHand.x, convertedRightHand.y, 10, 10);
  //text("hand: " + convertedRightHand.x + " " + convertedRightHand.y, 10, 50);
//  yval = -(convertedRightHand.y-height/2);
    xval = (convertedRightHand.x-convertedTorso.x);
  //yval = map(convertedRightHand.y,0,height,1,-1);
  //xval = map(convertedRightHand.x,0,width,1,-1);
//  if (xval>=0){
//  theta1 = acos(yval/sqrt(sq(xval)+sq(yval)));
//  }
//  else{
//  theta1 = -acos(yval/sqrt(sq(xval)+sq(yval)));
//  }
  theta1 = PVector.angleBetween(new PVector(convertedRightHand.x-convertedTorso.x,convertedRightHand.y-convertedTorso.y,0.0),new PVector(0,convertedTorso.y-height,0.0));
  if (xval<0){
    theta1*= -1;
  }
  
  PVector leftHand = new PVector(); 
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,leftHand);
  PVector convertedLeftHand = new PVector();
  context.convertRealWorldToProjective(leftHand, convertedLeftHand);
  //float leftEllipseSize = map(convertedLeftHand.z, 700, 2500,  50, 1);
  ellipse(convertedLeftHand.x, convertedLeftHand.y, 10, 10);
  //yval = -(convertedLeftHand.y-height/2);
    xval = (convertedLeftHand.x-convertedTorso.x);
  //yval = map(convertedLeftHand.y,0,height,1,-1);
  //xval = map(convertedLeftHand.x,0,width,1,-1);
  theta2 = PVector.angleBetween(new PVector(convertedLeftHand.x-convertedTorso.x,convertedLeftHand.y-convertedTorso.y,0.0),new PVector(0,convertedTorso.y-height,0.0));
  if (xval<0){
    theta2*= -1;
  }

  
  context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);  


  translate(convertedTorso.x+320, height);
  stroke(0);
  branch(160);

}

// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  curContext.startTrackingSkeleton(userId);
  
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}


// Each branch now receives
// its length as an argument.
void branch(float len) {

  line(0, 0, 0, -len);
  translate(0, -len);

  // Each branch’s length
  // shrinks by two-thirds.
  len *= 0.66;

  if (len > 2) {
    pushMatrix();
    rotate(theta2);
    // Subsequent calls to branch()
    // include the length argument.
    branch(len);
    popMatrix();

    pushMatrix();
    rotate(theta1);
    branch(len);
    popMatrix();
  }
}
