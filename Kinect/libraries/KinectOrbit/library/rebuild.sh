#!/bin/bash -x

javac -classpath /Applications/Processing.app/Contents/Java/core.jar kinectOrbit/KinectOrbit.java
jar cvf KinectOrbit.jar kinectOrbit

