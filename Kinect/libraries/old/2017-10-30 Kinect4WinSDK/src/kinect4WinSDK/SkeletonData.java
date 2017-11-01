package kinect4WinSDK;

import processing.core.PVector;

public class SkeletonData implements KinectConstants {

	public int trackingState;
	public int dwTrackingID;
	public PVector position;
	public PVector[] skeletonPositions;
	public int[] skeletonPositionTrackingState;

	public SkeletonData() {
		trackingState = 0;
		dwTrackingID = 0;
		position = new PVector(0.0f, 0.0f, 0.0f);
		skeletonPositions = new PVector[NUI_SKELETON_POSITION_COUNT];
		skeletonPositionTrackingState = new int[NUI_SKELETON_POSITION_COUNT];

		for (int i = 0; i < NUI_SKELETON_POSITION_COUNT; i++) {
			skeletonPositions[i] = new PVector(0.0f, 0.0f, 0.0f);
			skeletonPositionTrackingState[i] = 0;
		}
	}

	public void copy(SkeletonData _s) {
		this.trackingState = _s.trackingState;
		this.dwTrackingID = _s.dwTrackingID;

		this.position.x = _s.position.x;
		this.position.y = _s.position.y;
		this.position.z = _s.position.z;

		for (int i = 0; i < NUI_SKELETON_POSITION_COUNT; i++) {
			this.skeletonPositions[i].x = _s.skeletonPositions[i].x;
			this.skeletonPositions[i].y = _s.skeletonPositions[i].y;
			this.skeletonPositions[i].z = _s.skeletonPositions[i].z;
			this.skeletonPositionTrackingState[i] = _s.skeletonPositionTrackingState[i];
		}
	}
}
