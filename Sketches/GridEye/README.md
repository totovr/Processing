# GridEye

Grid-EYE is an infrared sensor developed by Panasonic and outputs 2-dimensional temperature data of 8 × 8 (64 pixels) (top photo, canned package of square window). A wide range of temperature can be measured with a viewing angle of 60 degrees. It can also be used for digital signage etc. because it can detect microwave ovens, air conditioners and stationary human body.

* [Panasonic EyeGrid](https://industrial.panasonic.com/ww/ds/pr/grid-eye)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

* Arduino IDE
* Processing 3.3.6 with Python Mode
* Arduino Board
* A computer with OSX

### Installing

Install the last stable version of Arduino, you can download it from this page:

* [Arduino](https://www.arduino.cc/en/Main/Software)

Install the library created by @arms22 to use the GridEye sensor in the Arduino IDE

* [GridEye_library](https://github.com/totovr/Arduino/blob/master/libraries/GridEye.zip)

Install the last stable version of Processing, you can download it from this link:

* [Processing](http://download.processing.org/processing-3.3.6-macosx.zip)


## Connect the Sensor

<img src="https://github.com/totovr/Arduino/blob/master/GridEye/Images/Connections.png" width="400">

|Arduino PIN| Sensor PIN|   
|:---------:|:---------:|
|     A4    |    SDA    |
|     A5    |    SCL    |
|     INT   |    GND    |
|     GND   |    GND    |
|     VDD   |    3.3V   |
|     AD    |    GND    |

## Programs

* [GridEye](https://github.com/totovr/Arduino/tree/master/GridEye/GridEye)

Arduino reads pixel temperature data and transmits 1 pixel in 2 byte short type with lower order byte and upper byte in serial communication. Before sending the temperature data, send 2 byte header (0x55, 0xaa) as data delimiter.

* [Thermal](https://github.com/totovr/Arduino/tree/master/GridEye/Thermal)

Processing side waits for 130 bytes of data (header 2 bytes + pixel temperature data 64 * 2) to accumulate in the buffer. When it receives 130 bytes, it confirms whether it received the header. When receiving the header, store the pixel temperature data in the variable.

##### Processing program is written in Python

<img src="https://github.com/totovr/Arduino/blob/master/GridEye/Images/Thermal.png" width="600">

## Also you can use the next IDE to build programs:

* [Arduino Online IDE](https://create.arduino.cc/editor)
* [PlataformIO](http://platformio.org/get-started)

### To use the last one you must install first ATOM:

* [Atom](https://atom.io/)

## Contributing

Please read [CONTRIBUTING.md](https://github.com/totovr/Processing/blob/master/CONTRIBUTING.md) for details of the code of conduct, and the process for submitting pull requests to us.

## Versioning

I use [SemVer](http://semver.org/) for versioning.

## Authors

Antonio Vega Ramirez:

* [Github](https://github.com/totovr)
* [Twitter](https://twitter.com/SpainDice)

## License

This project is licensed under The MIT License (MIT) - see the [LICENSE.md](https://github.com/totovr/Arduino/blob/master/LICENSE.md) file for details
