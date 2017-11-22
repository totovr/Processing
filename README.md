# Processing

Processing is a flexible software sketchbook and a language for learning how to code within the context of the visual arts. Since 2001, Processing has promoted software literacy within the visual arts and visual literacy within technology. There are tens of thousands of students, artists, designers, researchers, and hobbyists who use Processing for learning and prototyping.

for more information check the [Processing](https://processing.org/reference/)

This repository contains programs for different applications in Processing 3.3.6

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

* Processing IDE
* A computer with OSX, Windows, Linux

Alternative:

* Kinect V1
* Arduino IDE
* Arduino board

### Installing

Install the Processing 3.3.6 IDE, you can download it from this page:

* [Processing IDE](https://processing.org/download/)

For OSX you just need to unzip the folder and paste the App in the applications folder.

## Test a program sample:

Open Processing IDE and upload the next example:
```
void setup() {
  size(480, 120); //Create a window of 480*120
}

void draw() {
  if (mousePressed) {
    fill(0);
    } else {
      fill(255);
    }
    ellipse(mouseX, mouseY, 80, 80); //If we pressed the mouse a Ellipse will be draw
}
```
This is one simple example of how to draw a Ellipse in the sketch window.

## Also you can use the next IDE to build programs:

* [Processing Online Editor](http://js.do/blog/processing/editor/)
* [Atom](https://atom.io/)

## Contributing

Please read [CONTRIBUTING.md](https://github.com/totovr/Processing/blob/master/CONTRIBUTING.md) for details of the code of conduct, and the process for submitting pull requests to us.

## Versioning

I use [SemVer](http://semver.org/) for versioning.

## Author

Antonio Vega Ramirez:

* [Github](https://github.com/totovr)
* [Twitter](https://twitter.com/SpainDice)

## License

This project is licensed under CC License - see the [LICENSE.md](https://creativecommons.org/licenses/by/4.0/) file for details

### The instructions to Setup the Kinect are written for Mac OS High Sierra users.

![Deep](https://github.com/totovr/Processing/blob/master/Images/deep.png)
