/**
 * (./) orbit.java v0.1 28/05/2011
 * (by) Enrique Ramos Melgar
 * http://www.esc-studio.com
 * 
 * This is a basic orbit library for Procesing based on previous 
 * code from Przemek Jaworsky - http://www.jawordesign.com
 *
 * http://www.processing.org/
 *
 * THIS LIBRARY IS RELEASED UNDER A CREATIVE COMMONS ATTRIBUTION 3.0 LICENSE
 * http://creativecommons.org/licenses/by/3.0/
 */

package kinectOrbit;

import processing.event.KeyEvent;
import processing.event.MouseEvent;
import java.awt.event.MouseWheelEvent;
import java.awt.event.MouseWheelListener;
import java.io.File;
import java.io.PrintWriter;
import processing.core.*;

/**
 * This Class creates an orbit object that allows the use of the muose to
 * control the three-dimensional rotation of the space.
 * 
 * @author Enrique Ramos
 * 
 */
public class KinectOrbit {

	private PApplet p;
	// Camera Variables
	String[] viewPoint = new String[7];
	String viewPointFile;
	PFont fontA; // Font

	/*
	 * Orbit Parameters as stored in the csv file orbitParams[0] = alpha1
	 * orbitParams[1] = alpha2 orbitParams[2] = distance orbitParams[3] =
	 * translate1 orbitParams[4] = translate2 orbitParams[5] = translate3
	 * orbitParams[6] = fov
	 */
	private float[] orbitParams = new float[7];
	private float panScale = 50;
	private float CSScale = 100;
	private float alpha1_, alpha2_;
	private int mouse_x, mouse_y;
	private boolean retPers = true;
	private int numRot = 0;
	private PrintWriter output;
	private File f;
	private boolean shiftControl;
	private boolean shiftMode;
	private boolean drawCS = true;

	boolean milimeters;
	private float units;
	private boolean drawGizmo;
	private boolean drawGround;
	private char upAxis = 'z';
	public boolean invertY;

	public KinectOrbit(PApplet p) {
		this(p, 0, "kinect");
	}

	public KinectOrbit(PApplet p, int numView) {
		this(p, numView, "kinect");
	}

	/**
	 * Main constructor. It takes a Processing Application, a number for the
	 * file containing the saved views and the scale of the model.
	 * 
	 * @param p
	 * @param numView
	 * @param scale
	 */
	public KinectOrbit(PApplet p, int numView, String scale) {
		this.p = p;
		p.registerDispose(this);
		p.registerMethod("mouseEvent", this);
		p.registerMethod("keyEvent", this);

		if (scale.contentEquals("mm")) {
			units = 0.5f;
			panScale = 0.5f;
			CSScale = 1000;
			PApplet.println("Orbit set to milimeters");
		} else if (scale.contentEquals("cm")) {
			units = 0.5f;
			panScale = 0.5f;
			CSScale = 100;
			PApplet.println("Orbit set to centimeters");
		} else if (scale.contentEquals("m")) {
			units = 0.5f;
			panScale = 0.5f;
			CSScale = 1;
			PApplet.println("Orbit set to meters");
		} else if (scale.contentEquals("kinect")) {
			units = 0.5f;
			panScale = 0.5f;
			CSScale = 1000;
			this.upAxis = 'y';
			PApplet.println("Orbit set to Kinect Scale (mm)");
		} else {
			PApplet.println("No Input Scale. Orbit Set to Meters");
			units = 0.5f;
			panScale = 0.5f;
			CSScale = 1000;
		}

		mouseWheel();
		fontA = p.createFont("ArialMT", 50);

		// Creates a file containing the saved view settings.
		viewPointFile = "orbitSet_" + numView + ".csv";

		// Check if there is a saved view in the data folder of the sketch, and
		// create a file if negative
		f = new File(p.dataPath(viewPointFile));
		if (!f.exists()) {
			output = p.createWriter(p.dataPath(viewPointFile));

			if (milimeters) {
				output.println(-6.81999);
				output.println(7.829951);
				output.println(7.333359);
				output.println(-24.448734);
				output.println(11.007046);
				output.println(-948.3287);
				output.println(0.7843585);
			} else {
				output.println(0.15);
				output.println(1.15);
				output.println(0.5);
				output.println(-9.0);
				output.println(4.5);
				output.println(15.5);
				output.println(0.8);
			}
			output.flush(); // Write the remaining data
			output.close(); // Finish the file
		}
	}

