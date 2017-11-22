import SimpleOpenNI.*;
SimpleOpenNI kinect;

void setup() {
 kinect = new SimpleOpenNI(this);
 kinect.enableDepth();
 kinect.enableUser();// este cambia
 size(640, 480);
 fill(255, 0, 0);
 kinect.setMirror(true);
}

void draw() {  
  kinect.update();
  image(kinect.depthImage(), 0, 0);
 
  IntVector userList = new IntVector();
  kinect.getUsers(userList);
 
  if (userList.size() > 0) {
    
    int userId = userList.get(0);
    
    //If we detect one user we have to draw it
    if ( kinect.isTrackingSkeleton(userId)) {
    
      drawSkeleton(userId);
      
      // get the positions of the three joints of our arm
     PVector rightHand = new PVector();
     kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,rightHand);
     PVector rightElbow = new PVector();
     kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_ELBOW,rightElbow);
     PVector rightShoulder = new PVector();
     kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_SHOULDER,rightShoulder);
     // we need right hip to orient the shoulder angle
     PVector rightHip = new PVector();
     kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HIP,rightHip);
     
     // reduce our joint vectors to two dimensions
     PVector rightHand2D = new PVector(rightHand.x, rightHand.y); 
     PVector rightElbow2D = new PVector(rightElbow.x, rightElbow.y);
     PVector rightShoulder2D = new PVector(rightShoulder.x,rightShoulder.y);
     PVector rightHip2D = new PVector(rightHip.x, rightHip.y);
     // calculate the axes against which we want to measure our angles
     PVector torsoOrientation = PVector.sub(rightShoulder2D, rightHip2D); 
     PVector upperArmOrientation = PVector.sub(rightElbow2D, rightShoulder2D);
     
     // calculate the angles between our joints
     float shoulderAngle = angleOf(rightElbow2D, rightShoulder2D, torsoOrientation);
     float elbowAngle = angleOf(rightHand2D,rightElbow2D,upperArmOrientation);
     // show the angles on the screen for debugging
     fill(255,0,0);
     scale(3);
     text("shoulder: " + int(shoulderAngle) + "\n" + " elbow: " + int(elbowAngle), 20, 20);
    
    }
  
  }

}

void drawSkeleton(int userId) {
 
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

void drawJoint(int userId, int jointID) { 
 PVector joint = new PVector();
 
 float confidence = kinect.getJointPositionSkeleton(userId, jointID,
joint);
 if(confidence < 0.5){
   return; 
 }
 PVector convertedJoint = new PVector();
 kinect.convertRealWorldToProjective(joint, convertedJoint);
 ellipse(convertedJoint.x, convertedJoint.y, 5, 5);
}

//Generate the angle
float angleOf(PVector one, PVector two, PVector axis){
 PVector limb = PVector.sub(two, one);
 return degrees(PVector.angleBetween(limb, axis));
}

//Calibration not required

void onNewUser(SimpleOpenNI kinect, int userID){
  println("Start skeleton tracking");
  kinect.startTrackingSkeleton(userID);
}
