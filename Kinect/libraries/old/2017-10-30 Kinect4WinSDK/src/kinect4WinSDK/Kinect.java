/**
 * It is a Processing library for the Kinect for Windows SDK 1.8.
 *
 * ##copyright##
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General
 * Public License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA  02111-1307  USA
 * 
 * @author		Bryan Chung
 * @modified	01-07-2014
 * @version		1.2.0
 */

package kinect4WinSDK;

import processing.core.PApplet;
import processing.core.PConstants;
import processing.core.PImage;

import java.lang.reflect.Method;
import java.util.ArrayList;

public class Kinect implements PConstants, KinectConstants, Runnable {
	static {
		int arch = Integer.parseInt(System.getProperty("sun.arch.data.model"));
		if (arch == 64) {
			System.loadLibrary("Kinect4WinSDK64");
		} else {
			System.loadLibrary("Kinect4WinSDK32");
		}
	}

	public final static String VERSION = "version 1.2.0";

	private final static int CNT = 5;
	private PApplet parent;

	private Method appearEvent;
	private Method disappearEvent;
	private Method moveEvent;

	private float[][][] joints;
	private long ptr;

	private SkeletonData[] skeletons;
	private SkeletonData[] before;

	public Kinect(PApplet _p) {
		parent = _p;

		try {
			appearEvent = parent.getClass().getMethod("appearEvent",
					new Class[] { SkeletonData.class });
			disappearEvent = parent.getClass().getMethod("disappearEvent",
					new Class[] { SkeletonData.class });
			moveEvent = parent.getClass().getMethod("moveEvent",
					new Class[] { SkeletonData.class, SkeletonData.class });
		} catch (Exception e) {
			e.printStackTrace();
		}

		joints = new float[NUI_SKELETON_COUNT][NUI_SKELETON_POSITION_COUNT + 1][CNT];
		for (int i = 0; i < NUI_SKELETON_COUNT; i++) {
			for (int j = 0; j < NUI_SKELETON_POSITION_COUNT + 1; j++) {
				for (int k = 0; k < CNT; k++) {
					joints[i][j][k] = 0.0f;
				}
			}
		}

		skeletons = new SkeletonData[NUI_SKELETON_COUNT];
		before = new SkeletonData[NUI_SKELETON_COUNT];

		for (int i = 0; i < NUI_SKELETON_COUNT; i++) {
			skeletons[i] = new SkeletonData();
			before[i] = new SkeletonData();
		}

		// parent.registerDispose(this);
		init();
		welcome();
		(new Thread(this)).start();
	}

	private native void init();

	private native int[] Nui_GetImage();

	private native int[] Nui_GetDepth();

	private native int[] Nui_GetMask();

	private native void getFigure();

	private void welcome() {
		System.out.println("PKinect 1.2.0 by Bryan Chung");
	}

	public static String version() {
		return VERSION;
	}

	public PImage GetImage() {
		PImage img = parent.createImage(WIDTH, HEIGHT, ARGB);
		PApplet.arrayCopy(Nui_GetImage(), img.pixels);
		img.updatePixels();
		return img;
	}

	public PImage GetDepth() {
		PImage img = parent.createImage(WIDTH, HEIGHT, ARGB);
		PApplet.arrayCopy(Nui_GetDepth(), img.pixels);
		img.updatePixels();
		return img;
	}

	public PImage GetMask() {
		PImage img = parent.createImage(WIDTH, HEIGHT, ARGB);
		PApplet.arrayCopy(Nui_GetMask(), img.pixels);
		img.updatePixels();
		return img;
	}

	private void sendAppear(SkeletonData _s) {
		if (appearEvent != null) {
			try {
				appearEvent.invoke(parent, new Object[] { _s });
			} catch (Exception e) {
				e.printStackTrace();
				appearEvent = null;
			}
		}
	}

	private void sendDisappear(SkeletonData _s) {
		if (disappearEvent != null) {
			try {
				disappearEvent.invoke(parent, new Object[] { _s });
			} catch (Exception e) {
				e.printStackTrace();
				disappearEvent = null;
			}
		}
	}

	private void sendMove(SkeletonData _before, SkeletonData _after) {
		if (moveEvent != null) {
			try {
				moveEvent.invoke(parent, new Object[] { _before, _after });
			} catch (Exception e) {
				e.printStackTrace();
				moveEvent = null;
			}
		}
	}

	private void backup() {
		for (int i = 0; i < NUI_SKELETON_COUNT; i++) {
			before[i].copy(skeletons[i]);
		}
	}

	private void update() {
		for (int i = 0; i < NUI_SKELETON_COUNT; i++) {
			skeletons[i].position.x = joints[i][NUI_SKELETON_POSITION_COUNT][0];
			skeletons[i].position.y = joints[i][NUI_SKELETON_POSITION_COUNT][1];
			skeletons[i].position.z = joints[i][NUI_SKELETON_POSITION_COUNT][2];
			skeletons[i].trackingState = (int) joints[i][NUI_SKELETON_POSITION_COUNT][3];
			skeletons[i].dwTrackingID = (int) joints[i][NUI_SKELETON_POSITION_COUNT][4];

			for (int j = 0; j < NUI_SKELETON_POSITION_COUNT; j++) {
				skeletons[i].skeletonPositions[j].x = joints[i][j][0];
				skeletons[i].skeletonPositions[j].y = joints[i][j][1];
				skeletons[i].skeletonPositions[j].z = joints[i][j][2];
				skeletons[i].skeletonPositionTrackingState[j] = (int) joints[i][j][3];
			}
		}
	}

	private void sendEvents() {
		ArrayList<Integer> appearList = new ArrayList<Integer>();
		for (int i = 0; i < NUI_SKELETON_COUNT; i++) {
			if (skeletons[i].dwTrackingID != 0) {
				appearList.add(i);
			}
		}
		for (int i = 0; i < NUI_SKELETON_COUNT; i++) {
			if (before[i].dwTrackingID == 0) {
				continue;
			}
			boolean disappear = true;
			for (int j = 0; j < NUI_SKELETON_COUNT; j++) {
				if (skeletons[j].dwTrackingID == 0) {
					continue;
				}
				if (before[i].dwTrackingID == skeletons[j].dwTrackingID) {
					sendMove(before[i], skeletons[j]);
					disappear = false;
					int pos = appearList.indexOf(j);
					if (pos > -1) {
						appearList.remove(pos);
					}
				}
			}
			if (disappear) {
				sendDisappear(before[i]);
			}
		}
		if (!appearList.isEmpty()) {
			for (int i = 0; i < appearList.size(); i++) {
				int pos = appearList.get(i);
				sendAppear(skeletons[pos]);
			}
		}
		appearList = null;
	}

	public void run() {
		int fr = PApplet.round(1000.0f / parent.frameRate);
		while (true) {
			try {
				Thread.sleep(fr);
			} catch (InterruptedException e) {
				e.printStackTrace();
				return;
			}
			backup();
			getFigure();
			update();
			sendEvents();
		}
	}

	public void dispose() {
	}
}