	// -----------------------------------------------------------------------
	// PushOrbit and PopOrbit methods

	public float getPanScale() {
		return panScale;
	}

	public void setPanScale(float panScale) {
		this.panScale = panScale;
	}

	public void pushOrbit() {
		pushOrbit(p.g);
	}

	public void popOrbit() {
		popOrbit(p.g);
	}

	public void pushOrbit(PApplet win) {
		pushOrbit(win.g);
	}

	public void popOrbit(PApplet win) {
		popOrbit(win.g);
	}

	public void pushOrbit(PGraphics window) {

		window.lights();
		window.camera((float) (p.width / 2.0), (float) (p.height / 2.0),
				(float) (orbitParams[2] * (p.height / 2.0) / Math
						.tan(Math.PI * 60.0 / 360.0)), (float) (p.width / 2.0),
				(float) (p.height / 2.0), (float) (-1 * (p.height / 2.0) / Math
						.tan(Math.PI * 60.0 / 360.0)), 0f, 1f, 0f);
		window.perspective(
				orbitParams[6],
				(((float) p.width) / ((float) p.height)),
				(float) ((orbitParams[2]
						* ((p.height / 2.0) / Math.tan(Math.PI * 60.0 / 360.0)) / 10.0f)),
				(float) (((p.height / 2.0) / Math.tan(Math.PI * 60.0 / 360.0)) * 500.0));

		alpha2_ = (float) (orbitParams[1] + Math.sin(p.frameCount / 130.0) * 0.00008);
		alpha1_ = (float) (orbitParams[0] + Math.sin(p.frameCount / 123.0) * 0.00008);

		window.translate(p.width / 2, p.height / 2);
		window.rotateX(alpha2_);
		if (upAxis == 'z')
			window.rotateZ(alpha1_);
		if (upAxis == 'y')
			window.rotateY(alpha1_);
		window.translate(orbitParams[3], orbitParams[4], orbitParams[5]);
		if (invertY)
			window.scale(1, -1, 1);

		if (retPers) {
			retrievePerspectiveSettings();
			panScale = units * orbitParams[2];
		}

		if (drawCS)
			drawCS(window, CSScale);
		if (drawGround)
			drawGround(units, 10, 10);
	}

	public void drawGround(float size, int xRows, int yRows) {

		p.pushStyle();
		p.stroke(200);
		for (int i = -xRows / 2; i < xRows / 2; i++) {
			for (int j = -yRows / 2; j < yRows / 2; j++) {
				if (upAxis == 'z') {
					if (i < xRows / 2 - 1)
						p.line(i * size, j * size, (i + 1) * size, j * size);
					if (j < yRows / 2 - 1)
						p.line(i * size, j * size, i * size, (j + 1) * size);
				} else {
					if (i < xRows / 2 - 1)
						p.line(i * size, 0, j * size, (i + 1) * size, 0, j
								* size);
					if (j < yRows / 2 - 1)
						p.line(i * size, 0, j * size, i * size, 0, (j + 1)
								* size);
				}
			}
		}
		p.popStyle();
	}

	public void popOrbit(PGraphics window) {
		window.camera();
		window.perspective();
		if (drawGizmo && !(shiftMode ^ shiftControl))
			drawCSGizmo(window);
	}

	public float getCSScale() {
		return CSScale;
	}

	public void setCSScale(float cSScale) {
		CSScale = cSScale;
	}

	public void drawCS(boolean state) {
		this.drawCS = state;
	}

	public void drawGizmo(boolean state) {
		this.drawGizmo = state;
	}

