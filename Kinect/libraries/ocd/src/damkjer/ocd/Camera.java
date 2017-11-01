package damkjer.ocd;

import java.awt.event.*;
import processing.core.*;

/**
 * Class:       Camera
 *
 * Description: Data Type for manipulating the Processing viewport. There are
 *              several ways to create a Camera, but all cameras are
 *              manipulated the same way.
 *
 * Defaults:    Camera position     - sits on the positive z-axis
 *              Target position     - located at the world origin
 *              Up direction        - point in the negative y
 *              Field-of-view       - PI/3 radians (60 degrees)
 *              Aspect ratio        - Applet width to applet height
 *              Near clipping plane - 0.1x shot length.
 *              Far clipping plane  - 10x the shot length.
 *
 * @author  Kristian Linn Damkjer
 * @version OCD 1.4
 * @version Processing 0135
 * @since   OCD 1.0
 * @since   Processing 0087
 */ 
public class Camera
{
   //--- Class Attributes ----
   private static final float TWO_PI      = (float)(2.0 * Math.PI);
   private static final float PI          = (float) Math.PI;
   private static final float HALF_PI     = (float)(Math.PI * 0.5);
   private static final float TOL         = 0.00001f;
   private static final float DEFAULT_FOV = (float) (PI / 3.0);

   //--- Attributes ----------
   private PApplet theParent;

   // Camera Orientation Information
   private float theAzimuth;
   private float theElevation;
   private float theRoll;

   // Camera Position
   private float theCameraX;
   private float theCameraY;
   private float theCameraZ;
   
   // Target Position
   private float theTargetX;
   private float theTargetY;
   private float theTargetZ;

   // Up Vector
   private float theUpX;
   private float theUpY;
   private float theUpZ;

   // Field of View
   private float theFoV;

   // Aspect Ratio
   private float theAspect;

   // Clip Planes
   private float theNearClip;
   private float theFarClip;

   // The length of the view vector
   private float theShotLength;

   // Distance differences between camera and target
   private float theDeltaX;
   private float theDeltaY;
   private float theDeltaZ;

   //--- Constructors --------

   // Create a camera that sits on the z axis
   public Camera(PApplet aParent)
   {
      this(aParent,
           aParent.height * 0.5f / tan(DEFAULT_FOV * 0.5f));
   }

   // Create a camera that sits on the z axis with a specified shot length
   public Camera(PApplet aParent,
                 float   aShotLength)
   {
      this(aParent,
           0, 0, aShotLength);
   }

   // Create a camera at the specified location looking at the world origin
   public Camera(PApplet aParent,
                 float   aCameraX, float aCameraY, float aCameraZ)
   {
      this(aParent,
           aCameraX, aCameraY, aCameraZ,
                  0,        0,        0);
   }

   // Create a camera at the specified location with the specified target
   public Camera(PApplet aParent,
                 float aCameraX, float aCameraY, float aCameraZ,
                 float aTargetX, float aTargetY, float aTargetZ)
   {
      this(aParent,
           aCameraX, aCameraY, aCameraZ,
           aTargetX, aTargetY, aTargetZ,
                  0,        1,        0);
   }

   // Create a camera at the specified location with the specified target and
   // up direction
   public Camera(PApplet aParent,
                 float aCameraX, float aCameraY, float aCameraZ,
                 float aTargetX, float aTargetY, float aTargetZ,
                 float anUpX,    float anUpY,    float anUpZ)
   {
      this(aParent,
           aCameraX, aCameraY, aCameraZ,
           aTargetX, aTargetY, aTargetZ,
              anUpX,    anUpY,    anUpZ,
           DEFAULT_FOV, (float)(1f * aParent.width / aParent.height), 0, 0);

      theNearClip = theShotLength * 0.1f;
      theFarClip  = theShotLength * 10f;
   }

