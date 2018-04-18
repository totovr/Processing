// import kinect library
import SimpleOpenNI.*;

// create kinect object
SimpleOpenNI kinect;
// image storage from kinect
PImage kinectDepth;
// int of each user being tracked
int[] userID;
// user colors
color[] userColor = new color[]{ color(255,0,0), color(0,255,0), color(0,0,255),
 color(255,255,0), color(255,0,255), color(0,255,255)};

// postion of head to draw circle
PVector headPosition = new PVector();
// turn headPosition into scalar form
float distanceScalar;
// diameter of head drawn in pixels
float headSize = 200;

// threshold of level of confidence
float confidenceLevel = 0.9;
// the current confidence level that the kinect is tracking
float confidence;
// vector of tracked head for confidence checking
PVector confidenceVector = new PVector();
// vector to scalar ratio
float vectorScalar = 525;
// size of drawn dot on each jpint
float dotSize = 30;

// Vector values for all joints
PVector SKEL_HEAD = new PVector();
PVector SKEL_LEFT_SHOULDER = new PVector();
PVector SKEL_LEFT_ELBOW = new PVector();
PVector SKEL_LEFT_HAND = new PVector();
PVector SKEL_RIGHT_SHOULDER = new PVector();
PVector SKEL_RIGHT_ELBOW = new PVector();
PVector SKEL_RIGHT_HAND = new PVector();
PVector SKEL_TORSO = new PVector();
PVector SKEL_LEFT_HIP = new PVector();
PVector SKEL_LEFT_KNEE = new PVector();
PVector SKEL_LEFT_FOOT = new PVector();
PVector SKEL_RIGHT_HIP = new PVector();
PVector SKEL_RIGHT_KNEE = new PVector();
PVector SKEL_RIGHT_FOOT = new PVector();

// z coordinates of each limb
float SKEL_HEADZ;
float SKEL_LEFT_SHOULDERZ;
float SKEL_LEFT_ELBOWZ;
float SKEL_LEFT_HANDZ;
float SKEL_RIGHT_SHOULDERZ;
float SKEL_RIGHT_ELBOWZ;
float SKEL_RIGHT_HANDZ;
float SKEL_TORSOZ;
float SKEL_LEFT_HIPZ;
float SKEL_LEFT_KNEEZ;
float SKEL_LEFT_FOOTZ;
float SKEL_RIGHT_HIPZ;
float SKEL_RIGHT_KNEEZ;
float SKEL_RIGHT_FOOTZ;

// angle variables
float leftShoulderElbowX;
float leftShoulderElbowY;
float leftShoulderElbowZ;
float leftWristElbowX;
float leftWristElbowY;
float leftWristElbowZ;

float rightShoulderElbowX;
float rightShoulderElbowY;
float rightShoulderElbowZ;
float rightWristElbowX;
float rightWristElbowY;
float rightWristElbowZ;

float leftHipKneeX;
float leftHipKneeY;
float leftHipKneeZ;
float leftFootKneeX;
float leftFootKneeY;
float leftFootKneeZ;

float rightHipKneeX;
float rightHipKneeY;
float rightHipKneeZ;
float rightFootKneeX;
float rightFootKneeY;
float rightFootKneeZ;

// actual angles in radians of knees and elbows
float leftElbowAngle;
float rightElbowAngle;
float leftKneeAngle;
float rightKneeAngle;

/*---------------------------------------------------------------
Starts new kinect object and enables skeleton tracking.
Draws window
----------------------------------------------------------------*/
void setup()
{
 // start a new kinect object
 kinect = new SimpleOpenNI(this);

 // enable depth sensor
 kinect.enableDepth();

 // enable skeleton generation for all joints
 kinect.enableUser();

 // thickness of drawer
 strokeWeight(3);
 // smooth out drawing
 smooth();

 // create a window the size of the depth information
 size(640, 480);
} // void setup()

