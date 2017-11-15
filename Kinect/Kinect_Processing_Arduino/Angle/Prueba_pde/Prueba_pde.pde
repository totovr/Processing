import SimpleOpenNI.*;
SimpleOpenNI kinect;

void setup() { 
 size(640, 480);
 
 kinect = new SimpleOpenNI(this);
 kinect.enableDepth();
 kinect.enableUser();// este cambia
 kinect.setMirror(true);
}

void draw() {
 kinect.update();
 
 PImage depth = kinect.depthImage();
 image(depth, 0, 0);
 IntVector userList = new IntVector();
 kinect.getUsers(userList);
 
 if (userList.size() > 0) {
   int userId = userList.get(0);
   if ( kinect.isTrackingSkeleton(userId)) {
     // get the positions of the three joints of our arm
     PVector rightHand = new PVector();
     kinect.getJointPositionSkeleton(userId,
     SimpleOpenNI.SKEL_RIGHT_HAND,
     rightHand);
     PVector rightElbow = new PVector();
     kinect.getJointPositionSkeleton(userId,
     SimpleOpenNI.SKEL_RIGHT_ELBOW,
     rightElbow);
     PVector rightShoulder = new PVector();
     kinect.getJointPositionSkeleton(userId,
     SimpleOpenNI.SKEL_RIGHT_SHOULDER,
     rightShoulder);
     // we need right hip to orient the shoulder angle
     PVector rightHip = new PVector();
     kinect.getJointPositionSkeleton(userId,
     SimpleOpenNI.SKEL_RIGHT_HIP,
     rightHip);
     // reduce our joint vectors to two dimensions
     PVector rightHand2D = new PVector(rightHand.x, rightHand.y); 
     PVector rightElbow2D = new PVector(rightElbow.x, rightElbow.y);
     PVector rightShoulder2D = new PVector(rightShoulder.x,
     rightShoulder.y);
     PVector rightHip2D = new PVector(rightHip.x, rightHip.y);
     // calculate the axes against which we want to measure our angles
     PVector torsoOrientation =
     PVector.sub(rightShoulder2D, rightHip2D); 
     PVector upperArmOrientation =
     PVector.sub(rightElbow2D, rightShoulder2D);
     
     // calculate the angles between our joints
     float shoulderAngle = angleOf(rightElbow2D, 
     rightShoulder2D,
     torsoOrientation);
     float elbowAngle = angleOf(rightHand2D,
     rightElbow2D,
     upperArmOrientation);
     // show the angles on the screen for debugging
     fill(255,0,0);
     scale(3);
     text("shoulder: " + int(shoulderAngle) + "\n" +
     " elbow: " + int(elbowAngle), 20, 20);
    }
  }
}

float angleOf(PVector one, PVector two, PVector axis){
 PVector limb = PVector.sub(two, one);
 return degrees(PVector.angleBetween(limb, axis));
}
// user-tracking callbacks!

void onNewUser(SimpleOpenNI kinect, int userID){
  println("Start skeleton tracking");
  kinect.startTrackingSkeleton(userID);
}