   // Create a camera with the specified frustum
   public Camera(PApplet aParent,
                 float anFoV, float anAspect, float aNearClip, float aFarClip)
   {
      this(aParent,
           0, 0, aParent.height * 0.5f / tan(anFoV * 0.5f),
           anFoV, anAspect, aNearClip, aFarClip);
   }

   // Create a camera at the specified location with the specified frustum
   public Camera(PApplet aParent,
                 float aCameraX, float aCameraY, float aCameraZ,
                 float anFoV, float anAspect, float aNearClip, float aFarClip)
   {
      this(aParent,
           aCameraX, aCameraY, aCameraZ,
                  0,        0,        0,
           anFoV, anAspect, aNearClip, aFarClip);
   }

   // Create a camera at the specified location with the specified target and
   // frustum
   public Camera(PApplet aParent,
                 float aCameraX, float aCameraY, float aCameraZ,
                 float aTargetX, float aTargetY, float aTargetZ,
                 float anFoV, float anAspect, float aNearClip, float aFarClip)
   {
      this(aParent,
           aCameraX, aCameraY, aCameraZ,
           aTargetX, aTargetY, aTargetZ,
                  0,        1,        0,
           anFoV, anAspect, aNearClip, aFarClip);
   }

   // Create a camera with a near and far clip plane
   public Camera (PApplet aParent,
                  float aNearClip, float aFarClip)
   {
      this(aParent,
           0, 0, aParent.height * 0.5f / tan(DEFAULT_FOV * 0.5f),
           aNearClip, aFarClip);
   }

   // Create a camera at the specified location with a near and far clip plane
   public Camera (PApplet aParent,
                 float aCameraX, float aCameraY, float aCameraZ,
                 float aNearClip, float aFarClip)
   {
      this(aParent,
           aCameraX, aCameraY, aCameraZ,
                  0,        0,        0,
           aNearClip, aFarClip);
   }

   // Create a camera at the specified location with the specified target
   // and a near and far clip plane
   public Camera (PApplet aParent,
                 float aCameraX, float aCameraY, float aCameraZ,
                 float aTargetX, float aTargetY, float aTargetZ,
                 float aNearClip, float aFarClip)
   {
      this(aParent,
           aCameraX, aCameraY, aCameraZ,
           aTargetX, aTargetY, aTargetZ,
                  0,        1,        0,
           aNearClip, aFarClip);
   }

   // Create a camera at the specified location with the specified target
   // , up direction, near and far clip plane
   public Camera(PApplet aParent,
                 float aCameraX, float aCameraY, float aCameraZ,
                 float aTargetX, float aTargetY, float aTargetZ,
                 float anUpX,    float anUpY,    float anUpZ,
                 float aNearClip, float aFarClip)
   {
      this(aParent,
           aCameraX, aCameraY, aCameraZ,
           aTargetX, aTargetY, aTargetZ,
           anUpX,    anUpY,    anUpZ,
           DEFAULT_FOV, aNearClip, aFarClip);
   }

   // Specify all parameters except the aspect ratio.
   public Camera(PApplet aParent,
                 float aCameraX, float aCameraY, float aCameraZ,
                 float aTargetX, float aTargetY, float aTargetZ,
                 float anUpX,    float anUpY,    float anUpZ,
                 float anFoV, float aNearClip, float aFarClip)
   {
      this(aParent,
           aCameraX, aCameraY, aCameraZ,
           aTargetX, aTargetY, aTargetZ,
           anUpX,    anUpY,    anUpZ,
           anFoV, (float)(1f * aParent.width / aParent.height), aNearClip, aFarClip);
   }