/*---------------------------------------------------------------
Updates Kinect. Gets users tracking and draws skeleton and
head if confidence of tracking is above threshold
----------------------------------------------------------------*/
void draw(){
 // update the camera
 kinect.update();
 // get Kinect data
 kinectDepth = kinect.depthImage();
 // draw depth image at coordinates (0,0)
 image(kinectDepth,0,0);

 // get all user IDs of tracked users
 userID = kinect.getUsers();

 // loop through each user to see if tracking
 for(int i=0;i<userID.length;i++)
 {
 // if Kinect is tracking certain user then get joint vectors
 if(kinect.isTrackingSkeleton(userID[i]))
 {
 // get confidence level that Kinect is tracking head
 confidence = kinect.getJointPositionSkeleton(userID[i], SimpleOpenNI.SKEL_HEAD,confidenceVector);

 // if confidence of tracking is beyond threshold, then track user
 if(confidence > confidenceLevel)
 {
 // change draw color based on hand id#
 stroke(userColor[(i)]);
 // fill the ellipse with the same color
 fill(userColor[(i)]);
 // get coordinates of all joints
 getCoordinates(userID[i]);
 // subtract vectors of limbs
 subtractVectors();
 // get angles of joints
 getJointAngles();
 } //if(confidence > confidenceLevel)
 } //if(kinect.isTrackingSkeleton(userID[i]))
 } //for(int i=0;i<userID.length;i++)
} // void draw()

/*---------------------------------------------------------------
When a new user is found, print new user detected along with
userID and start pose detection. Input is userID
----------------------------------------------------------------*/
void onNewUser(SimpleOpenNI curContext, int userId){
 println("New User Detected - userId: " + userId);
 // start tracking of user id
 curContext.startTrackingSkeleton(userId);
} //void onNewUser(SimpleOpenNI curContext, int userId)

/*---------------------------------------------------------------
Print when user is lost. Input is int userId of user lost
----------------------------------------------------------------*/
void onLostUser(SimpleOpenNI curContext, int userId){
 // print user lost and user id
 println("User Lost - userId: " + userId);
} //void onLostUser(SimpleOpenNI curContext, int userId)

/*---------------------------------------------------------------
Called when a user is tracked.
----------------------------------------------------------------*/
void onVisibleUser(SimpleOpenNI curContext, int userId){
} //void onVisibleUser(SimpleOpenNI curContext, int userId)

