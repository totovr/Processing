#KinectOrbit
KinectOrbit is companion code for Arduino and Kinect Projects by Enrique Ramos Melgar and Ciraco Castro Diez.

This code was orignally downloaded here: http://www.arduinoandkinectprojects.com/kinectorbit

I took on modifying this code a bit because the version released by Enrique had become outdated and didn't work on Processing version 2+. This version is a very rough crack at getting the code to work again so I can go through the Arduino and Kinect Projects book.

## Instalation
1. Donwload this repo, 
2. Name the folder `KinectOrbit` with that case (not sure if that matters, but it is how I have it)
3. Move this KinectOrbit folder to your Processing library. On my computer (OSX, processing v2.2) that is located in `~/Documents/Processing/libraries/`
4. Restart Processing

## Rebuilding and modifying
1. edit the code in `library/kinectOrbit/KinectOrbit.java`
2. `cd library`
3. run `./rebuild.sh`