   // Specify all parameters for camera creation
   public Camera(PApplet aParent,
                 float aCameraX, float aCameraY, float aCameraZ,
                 float aTargetX, float aTargetY, float aTargetZ,
                 float anUpX,    float anUpY,    float anUpZ,
                 float anFoV, float anAspect, float aNearClip, float aFarClip)
   {
      theParent   = aParent;
      theCameraX  = aCameraX;
      theCameraY  = aCameraY;
      theCameraZ  = aCameraZ;
      theTargetX  = aTargetX;
      theTargetY  = aTargetY;
      theTargetZ  = aTargetZ;
      theUpX      = anUpX;
      theUpY      = anUpY;
      theUpZ      = anUpZ;
      theFoV      = anFoV;
      theAspect   = anAspect;
      theNearClip = aNearClip;
      theFarClip  = aFarClip;

      theDeltaX   = theCameraX - theTargetX;
      theDeltaY   = theCameraY - theTargetY;
      theDeltaZ   = theCameraZ - theTargetZ;

      theShotLength = magnitude(theDeltaX, theDeltaY, theDeltaZ);

      theAzimuth    = atan2(theDeltaX,
                            theDeltaZ);
      theElevation  = atan2(theDeltaY,
                            sqrt(theDeltaZ * theDeltaZ +
	             theDeltaX * theDeltaX));

      if (theElevation > HALF_PI - TOL)
      {
         theUpY =  0;
         theUpZ = -1;
      }     

      if (theElevation < TOL - HALF_PI)
      {
         theUpY =  0;
         theUpZ =  1;
      }

      updateUp();
   }

   //--- Behaviors ----------

   /** Send what this camera sees to the view port */
   public void feed() {
      theParent.perspective(theFoV, theAspect, theNearClip, theFarClip);
      theParent.camera(theCameraX, theCameraY, theCameraZ,
                       theTargetX, theTargetY, theTargetZ,
                       theUpX,     theUpY,     theUpZ);
   }

   /** Aim the camera at the specified target */
   public void aim(float aTargetX, float aTargetY, float aTargetZ)
   {
      // Move the target
      theTargetX = aTargetX;
      theTargetY = aTargetY;
      theTargetZ = aTargetZ;

      updateDeltas();
   }

   /** Jump the camera to the specified position */
   public void jump(float positionX, float positionY, float positionZ)
   {
      // Move the camera
      theCameraX = positionX;
      theCameraY = positionY;
      theCameraZ = positionZ;

      updateDeltas();
   }

   /** Change the field of view between "fish-eye" and "close-up" */
   public void zoom(float anAmount)
   {
      theFoV = constrain(theFoV + anAmount, TOL, PI - TOL);
   }

   /** Move the camera and target simultaneously along the camera's X axis */
   public void truck(float anAmount)
   {
      // Calculate the camera's X axis in world space
      float directionX = theDeltaY * theUpZ - theDeltaZ * theUpY;
      float directionY = theDeltaX * theUpZ - theDeltaZ * theUpX;
      float directionZ = theDeltaX * theUpY - theDeltaY * theUpX;
      
      // Normalize this vector so that it can be scaled
      float magnitude = magnitude(directionX, directionY, directionZ);

      directionX /= magnitude;
      directionY /= magnitude;
      directionZ /= magnitude;
      
      // Perform the truck, if any
      theCameraX -= anAmount * directionX;
      theCameraY -= anAmount * directionY;
      theCameraZ -= anAmount * directionZ;
      theTargetX -= anAmount * directionX;
      theTargetY -= anAmount * directionY;
      theTargetZ -= anAmount * directionZ;
   }

   /** Move the camera and target simultaneously along the camera's Y axis */
   public void boom(float anAmount)
   {
      // Perform the boom, if any
      theCameraX += anAmount * theUpX;
      theCameraY += anAmount * theUpY;
      theCameraZ += anAmount * theUpZ;
      theTargetX += anAmount * theUpX;
      theTargetY += anAmount * theUpY;
      theTargetZ += anAmount * theUpZ;
   }

   /** Move the camera and target along the view vector */
   public void dolly(float anAmount)
   {
      // Normalize the view vector
      float directionX = theDeltaX / theShotLength;
      float directionY = theDeltaY / theShotLength;
      float directionZ = theDeltaZ / theShotLength;

      // Perform the dolly, if any
      theCameraX += anAmount * directionX;
      theCameraY += anAmount * directionY;
      theCameraZ += anAmount * directionZ;
      theTargetX += anAmount * directionX;
      theTargetY += anAmount * directionY;
      theTargetZ += anAmount * directionZ;
   }