/*---------------------------------------------------------------
Gets XYZ coordinates of all joints of tracked user and draws
a small circle on each joint
----------------------------------------------------------------*/
void getCoordinates(int userID)
{
 // get position of all joints
 kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_HEAD,SKEL_HEAD);
 kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_LEFT_SHOULDER,SKEL_LEFT_SHOULDER);
 kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_LEFT_ELBOW,SKEL_LEFT_ELBOW);
 kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_LEFT_HAND,SKEL_LEFT_HAND);
 kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_RIGHT_SHOULDER,SKEL_RIGHT_SHOULDER);
 kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_RIGHT_ELBOW,SKEL_RIGHT_ELBOW);
 kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_RIGHT_HAND,SKEL_RIGHT_HAND);
 kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_TORSO,SKEL_TORSO);
 kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_LEFT_HIP,SKEL_LEFT_HIP);
 kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_LEFT_KNEE,SKEL_LEFT_KNEE);
 kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_LEFT_FOOT,SKEL_LEFT_FOOT);
 kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_RIGHT_HIP,SKEL_RIGHT_HIP);
 kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_RIGHT_KNEE,SKEL_RIGHT_KNEE);
 kinect.getJointPositionSkeleton(userID, SimpleOpenNI.SKEL_RIGHT_FOOT,SKEL_RIGHT_FOOT);

 // convert real world point to projective space
 kinect.convertRealWorldToProjective(SKEL_HEAD, SKEL_HEAD);
 kinect.convertRealWorldToProjective(SKEL_LEFT_SHOULDER, SKEL_LEFT_SHOULDER);
 kinect.convertRealWorldToProjective(SKEL_LEFT_ELBOW, SKEL_LEFT_ELBOW);
 kinect.convertRealWorldToProjective(SKEL_LEFT_HAND, SKEL_LEFT_HAND);
 kinect.convertRealWorldToProjective(SKEL_RIGHT_SHOULDER, SKEL_RIGHT_SHOULDER);
 kinect.convertRealWorldToProjective(SKEL_RIGHT_ELBOW, SKEL_RIGHT_ELBOW);
 kinect.convertRealWorldToProjective(SKEL_RIGHT_HAND, SKEL_RIGHT_HAND);
 kinect.convertRealWorldToProjective(SKEL_TORSO, SKEL_TORSO);
 kinect.convertRealWorldToProjective(SKEL_LEFT_HIP, SKEL_LEFT_HIP);
 kinect.convertRealWorldToProjective(SKEL_LEFT_KNEE, SKEL_LEFT_KNEE);
 kinect.convertRealWorldToProjective(SKEL_LEFT_FOOT, SKEL_LEFT_FOOT);
 kinect.convertRealWorldToProjective(SKEL_RIGHT_HIP, SKEL_RIGHT_HIP);
 kinect.convertRealWorldToProjective(SKEL_RIGHT_KNEE, SKEL_RIGHT_KNEE);
 kinect.convertRealWorldToProjective(SKEL_RIGHT_FOOT, SKEL_RIGHT_FOOT);

 // scale z vector of each joint to scalar form
 SKEL_HEADZ = (vectorScalar/SKEL_HEAD.z);
 SKEL_LEFT_SHOULDERZ = (vectorScalar/SKEL_LEFT_SHOULDER.z);
 SKEL_LEFT_ELBOWZ = (vectorScalar/SKEL_LEFT_ELBOW.z);
 SKEL_LEFT_HANDZ = (vectorScalar/SKEL_LEFT_HAND.z);
 SKEL_RIGHT_SHOULDERZ = (vectorScalar/SKEL_RIGHT_SHOULDER.z);
 SKEL_RIGHT_ELBOWZ = (vectorScalar/SKEL_RIGHT_ELBOW.z);
 SKEL_RIGHT_HANDZ = (vectorScalar/SKEL_RIGHT_HAND.z);
 SKEL_TORSOZ = (vectorScalar/SKEL_TORSO.z);
 SKEL_LEFT_HIPZ = (vectorScalar/SKEL_LEFT_HIP.z);
 SKEL_LEFT_KNEEZ = (vectorScalar/SKEL_LEFT_KNEE.z);
 SKEL_LEFT_FOOTZ = (vectorScalar/SKEL_LEFT_FOOT.z);
 SKEL_RIGHT_HIPZ = (vectorScalar/SKEL_RIGHT_HIP.z);
 SKEL_RIGHT_KNEEZ = (vectorScalar/SKEL_RIGHT_KNEE.z);
 SKEL_RIGHT_FOOTZ = (vectorScalar/SKEL_RIGHT_FOOT.z);

 // fill the dot color by the user id
 fill(userColor[userID-1]);

 // draw the circle at the position of the joint with the
 // diameter dependent on the z axis
 ellipse(SKEL_HEAD.x,SKEL_HEAD.y, SKEL_HEADZ*dotSize, SKEL_HEADZ*dotSize);
 ellipse(SKEL_LEFT_SHOULDER.x,SKEL_LEFT_SHOULDER.y, SKEL_LEFT_SHOULDERZ*dotSize, SKEL_LEFT_SHOULDERZ*dotSize);
 ellipse(SKEL_LEFT_ELBOW.x,SKEL_LEFT_ELBOW.y, SKEL_LEFT_ELBOWZ*dotSize,SKEL_LEFT_ELBOWZ *dotSize);
 ellipse(SKEL_LEFT_HAND.x,SKEL_LEFT_HAND.y, SKEL_LEFT_HANDZ*dotSize, SKEL_LEFT_HANDZ*dotSize);
 ellipse(SKEL_RIGHT_SHOULDER.x,SKEL_RIGHT_SHOULDER.y, SKEL_RIGHT_SHOULDERZ*dotSize, SKEL_RIGHT_SHOULDERZ*dotSize);
 ellipse(SKEL_RIGHT_ELBOW.x,SKEL_RIGHT_ELBOW.y, SKEL_RIGHT_ELBOWZ*dotSize, SKEL_RIGHT_ELBOWZ*dotSize);
 ellipse(SKEL_RIGHT_HAND.x,SKEL_RIGHT_HAND.y, SKEL_RIGHT_HANDZ*dotSize, SKEL_RIGHT_HANDZ*dotSize);
 ellipse(SKEL_TORSO.x,SKEL_TORSO.y, SKEL_TORSOZ*dotSize, SKEL_TORSOZ*dotSize);
 ellipse(SKEL_LEFT_HIP.x,SKEL_LEFT_HIP.y, SKEL_LEFT_HIPZ*dotSize, SKEL_LEFT_HIPZ*dotSize);
 ellipse(SKEL_LEFT_KNEE.x,SKEL_LEFT_KNEE.y, SKEL_LEFT_KNEEZ*dotSize, SKEL_LEFT_KNEEZ*dotSize);
 ellipse(SKEL_LEFT_FOOT.x,SKEL_LEFT_FOOT.y, SKEL_LEFT_FOOTZ*dotSize, SKEL_LEFT_FOOTZ*dotSize);
 ellipse(SKEL_RIGHT_HIP.x,SKEL_RIGHT_HIP.y, SKEL_RIGHT_HIPZ*dotSize, SKEL_RIGHT_HIPZ*dotSize);
 ellipse(SKEL_RIGHT_KNEE.x,SKEL_RIGHT_KNEE.y, SKEL_RIGHT_KNEEZ*dotSize, SKEL_RIGHT_KNEEZ*dotSize);
 ellipse(SKEL_RIGHT_FOOT.x,SKEL_RIGHT_FOOT.y, SKEL_RIGHT_FOOTZ*dotSize, SKEL_RIGHT_FOOTZ*dotSize);
} // void getCoordinates()
/*---------------------------------------------------------------
Subtracts each vector from each limb combination from each other
----------------------------------------------------------------*/
void subtractVectors() {
 // take vector[] shoulder and subtract from vector[] elbow
 leftShoulderElbowX = SKEL_LEFT_SHOULDER.x - SKEL_LEFT_ELBOW.x;
 leftShoulderElbowY = SKEL_LEFT_SHOULDER.y - SKEL_LEFT_ELBOW.y;
 leftShoulderElbowZ = SKEL_LEFT_SHOULDER.z - SKEL_LEFT_ELBOW.z;
 // take vector[] hand and subtract from vector[] elbow
 leftWristElbowX = SKEL_LEFT_HAND.x - SKEL_LEFT_ELBOW.x;
 leftWristElbowY = SKEL_LEFT_HAND.y - SKEL_LEFT_ELBOW.y;
 leftWristElbowZ = SKEL_LEFT_HAND.z - SKEL_LEFT_ELBOW.z;
 // take vector[] shoulder and subtract from vector[] elbow
 rightShoulderElbowX = SKEL_RIGHT_SHOULDER.x - SKEL_RIGHT_ELBOW.x;
 rightShoulderElbowY = SKEL_RIGHT_SHOULDER.y - SKEL_RIGHT_ELBOW.y;
 rightShoulderElbowZ = SKEL_RIGHT_SHOULDER.z - SKEL_RIGHT_ELBOW.z;
 // take vector[] hand and subtract from vector[] elbow
 rightWristElbowX = SKEL_RIGHT_HAND.x - SKEL_RIGHT_ELBOW.x;
 rightWristElbowY = SKEL_RIGHT_HAND.y - SKEL_RIGHT_ELBOW.y;
 rightWristElbowZ = SKEL_RIGHT_HAND.z - SKEL_RIGHT_ELBOW.z;

 // take vector[] hip and subtract from vector[] knee
 leftHipKneeX = SKEL_LEFT_HIP.x - SKEL_LEFT_KNEE.x;
 leftHipKneeY = SKEL_LEFT_HIP.y - SKEL_LEFT_KNEE.y;
 leftHipKneeZ = SKEL_LEFT_HIP.z - SKEL_LEFT_KNEE.z;
 // take vector[] foot and subtract from vector[] knee
 leftFootKneeX = SKEL_LEFT_FOOT.x - SKEL_LEFT_KNEE.x;
 leftFootKneeY = SKEL_LEFT_FOOT.y - SKEL_LEFT_KNEE.y;
 leftFootKneeZ = SKEL_LEFT_FOOT.z - SKEL_LEFT_KNEE.z;
 // take vector[] hip and subtract from vector[] knee
 rightHipKneeX = SKEL_RIGHT_HIP.x - SKEL_RIGHT_KNEE.x;
 rightHipKneeY = SKEL_RIGHT_HIP.y - SKEL_RIGHT_KNEE.y;
 rightHipKneeZ = SKEL_RIGHT_HIP.z - SKEL_RIGHT_KNEE.z;
 // take vector[] foot and subtract from vector[] knee
 rightFootKneeX = SKEL_RIGHT_FOOT.x - SKEL_RIGHT_KNEE.x;
 rightFootKneeY = SKEL_RIGHT_FOOT.y - SKEL_RIGHT_KNEE.y;
 rightFootKneeZ = SKEL_RIGHT_FOOT.z - SKEL_RIGHT_KNEE.z;
} // void subtractVectors()