	public boolean isDrawGround() {
		return drawGround;
	}

	public void drawGround(boolean drawGround) {
		this.drawGround = drawGround;
	}

	void drawCS(PGraphics window, float cSScale2) {
		// Draw Coordinate System

		window.pushStyle();
		window.strokeWeight(2);
		window.stroke(255, 0, 0);
		window.line(0, 0, 0, cSScale2, 0, 0);
		window.stroke(0, 255, 0);
		window.line(0, 0, 0, 0, cSScale2, 0);
		window.stroke(0, 0, 255);
		window.line(0, 0, 0, 0, 0, cSScale2);
		window.stroke(0);
		window.popStyle();

	}

	private void drawCSGizmo(PGraphics window) {

		int gizmoSize = 50;
		// Draw Coordinate System
		window.textFont(fontA, gizmoSize / 4);

		window.pushMatrix();
		//window.ortho();
		//window.translate(window.width * 1.35f, -window.height * 0.3f);
		window.translate(window.width/2, window.height/2);
		window.pushStyle();

//		window.ortho(-window.width, window.width, -window.height,
//				window.height, -window.height, window.height);
		

		window.rotateX(alpha2_);
		if(this.upAxis=='y'){
			window.rotateY(alpha1_);
		}else{
			window.rotateZ(alpha1_);
		}
		if (invertY)
			window.scale(1, -1, 1);
		
		window.pushMatrix();
		window.noFill();
		window.stroke(150);
		window.ellipse(0,0,0.7f*window.height,0.7f*window.height);
		window.rotateX(PConstants.PI/2);
		window.ellipse(0,0,0.7f*window.height,0.7f*window.height);
		window.rotateY(PConstants.PI/2);
		window.ellipse(0,0,0.7f*window.height,0.7f*window.height);
		window.popMatrix();
		
		// window.strokeWeight(2);
		window.stroke(150);
		// window.stroke(255, 0, 0);
		window.line(0, 0, 0, gizmoSize, 0, 0);
		// window.stroke(0, 255, 0);
		window.line(0, 0, 0, 0, gizmoSize, 0);
		// window.stroke(0, 0, 255);
		window.line(0, 0, 0, 0, 0, gizmoSize);
		window.stroke(0);

		window.fill(150);

		window.textAlign(PConstants.CENTER, PConstants.CENTER);

		window.pushMatrix();
		window.translate(gizmoSize * 1.2f, 0);
		if (invertY)
			window.scale(1, -1, 1);
		if(this.upAxis=='y'){
			window.rotateY(-alpha1_);
		}else{
			window.rotateZ(-alpha1_);
		}
		window.rotateX(-alpha2_);
		window.text("X", 0, 0);
		window.popMatrix();

		window.pushMatrix();
		window.translate(0, gizmoSize * 1.2f);
		if (invertY)
			window.scale(1, -1, 1);
		if(this.upAxis=='y'){
			window.rotateY(-alpha1_);
		}else{
			window.rotateZ(-alpha1_);
		}
		window.rotateX(-alpha2_);
		window.text("Y", 0, 0);
		window.popMatrix();

		window.pushMatrix();
		window.translate(0, 0, gizmoSize * 1.2f);
		if (invertY)
			window.scale(1, -1, 1);
		if(this.upAxis=='y'){
			window.rotateY(-alpha1_);
		}else{
			window.rotateZ(-alpha1_);
		}
		window.rotateX(-alpha2_);
		window.text("Z", 0, 0);
		window.popMatrix();
		
		window.popStyle();
		window.popMatrix();

	}

	// -----------------------------------------------------------------------
	// File Operations

	private void savePerspectiveSettings() {

		for (int i = 0; i < orbitParams.length; i++) {

			viewPoint[i] = String.valueOf(orbitParams[i]);
		}

		PApplet.saveStrings(f, viewPoint);
	}