   /** Rotate the camera about its X axis */
   public void tilt(float anElevationOffset)
   {
      // Calculate the new elevation for the camera
      theElevation = constrain(theElevation - anElevationOffset,
                               TOL-HALF_PI, HALF_PI-TOL);

      // Update the target
      updateTarget();
   }

   /** Rotate the camera about its Y axis */
   public void pan(float anAzimuthOffset)
   {
      // Calculate the new azimuth for the camera
      theAzimuth = (theAzimuth - anAzimuthOffset + TWO_PI) % TWO_PI;

      // Update the target
      updateTarget();
   }

   /** Rotate the camera about its Z axis */
   public void roll(float aRollOffset)
   {
       // Change the roll amount
       theRoll = (theRoll + aRollOffset + TWO_PI) % TWO_PI;
        
       // Update the up vector
       updateUp();
   }

   /** Arc the camera over (under) a center of interest along a set azimuth*/
   public void arc(float anElevationOffset)
   {
      // Calculate the new elevation for the camera
      theElevation = constrain(theElevation + anElevationOffset,
                               TOL-HALF_PI, HALF_PI-TOL);

      // Update the camera
      updateCamera();
   }
   
   /** Circle the camera around a center of interest at a set elevation*/
   public void circle(float anAzimuthOffset)
   {
      // Calculate the new azimuth for the camera
      theAzimuth = (theAzimuth + anAzimuthOffset + TWO_PI) % TWO_PI;

      // Update the camera
      updateCamera();
   }
   
   /** Look about the camera's position */
   public void look(float anAzimuthOffset, float anElevationOffset)
   {
      // Calculate the new azimuth and elevation for the camera
      theElevation = constrain(theElevation - anElevationOffset,
                               TOL-HALF_PI, HALF_PI-TOL);

      theAzimuth = (theAzimuth - anAzimuthOffset + TWO_PI) % TWO_PI;

      // Update the target
      updateTarget();
   }
   
   /** Tumble the camera about its target */
   public void tumble(float anAzimuthOffset, float anElevationOffset)
   {
      // Calculate the new azimuth and elevation for the camera
      theElevation = constrain(theElevation + anElevationOffset,
                               TOL-HALF_PI, HALF_PI-TOL);

      theAzimuth   = (theAzimuth + anAzimuthOffset + TWO_PI) % TWO_PI;
      
      // Update the camera
      updateCamera();
   }
   
   /** Moves the camera and target simultaneously in the camera's X-Y plane */
   public void track(float anXOffset, float aYOffset)
   {
      // Perform the truck, if any
      truck(anXOffset);

      // Perform the boom, if any
      boom(aYOffset);
   }
   
   //** Returns the camera position */
   public float[] position()
   {
      return new float[] {theCameraX, theCameraY, theCameraZ};
   }

   //** Returns the camera orientation */
   public float[] attitude()
   {
      return new float[] {theAzimuth, theElevation, theRoll};
   }

   //** Returns the target position */
   public float[] target()
   {
      return new float[] {theTargetX, theTargetY, theTargetZ};
   }
   
   //** Returns the "up" vector */
   public float[] up()
   {
      return new float[] {theUpX, theUpY, theUpZ};
   }

   //** Returns the field of view */
   public float fov()
   {
      return theFoV;
   }

   //---- Helpers ------------------------------------------------------------

   /** Update deltas and related information */
   private void updateDeltas()
   {
      // Describe the new vector between the camera and the target
      theDeltaX = theCameraX - theTargetX;
      theDeltaY = theCameraY - theTargetY;
      theDeltaZ = theCameraZ - theTargetZ;

      // Describe the new azimuth and elevation for the camera
      theShotLength = sqrt(theDeltaX * theDeltaX +
                           theDeltaY * theDeltaY +
	       theDeltaZ * theDeltaZ);

      theAzimuth    = atan2(theDeltaX,
                            theDeltaZ);
      theElevation  = atan2(theDeltaY,
                            sqrt(theDeltaZ * theDeltaZ +
	             theDeltaX * theDeltaX));

      // update the up vector
      updateUp();
   }

