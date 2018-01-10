# Added serial communication library
add_library('serial')

# Minimum and maximum temperature
min_temp = 20 / 0.25
max_temp = 38 / 0.25

def setup():
  # Window screen size setting
    size(384 * 2, 384)

    # Initialize serial port
    print Serial.list()
    portIndex = 2   # Please change according to the environment
    print "Connecting to", Serial.list()[portIndex]
    global myPort
    myPort = Serial(this, Serial.list()[portIndex], 115200)

    # Initialize pixel temperature data
    global pixel_buffer
    pixel_buffer = [0 for i in range(64)]

    # 8x8 image creation
    global pg
    pg = createGraphics(8, 8)

    # Create gradation table
    global gradient
    gradient = []
    last_c = color(6, 3, 25)
    base_c = [color(51, 24, 131),
              color(163, 38, 135),
              color(210, 38, 41),
              color(239, 121, 37),
              color(250, 216, 54),
              color(254, 247, 210)]
    for c in base_c:
        for i in range(15):
            # Add a neutral color
            inter = lerpColor(last_c, c, .0625 * (i + 1))
            gradient.append(inter)
        last_c = c
    # print len ​​(gradient)
    # print gradient

def draw():
    global pixel_buffer
    # Pixel data reception
    while myPort.available() >= 130:
        # Header check 1
        if myPort.read() == 0x55:
            # Header check 2
            if myPort.read() == 0xaa:
                for i in range(64):
                    # 1 pixel It is an integer type of 2 bytes and is sent in the order of the lower byte and the upper byte
                    lo = myPort.read()
                    hi = myPort.read()
                    temp = (hi << 8) | lo
                    pixel_buffer[i] = temp
                print pixel_buffer
                break
    # 8 x 8 image update
    pg.beginDraw()
    for y in range(pg.height):
        for x in range(pg.width):
        # Convert temperature to color
            c = temp2Color(pixel_buffer[((8 - y - 1) * 8) + (8 - x - 1)])
        # Pixel setting
            pg.set(x, y, c)
    pg.endDraw ()

    # Forward to the left side of the window
    half_width = width / 2
    image(pg, 0, 0, half_width, height)

    # Draw in a grid on the right side of the window
    rw = half_width / 8
    rh = height / 8
    padding = 4
    fill(15)
    noStroke()
    rect(half_width, 0, half_width, height)
    for y in range(pg.height):
        for x in range(pg.width):
            fill(pg.get(x, y))
            rect(half_width + (rw * x) + padding, (rh * y) + padding,
                 rw - (padding * 2), rh - (padding * 2), 5)

def temp2Color(temp):
    i = map(constrain(temp, min_temp, max_temp),
            min_temp, max_temp, 0, len(gradient) - 1)
    return gradient[int(i)]