	private void retrievePerspectiveSettings() {

		String lines[] = PApplet.loadStrings(f);

		if (f.exists()) {

			// Set the number of frame for perspective change animation
			if (numRot < 50) {

				for (int i = 0; i < orbitParams.length; i++) {

					orbitParams[i] = (Float.valueOf(lines[i]).floatValue() + orbitParams[i]) * 0.5f;
					numRot++;
				}
			} else {
				for (int i = 0; i < orbitParams.length; i++) {
					orbitParams[i] = Float.valueOf(lines[i]).floatValue();
				}

				retPers = false;
				numRot = 0;
			}
		}
	}

	// -----------------------------------------------------------------------
	// Keys and Mouse

	public void keyEvent(KeyEvent e) {

		if (p.key == 'p') {
			savePerspectiveSettings();
		}

		if (p.key == 'o') {
			retPers = true;
		}

		if (e.isShiftDown()) {
			shiftMode = true;
		} else {
			shiftMode = false;
		}

	}

	public void mouseEvent(MouseEvent event) {
		int x = event.getX();
		int y = event.getY();

		switch (event.getAction()) {
		case MouseEvent.PRESS:
			mouse_x = x;
			mouse_y = y;
			break;
		case MouseEvent.RELEASE:
			// do something for mouse released
			break;
		case MouseEvent.CLICK:
			// do something for mouse clicked
			break;
		case MouseEvent.DRAG:
			if (shiftControl ^ shiftMode == false) {
				if (p.mouseButton == PConstants.LEFT) {
					orbitParams[0] += (mouse_x - p.mouseX) / 100.0;
					orbitParams[1] += (mouse_y - p.mouseY) / 100.0;
				}

				if (p.mouseButton == PConstants.RIGHT) {
					if (upAxis == 'z') {
						float msx = (mouse_x - p.mouseX);
						float msy = (mouse_y - p.mouseY)
								* PApplet.cos(orbitParams[1]);
						float msz = (mouse_y - p.mouseY);
						orbitParams[3] -= (Math.cos(orbitParams[0]) * msx + Math
								.sin(orbitParams[0]) * msy)
								* panScale;
						orbitParams[4] -= (-Math.sin(orbitParams[0]) * msx + Math
								.cos(orbitParams[0]) * msy)
								* panScale;
						orbitParams[5] += (Math.sin(orbitParams[1]) * msz)
								* panScale;
					} else {
						float msx = (mouse_x - p.mouseX);
						float msy = (mouse_y - p.mouseY)
								* (float) Math.sin(orbitParams[1]);
						float msz = (mouse_y - p.mouseY);

						orbitParams[3] -= (Math.cos(orbitParams[0]) * msx + Math
								.sin(orbitParams[0]) * msy)
								* panScale;
						orbitParams[5] -= (Math.sin(orbitParams[0]) * msx - Math
								.cos(orbitParams[0]) * msy)
								* panScale;
						orbitParams[4] -= (Math.cos(orbitParams[1]) * msz)
								* panScale;
					}
				}

				if (p.mouseButton == PConstants.CENTER) {
					orbitParams[6] = orbitParams[6]
							* (p.mouseX - mouse_x + p.width) / p.width;
					float msy = (-mouse_y + p.mouseY);
					orbitParams[2] = orbitParams[2] * (msy + 20) / 20;
				}

				mouse_x = p.mouseX;
				mouse_y = p.mouseY;
			}

			break;

		case MouseEvent.MOVE:
			break;
		}
	}
	
	public void shiftControl(boolean active){
		shiftControl = active;
	}

	private void mouseWheel() {
		MouseWheelListener wheelListener = new MouseWheelListener() {
			@Override
			public void mouseWheelMoved(MouseWheelEvent e) {
				mouseWheel(e.getWheelRotation());
			}
		};
		p.addMouseWheelListener(wheelListener);
	}

	private void mouseWheel(int delta) {

		orbitParams[2] = orbitParams[2] * (delta + 20) / 20;
		panScale = units * orbitParams[2];

	}

	public void dispose() {
		// anything in here will be called automatically when
		// the parent applet shuts down. for instance, this might
		// shut down a thread used by this library.
	}

}