   /** Update target and related information */
   private void updateTarget()
   {
      // Rotate to the new orientation while maintaining the shot distance.
      theTargetX = theCameraX - ( theShotLength               *
                                  sin(HALF_PI + theElevation) *
                                  sin(theAzimuth));
      theTargetY = theCameraY - (-theShotLength               *
                                  cos(HALF_PI + theElevation));
      theTargetZ = theCameraZ - ( theShotLength               *
                                  sin(HALF_PI + theElevation) *
                                  cos(theAzimuth));

      // update the up vector
      updateUp();
   }

   /** Update target and related information */
   private void updateCamera()
   {
      // Orbit to the new orientation while maintaining the shot distance.
      theCameraX = theTargetX + ( theShotLength                  *
                                  sin(HALF_PI + theElevation) *
                                  sin(theAzimuth));
      theCameraY = theTargetY + (-theShotLength                  *
                                  cos(HALF_PI + theElevation));
      theCameraZ = theTargetZ + ( theShotLength                  *
                                  sin(HALF_PI + theElevation)    *
                                  cos(theAzimuth));

      // update the up vector
      updateUp();
   }

   /** Update the up direction and related information */
   private void updateUp()
   {
      // Describe the new vector between the camera and the target
      theDeltaX = theCameraX - theTargetX;
      theDeltaY = theCameraY - theTargetY;
      theDeltaZ = theCameraZ - theTargetZ;

      // Calculate the new "up" vector for the camera
      theUpX = -theDeltaX * theDeltaY;
      theUpY =  theDeltaZ * theDeltaZ + theDeltaX * theDeltaX;
      theUpZ = -theDeltaZ * theDeltaY;

      // Normalize the "up" vector
      float magnitude = magnitude(theUpX, theUpY, theUpZ);

      theUpX /= magnitude;
      theUpY /= magnitude;
      theUpZ /= magnitude;

      // Calculate the roll if there is one
      if (theRoll != 0)
      {
         // Calculate the camera's X axis in world space
         float directionX = theDeltaY * theUpZ - theDeltaZ * theUpY;
         float directionY = theDeltaX * theUpZ - theDeltaZ * theUpX;
         float directionZ = theDeltaX * theUpY - theDeltaY * theUpX;
      
         // Normalize this vector so that it can be scaled
         magnitude = magnitude(directionX, directionY, directionZ);

         directionX /= magnitude;
         directionY /= magnitude;
         directionZ /= magnitude;
         
         // Perform the roll
         theUpX = theUpX * cos(theRoll) + directionX * sin(theRoll);
         theUpY = theUpY * cos(theRoll) + directionY * sin(theRoll);
         theUpZ = theUpZ * cos(theRoll) + directionZ * sin(theRoll);
      }
   }

   /** Find the magnitude of a vector */
   private static final float magnitude(float x, float y, float z)
   {
      float magnitude = sqrt(x * x + y * y + z * z);

      return (magnitude < TOL) ? 1 : magnitude;
   }

   //--- Simple Hacks ----------
   private static final float sin(float a) {
      return PApplet.sin(a);
   }

   private static final float cos(float a) {
      return PApplet.cos(a);
   }

   private static final float tan(float a) {
      return PApplet.tan(a);
   }

   private static final float sqrt(float a) {
      return PApplet.sqrt(a);
   }

   private static final float atan2(float y, float x) {
      return PApplet.atan2(y, x);
   }

   private static final float degrees(float a) {
      return PApplet.degrees(a);
   }

   private static final float constrain(float v, float l, float u) {
      return PApplet.constrain(v, l, u);
   }
}