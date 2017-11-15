import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import SimpleOpenNI.*; 
import processing.serial.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Traking_Angle_LR_UP extends PApplet {




//Generate a SimpleOpenNI object
SimpleOpenNI kinect;

// Create object from Serial class
Serial myPort;  // Create object from Serial class

PVector com = new PVector();
PVector com2d = new PVector();

public void setup() {
 kinect = new SimpleOpenNI(this);
 kinect.enableDepth();
 //kinect.enableIR();
 kinect.enableUser();// because of the version this change
 
 fill(255, 0, 0);
 //size(kinect.depthWidth()+kinect.irWidth(), kinect.depthHeight());
 kinect.setMirror(false);

 //Open the serial port
 String portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port
 myPort = new Serial(this, portName, 9600);

}

public void draw() {
  kinect.update();
 //image(kinect.depthImage(), 0, 0);
 //image(kinect.irImage(),kinect.depthWidth(),0);
 image(kinect.userImage(),0,0);


  IntVector userList = new IntVector();
  kinect.getUsers(userList);

  if (userList.size() > 0) {

    int userId = userList.get(0);

    //If we detect one user we have to draw it
    if ( kinect.isTrackingSkeleton(userId)) {

      drawSkeleton(userId);

      // get the positions of the three joints of our right arm
     PVector rightHand = new PVector();
     kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,rightHand);
     PVector rightElbow = new PVector();
     kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_ELBOW,rightElbow);
     PVector rightShoulder = new PVector();
     kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_SHOULDER,rightShoulder);
     // we need right hip to orient the shoulder angle
     PVector rightHip = new PVector();
     kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HIP,rightHip);

     // get the positions of the three joints of our left arm
     PVector leftHand = new PVector();
     kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,leftHand);
     PVector leftElbow = new PVector();
     kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_ELBOW,leftElbow);
     PVector leftShoulder = new PVector();
     kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_SHOULDER,leftShoulder);
     // we need left hip to orient the shoulder angle
     PVector leftHip = new PVector();
     kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HIP,leftHip);

     // reduce our joint vectors to two dimensions for right side
     PVector rightHand2D = new PVector(rightHand.x, rightHand.y);
     PVector rightElbow2D = new PVector(rightElbow.x, rightElbow.y);
     PVector rightShoulder2D = new PVector(rightShoulder.x,rightShoulder.y);
     PVector rightHip2D = new PVector(rightHip.x, rightHip.y);
     // calculate the axes against which we want to measure our angles
     PVector torsoOrientation = PVector.sub(rightShoulder2D, rightHip2D);
     PVector upperArmOrientation = PVector.sub(rightElbow2D, rightShoulder2D);

     // reduce our joint vectors to two dimensions for left side
     PVector leftHand2D = new PVector(leftHand.x, leftHand.y);
     PVector leftElbow2D = new PVector(leftElbow.x, leftElbow.y);
     PVector leftShoulder2D = new PVector(leftShoulder.x,leftShoulder.y);
     PVector leftHip2D = new PVector(leftHip.x, leftHip.y);
     // calculate the axes against which we want to measure our angles
     PVector torsoLOrientation = PVector.sub(leftShoulder2D, leftHip2D);
     PVector upperArmLOrientation = PVector.sub(leftElbow2D, leftShoulder2D);

     // calculate the angles between our joints for rightside
     float RightshoulderAngle = angleOf(rightElbow2D, rightShoulder2D, torsoOrientation);
     float RightelbowAngle = angleOf(rightHand2D,rightElbow2D,upperArmOrientation);
     // show the angles on the screen for debugging
     fill(0,250,0);
     scale(2);
     text("Right shoulder: " + PApplet.parseInt(RightshoulderAngle) + "\n" + " Right elbow: " + PApplet.parseInt(RightelbowAngle), 20, 20);

     // calculate the angles between our joints for leftside
     float LeftshoulderAngle = angleOf(leftElbow2D, leftShoulder2D, torsoLOrientation);
     float LeftelbowAngle = angleOf(leftHand2D,leftElbow2D,upperArmLOrientation);
     // show the angles on the screen for debugging
     fill(255,0,0);
     scale(2);
     text("Left shoulder: " + PApplet.parseInt(LeftshoulderAngle) + "\n" + " Left elbow: " + PApplet.parseInt(LeftelbowAngle), 20, 55);

     //Here I started to send information to the Arduino

       if (RightelbowAngle >= 50)
        {                           //if we clicked in the window
           myPort.write('1');         //send a 1
           println("1");
        } else
        {                           //otherwise
          myPort.write('0');          //send a 0
          println("0");
        }

        if (LeftelbowAngle >= 50)
        {                           //if we clicked in the window
           myPort.write("2");         //send a 2
           println("2");
        } else
        {                           //otherwise
          myPort.write("0_0");          //send a 0
          println("0_0");
        }

        // draw the center of mass
    if(kinect.getCoM(userId,com))
    {
      kinect.convertRealWorldToProjective(com,com2d);
      stroke(100,255,0);
      strokeWeight(3);
      beginShape(LINES);
        vertex(com2d.x,com2d.y - 5);
        vertex(com2d.x,com2d.y + 5);

        vertex(com2d.x - 5,com2d.y);
        vertex(com2d.x + 5,com2d.y);
      endShape();

      fill(0,255,100);
      text(Integer.toString(userId),com2d.x,com2d.y);
    }

    }

  }

}

//Draw the skeleton

public void drawSkeleton(int userId) {

 stroke(0);
 strokeWeight(5);

 kinect.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
 kinect.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_LEFT_HIP);

 noStroke();

 fill(255,0,0);
 drawJoint(userId, SimpleOpenNI.SKEL_HEAD);
 drawJoint(userId, SimpleOpenNI.SKEL_NECK);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_ELBOW);
 drawJoint(userId, SimpleOpenNI.SKEL_NECK);
 drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
 drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW);
 drawJoint(userId, SimpleOpenNI.SKEL_TORSO);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_KNEE);
 drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HIP);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_FOOT);
 drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_KNEE);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HIP);
 drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_FOOT);
 drawJoint(userId, SimpleOpenNI.SKEL_RIGHT_HAND);
 drawJoint(userId, SimpleOpenNI.SKEL_LEFT_HAND);
}

public void drawJoint(int userId, int jointID) {
 PVector joint = new PVector();

 float confidence = kinect.getJointPositionSkeleton(userId, jointID,
joint);
 if(confidence < 0.5f){
   return;
 }
 PVector convertedJoint = new PVector();
 kinect.convertRealWorldToProjective(joint, convertedJoint);
 ellipse(convertedJoint.x, convertedJoint.y, 5, 5);
}

//Generate the angle
 public float angleOf(PVector one, PVector two, PVector axis){
 PVector limb = PVector.sub(two, one);
 return degrees(PVector.angleBetween(limb, axis));
}

//Calibration not required

public void onNewUser(SimpleOpenNI kinect, int userID){
  println("Start skeleton tracking");
  kinect.startTrackingSkeleton(userID);
}

public void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}
  public void settings() {  size(640, 480); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Traking_Angle_LR_UP" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