/*---------------------------------------------------------------
Gets angles of joints based on Z axis and prints them.
Example math:

Let the coordinates of elbow (x,y,z) be denoted as E,
shoulder S, and wrist W.

Define the vector EW = W - E = (x_w-x_e, y_w-y_e, z_w,z_e)
and ES = S - E.

Then the angle between vector EW and vector ES is given
by arccos(EW dot ES / (mag(EW) * mag (ES)).

Where mag(X) is the magnitude of a vector, given by
sqrt(x2 + y2 + z2 ), and

A dot B is the dot product of
vectors A and B, given by A_x*B_x + A_y*B_y + A_z*B_z
----------------------------------------------------------------*/
void getJointAngles() {
 leftElbowAngle = acos((leftShoulderElbowX
 *leftWristElbowX+leftShoulderElbowY
 *leftWristElbowY+leftShoulderElbowZ
 *leftWristElbowZ)/(sqrt(leftWristElbowX
 *leftWristElbowX+leftWristElbowY
 *leftWristElbowY+leftWristElbowZ*leftWristElbowZ)
 *(sqrt(leftShoulderElbowX*leftShoulderElbowX
 +leftShoulderElbowY*leftShoulderElbowY
 +leftShoulderElbowZ*leftShoulderElbowZ))));

 rightElbowAngle = acos((rightShoulderElbowX
 *rightWristElbowX+rightShoulderElbowY
 *rightWristElbowY+rightShoulderElbowZ*
 rightWristElbowZ)/(sqrt(rightWristElbowX
 *rightWristElbowX+rightWristElbowY*
 rightWristElbowY+rightWristElbowZ*rightWristElbowZ)
 *(sqrt(rightShoulderElbowX*rightShoulderElbowX
 +rightShoulderElbowY*rightShoulderElbowY
 +rightShoulderElbowZ*rightShoulderElbowZ))));

 leftKneeAngle = acos((leftHipKneeX
 *leftFootKneeX+leftHipKneeY
 *leftFootKneeY+leftHipKneeZ
 *leftFootKneeZ)/(sqrt(leftFootKneeX
 *leftFootKneeX+leftFootKneeY
 *leftFootKneeY+leftFootKneeZ*leftFootKneeZ)
 *(sqrt(leftHipKneeX*leftHipKneeX
 +leftHipKneeY*leftHipKneeY
 +leftHipKneeZ*leftHipKneeZ))));

 rightKneeAngle = acos((rightHipKneeX
 *rightFootKneeX+rightHipKneeY
 *rightFootKneeY+rightHipKneeZ
 *rightFootKneeZ)/(sqrt(rightFootKneeX
 *rightFootKneeX+rightFootKneeY
 *rightFootKneeY+rightFootKneeZ*rightFootKneeZ)
 *(sqrt(rightHipKneeX*rightHipKneeX
 +rightHipKneeY*rightHipKneeY
 +rightHipKneeZ*rightHipKneeZ))));

 // print angles
 print("Left elbow angle: ");
 println(leftElbowAngle);
 print("Right elbow angle: ");
 println(rightElbowAngle);
 print("Left knee angle: ");
 println(leftKneeAngle);
 print("Right knee angle: ");
 println(rightKneeAngle);
} // void getJointAngles()
