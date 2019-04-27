
// ssd1306.agent.lib.nut
//
// MIT License
//
// Copyright [2019] Tony Smith (@smittytone), CommuniG8, Richard Gate
//
// SPDX-License-Identifier: MIT
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

// CLASS DEFINITION

class SSD1306 {

    // Squirrel Class for Solomon SSD1306 OLED controller chip
    // [http://www.adafruit.com/datasheets/SSD1306.pdf]
    // As used on the Adafruit SSD1306 I2C breakout board
    // [http://www.adafruit.com/products/931]
    // Bus: I2C

    // Current library version
    // Based on original code by Tony Smith (@smittytone)
    // Version 1.0.1, June 2014
    // Version 2.0.0, Sept 2015/July 2017
    static VERSION = "3.0.0";

    // CLASS CONTANTS
    static SSD1306_SETCONTRAST = "\x81";
    static SSD1306_DISPLAYALLON_RESUME = "\xA4";
    static SSD1306_DISPLAYALLON = "\xA5";
    static SSD1306_NORMALDISPLAY = "\xA6";
    static SSD1306_INVERTDISPLAY = "\xA7";
    static SSD1306_DISPLAYOFF = "\xAE";
    static SSD1306_DISPLAYON = "\xAF";
    static SSD1306_SETDISPLAYOFFSET = "\xD3";
    static SSD1306_SETCOMPINS = "\xDA";
    static SSD1306_SETVCOMDETECT = "\xDB";
    static SSD1306_SETDISPLAYCLOCKDIV = "\xD5";
    static SSD1306_SETPRECHARGE = "\xD9";
    static SSD1306_SETMULTIPLEX = "\xA8";
    static SSD1306_SETLOWCOLUMN = "\x00";
    static SSD1306_SETHIGHCOLUMN = "\x10";
    static SSD1306_SETSTARTLINE = "\x40";
    static SSD1306_MEMORYMODE = "\x20";
    static SSD1306_COLUMNADDR = "\x21";
    static SSD1306_PAGEADDR = "\x22";
    static SSD1306_COMSCANINC = "\xC0";
    static SSD1306_COMSCANDEC = "\xC8";
    static SSD1306_SEGREMAP = "\xA1";
    static SSD1306_CHARGEPUMP = "\x8D";
    static SSD1306_EXTERNALVCC = "\x01";
    static SSD1306_SWITCHCAPVCC = "\x02";
    static SSD1306_ACTIVATE_SCROLL = 0x2F;
    static SSD1306_DEACTIVATE_SCROLL = 0x2E;
    static SSD1306_SET_VERTICAL_SCROLL_AREA = 0xA3;
    static SSD1306_RIGHT_HORIZONTAL_SCROLL = 0x26;
    static SSD1306_LEFT_HORIZONTAL_SCROLL = 0x27;
    static SSD1306_VERTICAL_AND_RIGHT_HORIZONTAL_SCROLL = 0x29;
    static SSD1306_VERTICAL_AND_LEFT_HORIZONTAL_SCROLL = 0x2A;
    static SSD1306_WRITETOBUFFER = "\x40";

    static HIGH = 1;
    static LOW = 0;

    // Constants for the alphanumeric character set. Each character is
    // a proportionally spaced bitmap rendered as 8-bit values
    static charset = [
        [0x00, 0x00],					// space - Ascii 32
        [0xfa],							// !
        [0xe0, 0xc0, 0x00, 0xe0, 0xc0],	// "
        [0x24, 0x7e, 0x24, 0x7e, 0x24],	// #
        [0x24, 0xd4, 0x56, 0x48],		// $
        [0xc6, 0xc8, 0x10, 0x26, 0xc6],	// %
        [0x6c, 0x92, 0x6a, 0x04, 0x0a],	// &
        [0xc0],							// '
        [0x7c, 0x82],					// (
        [0x82, 0x7c],					// )
        [0x10, 0x7c, 0x38, 0x7c, 0x10],	// *
        [0x10, 0x10, 0x7c, 0x10, 0x10],	// +
        [0x06, 0x07],					// ,
        [0x10, 0x10, 0x10, 0x10, 0x10],	// -
        [0x06, 0x06],					// .
        [0x04, 0x08, 0x10, 0x20, 0x40],	// /
        [0x7c, 0x8a, 0x92, 0xa2, 0x7c],	// 0 - Ascii 48
        [0x42, 0xfe, 0x02],				// 1
        [0x46, 0x8a, 0x92, 0x92, 0x62],	// 2
        [0x44, 0x92, 0x92, 0x92, 0x6c],	// 3
        [0x18, 0x28, 0x48, 0xfe, 0x08],	// 4
        [0xf4, 0x92, 0x92, 0x92, 0x8c],	// 5
        [0x3c, 0x52, 0x92, 0x92, 0x8c],	// 6
        [0x80, 0x8e, 0x90, 0xa0, 0xc0],	// 7
        [0x6c, 0x92, 0x92, 0x92, 0x6c],	// 8
        [0x60, 0x92, 0x92, 0x94, 0x78],	// 9
        [0x36, 0x36],					// : - Ascii 58
        [0x36, 0x37],					// ;
        [0x10, 0x28, 0x44, 0x82],		// <
        [0x24, 0x24, 0x24, 0x24, 0x24],	// =
        [0x82, 0x44, 0x28, 0x10],		// >
        [0x60, 0x80, 0x9a, 0x90, 0x60],	// ?
        [0x7c, 0x82, 0xba, 0xaa, 0x78],	// @
        [0x7e, 0x90, 0x90, 0x90, 0x7e],	// A - Ascii 65
        [0xfe, 0x92, 0x92, 0x92, 0x6c],	// B
        [0x7c, 0x82, 0x82, 0x82, 0x44],	// C
        [0xfe, 0x82, 0x82, 0x82, 0x7c],	// D
        [0xfe, 0x92, 0x92, 0x92, 0x82],	// E
        [0xfe, 0x90, 0x90, 0x90, 0x80],	// F
        [0x7c, 0x82, 0x92, 0x92, 0x5c],	// G
        [0xfe, 0x10, 0x10, 0x10, 0xfe],	// H
        [0x82, 0xfe, 0x82],				// I
        [0x0c, 0x02, 0x02, 0x02, 0xfc],	// J
        [0xfe, 0x10, 0x28, 0x44, 0x82],	// K
        [0xfe, 0x02, 0x02, 0x02, 0x02],	// L
        [0xfe, 0x40, 0x20, 0x40, 0xfe],	// M
        [0xfe, 0x40, 0x20, 0x10, 0xfe],	// N
        [0x7c, 0x82, 0x82, 0x82, 0x7c],	// O
        [0xfe, 0x90, 0x90, 0x90, 0x60],	// P
        [0x7c, 0x82, 0x92, 0x8c, 0x7a],	// Q
        [0xfe, 0x90, 0x90, 0x98, 0x66],	// R
        [0x64, 0x92, 0x92, 0x92, 0x4c],	// S
        [0x80, 0x80, 0xfe, 0x80, 0x80],	// T
        [0xfc, 0x02, 0x02, 0x02, 0xfc],	// U
        [0xf8, 0x04, 0x02, 0x04, 0xf8],	// V
        [0xfc, 0x02, 0x3c, 0x02, 0xfc],	// W
        [0xc6, 0x28, 0x10, 0x28, 0xc6],	// X
        [0xe0, 0x10, 0x0e, 0x10, 0xe0],	// Y
        [0x86, 0x8a, 0x92, 0xa2, 0xc2],	// Z - Ascii 90
        [0xfe, 0x82, 0x82],				// [
        [0x40, 0x20, 0x10, 0x08, 0x04],	// \
        [0x82, 0x82, 0xfe],				// ]
        [0x20, 0x40, 0x80, 0x40, 0x20],	// ^
        [0x02, 0x02, 0x02, 0x02, 0x02],	// _
        [0xc0, 0xe0],					// '
        [0x04, 0x2a, 0x2a, 0x2a, 0x1e],	// a - Ascii 97
        [0xfe, 0x22, 0x22, 0x22, 0x1c],	// b
        [0x1c, 0x22, 0x22, 0x22],		// c
        [0x1c, 0x22, 0x22, 0x22, 0xfc],	// d
        [0x1c, 0x2a, 0x2a, 0x2a, 0x10],	// e
        [0x10, 0x7e, 0x90, 0x90, 0x80],	// f
        [0x18, 0x25, 0x25, 0x25, 0x3e],	// g
        [0xfe, 0x20, 0x20, 0x20, 0x1e],	// h
        [0xbe, 0x02],					// i
        [0x02, 0x01, 0x01, 0x21, 0xbe],	// j
        [0xfe, 0x08, 0x14, 0x22],		// k
        [0xfe, 0x02],					// l
        [0x3e, 0x20, 0x18, 0x20, 0x1e],	// m
        [0x3e, 0x20, 0x20, 0x20, 0x1e],	// n
        [0x1c, 0x22, 0x22, 0x22, 0x1c],	// o
        [0x3f, 0x22, 0x22, 0x22, 0x1c],	// p
        [0x1c, 0x22, 0x22, 0x22, 0x3f],	// q
        [0x22, 0x1e, 0x22, 0x20, 0x10],	// r
        [0x12, 0x2a, 0x2a, 0x2a, 0x04],	// s
        [0x20, 0x7c, 0x22, 0x22, 0x04],	// t
        [0x3c, 0x02, 0x02, 0x3e],		// u
        [0x38, 0x04, 0x02, 0x04, 0x38],	// v
        [0x3c, 0x06, 0x0c, 0x06, 0x3c],	// w
        [0x22, 0x14, 0x08, 0x14, 0x22],	// x
        [0x39, 0x05, 0x06, 0x3c],		// y
        [0x26, 0x2a, 0x2a, 0x32],		// z - Ascii 122
        [0x10, 0x7c, 0x82, 0x82],		// {
        [0xee],							// |
        [0x82, 0x82, 0x7c, 0x10],		// }
        [0x40, 0x80, 0x40, 0x80],		// ~
        [0x60, 0x90, 0x90, 0x60],		// Degrees sign - Ascii 127
    ];

	static COS_TABLE = [
        0.000,0.035,0.070,0.105,0.140,0.174,0.208,0.243,0.276,0.310,0.343,0.376,0.408,0.439,0.471,0.501,0.531,0.561,0.589,0.617,0.644,
        0.671,0.696,0.721,0.745,0.768,0.790,0.810,0.830,0.849,0.867,0.884,0.900,0.915,0.928,0.941,0.952,0.962,0.971,0.979,0.985,0.991,
        0.995,0.998,1.000,1.000,0.999,0.997,0.994,0.990,0.984,0.977,0.969,0.960,0.949,0.938,0.925,0.911,0.896,0.880,0.863,0.845,0.826,
        0.806,0.784,0.762,0.739,0.715,0.690,0.664,0.638,0.610,0.582,0.554,0.524,0.494,0.463,0.432,0.400,0.368,0.335,0.302,0.268,0.234,
        0.200,0.166,0.131,0.096,0.062,0.027,-0.008,-0.043,-0.078,-0.113,-0.148,-0.182,-0.217,-0.251,-0.284,-0.318,-0.351,-0.383,-0.415,
        -0.447,-0.478,-0.508,-0.538,-0.567,-0.596,-0.624,-0.651,-0.677,-0.702,-0.727,-0.750,-0.773,-0.795,-0.815,-0.835,-0.854,-0.872,
        -0.888,-0.904,-0.918,-0.931,-0.944,-0.955,-0.964,-0.973,-0.981,-0.987,-0.992,-0.996,-0.998,-1.000,-1.000,-0.999,-0.997,-0.993,
        -0.988,-0.982,-0.975,-0.967,-0.957,-0.947,-0.935,-0.922,-0.908,-0.893,-0.876,-0.859,-0.840,-0.821,-0.801,-0.779,-0.757,-0.733,
        -0.709,-0.684,-0.658,-0.631,-0.604,-0.575,-0.547,-0.517,-0.487,-0.456,-0.424,-0.392,-0.360,-0.327,-0.294,-0.260,-0.226,-0.192,
        -0.158,-0.123,-0.088,-0.053,-0.018
     ];

    static SIN_TABLE = [
        1.000,0.999,0.998,0.994,0.990,0.985,0.978,0.970,0.961,0.951,0.939,0.927,0.913,0.898,0.882,0.865,0.847,0.828,0.808,0.787,
        0.765,0.742,0.718,0.693,0.667,0.641,0.614,0.586,0.557,0.528,0.498,0.467,0.436,0.404,0.372,0.339,0.306,0.272,0.238,0.204,
        0.170,0.135,0.101,0.066,0.031,-0.004,-0.039,-0.074,-0.109,-0.144,-0.178,-0.213,-0.247,-0.280,-0.314,-0.347,-0.379,-0.412,
       -0.443,-0.474,-0.505,-0.535,-0.564,-0.593,-0.620,-0.647,-0.674,-0.699,-0.724,-0.747,-0.770,-0.792,-0.813,-0.833,-0.852,
       -0.870,-0.886,-0.902,-0.916,-0.930,-0.942,-0.953,-0.963,-0.972,-0.980,-0.986,-0.991,-0.995,-0.998,-1.000,-1.000,-0.999,
       -0.997,-0.994,-0.989,-0.983,-0.976,-0.968,-0.959,-0.948,-0.936,-0.924,-0.910,-0.895,-0.878,-0.861,-0.843,-0.823,-0.803,
       -0.782,-0.759,-0.736,-0.712,-0.687,-0.661,-0.635,-0.607,-0.579,-0.550,-0.520,-0.490,-0.459,-0.428,-0.396,-0.364,-0.331,
       -0.298,-0.264,-0.230,-0.196,-0.162,-0.127,-0.092,-0.057,-0.022,0.013,0.048,0.083,0.117,0.152,0.187,0.221,0.255,0.288,
       0.322,0.355,0.387,0.419,0.451,0.482,0.512,0.542,0.571,0.599,0.627,0.654,0.680,0.705,0.730,0.753,0.776,0.797,0.818,0.837,
       0.856,0.874,0.890,0.906,0.920,0.933,0.945,0.956,0.966,0.974,0.981,0.988,0.992,0.996,0.999,1.000
    ];

	// Instance Variables
	_i2cAddress = null;
	_i2c = null;
	_rst = null;
	_gbuffer = null;
	_pixelCursor_x = 0;
	_pixelCursor_y = 0;
	_oledWidth = 0;
	_oledHeight = 0;
	_inverse = false;

    constructor(impI2Cbus = null, address = 0x3C, impRSTpin = null, displayWidth = 128, displayHeight = 32) {

        // Parameters:
    	// 1. The chosen CONFIGURED imp I2C bus object
    	// 2. The OLED's 7-bit I2C address as an integer
    	// 3. The chosen UNCONFIGURED imp pin object to control the Reset line, null if not used
    	// 4. OLED pixel width
    	// 5. OLED pixel height

    	if (impI2Cbus == null || address == 0) throw "SSD1306Pro instantiation error: invalid bus or address";

    	_i2c = impI2Cbus;
        _i2cAddress = address << 1;
        _rst = impRSTpin;
        if (_rst != null) _rst.configure(DIGITAL_OUT, LOW);

        _oledWidth = displayWidth;
        _oledHeight = displayHeight;

		// The graphics buffer is a blob comprising pixel_width / 8 bytes per text row.
		// Each byte stores eight column bits
		_gbuffer = blob(_oledWidth * (_oledHeight / 8));

    }

    function init() {

        //  Toggle the RST pin over 1ms + 10ms
		if (_rst != null) {
    	  	_rst.write(HIGH);
    	    imp.sleep(0.001);
    	    _rst.write(LOW);
    	    imp.sleep(0.01);
    		_rst.write(HIGH);
	    }

	    // Set values for 32 vs 64 height displays
	    local cp = "\x02";
	    local mx = "\x1F";
	    if (_oledHeight == 64) {
	        cp = "\x12";
	        mx = "\x3F";
	    }


        // Write the display settings
        _i2c.write(_i2cAddress, "\x00" + SSD1306_DISPLAYOFF);
        _i2c.write(_i2cAddress, "\x00" + SSD1306_SETDISPLAYCLOCKDIV + "\x80");
        _i2c.write(_i2cAddress, "\x00" + SSD1306_SETMULTIPLEX + mx);
        _i2c.write(_i2cAddress, "\x00" + SSD1306_SETDISPLAYOFFSET + "\x00");
        _i2c.write(_i2cAddress, "\x00" + SSD1306_SETSTARTLINE);
        _i2c.write(_i2cAddress, "\x00" + SSD1306_CHARGEPUMP + "\x14");
        _i2c.write(_i2cAddress, "\x00" + SSD1306_MEMORYMODE + "\x00"); // Horizontal addressing mode
        _i2c.write(_i2cAddress, "\x00" + SSD1306_SEGREMAP);
        _i2c.write(_i2cAddress, "\x00" + SSD1306_COMSCANDEC);
        _i2c.write(_i2cAddress, "\x00" + SSD1306_SETCOMPINS + cp);
        _i2c.write(_i2cAddress, "\x00" + SSD1306_SETCONTRAST + "\x8F");
        _i2c.write(_i2cAddress, "\x00" + SSD1306_SETPRECHARGE + "\xF1");
        _i2c.write(_i2cAddress, "\x00" + SSD1306_SETVCOMDETECT + "\x40");
        _i2c.write(_i2cAddress, "\x00" + SSD1306_DISPLAYALLON_RESUME);
        _i2c.write(_i2cAddress, "\x00" + SSD1306_NORMALDISPLAY);
        _i2c.write(_i2cAddress, "\x00" + SSD1306_DISPLAYON);

        // Clear the display
        clear().draw();

        // Home the cursor (0,0 - top left)
        local c = "\x03";
      	if (_oledHeight == 64) c = "\x07";
      	_i2c.write(_i2cAddress, "\x00" + SSD1306_COLUMNADDR + "\x00" + (_oledWidth - 1).tochar());
        _i2c.write(_i2cAddress, "\x00" + SSD1306_PAGEADDR + "\x00" + c);

	}

    function clear() {
        // Clears the display buffer by creating a new one
        // Squirrel garbage collection deals with the old buffer
        _gbuffer = blob(_oledWidth * (_oledHeight / 8));
        return this;
    }

    function plot(x, y, color = 1) {

		// Plot a point at the passed co-ordinates
      	if (x < 0 || x > (_oledWidth - 1) || y < 0 || y > (_oledHeight - 1)) return;
      	local byte = _coordsToIndex(x, y);
        local value = _gbuffer[byte];
        local bit = y - ((y >> 3) << 3);

        if (color == 1) {
        	// Set the pixel
          	value = value | (1 << bit);
            } else {
          	// Clear the pixel
          	value = value & ~(1 << bit);
        }

        _gbuffer[byte] = value;
        return this;

    }

    function line(x, y, tox, toy, thick = 1, color = 1) {

        // Check values
        if (thick < 1) thick = 1;

        // If necessary swap x and tox so we always scan L-R
        if (x > tox) {
            local a = x;
            x = tox;
            tox = a;
        }

	    // Calculate the line gradient
	    local m = (toy - y).tofloat() / (tox - x).tofloat();
	    local dy;

	    // Run for 'thick' times to generate thickness
	    for (local j = 0 ; j < thick ; j++) {
	        // Run from x to tox, calculating the y offset at each point
	        for (local i = x ; i < tox ; i++) {
	            dy = y + (m * (i - x)).tointeger() + j;
	            if (i >= 0 && i <_oledWidth && dy >=0 && dy < _oledHeight) plot(i, dy, color);
	        }
	    }

	    return this;

	}

	function circle(x, y, radius, color = 1, fill = false) {

        for (local i = 0 ; i < 180 ; i++) {

            local a = x - (radius * SIN_TABLE[i]).tointeger();
            local b = y - (radius * COS_TABLE[i]).tointeger();

            if (a >= 0 && a <_oledWidth && b >=0 && b < _oledHeight) {
                plot(a , b, color);
                if (fill) {
                    if (a > x) {
                        local j = x;
                        do {
                            plot(j, b, color);
                            j++;
                        } while (j < a);
                    } else {
                        local j = a + 1;
                        do {
                            plot(j, b, color);
                            j++;
                        } while (j <= x);
                    }
                }
            }

        }

        return this;

	}

    function rect(x, y, width, height, color = 1, fill = false) {

  	    if (!fill) {

			// Just present the frame
			for (local i = x ; i < x + width ; ++i) {
				if (i < _oledWidth) {
					plot(i, y, color);
					if (y + height < _oledHeight) plot(i, y + height, color);
				}
			}
			for (local i = y ; i < y + height ; ++i) {
				if (i < _oledHeight) {
					plot(x, i, color);
					if (x + width < _oledWidth) plot(x + width, i, color);
				}
			}

		} else {

			for (local j = y ; j < y + height ; ++j) {
				if (j < _oledHeight) {
					for (local i = x ; i < x + width ; ++i) {
						if (i < _oledWidth) {
							if (fill) {
								plot(i, j, color);
							} else {
								if (j == y || j == y + height - 1 || i == x || i == x + width - 1) { }
							}
						}
					}
				}
			}
		}

		return this;

	}

	function draw() {
        // Dummy function to call _render()
        _render();
        return this;
    }

	function inverseDisplay(setting = false) {

		// Set the entire display to black-on-white or white-on-black
		// Parameter:
		// 1. Boolean value determining inverse state of display
		// 'true' to inverse dislay, 'false' to put it back

		if (setting) {
			_i2c.write(_i2cAddress, "\x00" + SSD1306_INVERTDISPLAY);
		} else {
			_i2c.write(_i2cAddress, "\x00" + SSD1306_NORMALDISPLAY);
		}

	}

    function printBitmap(pixelArray, width, height = 100) {

	    // Displays a preformatted 128 x 32 or 128 x 64 bitmap image stored in a byte array
		// Note each byte consists of a row-high set of *vertical* pixels

		local xCount = 0;
		local yCount = 0;

		foreach (byte in pixelArray) {

            for (local i = 0 ; i < 8 ; i++) {

             local y = _pixelCursor_y + yCount + i;
             if ( y >= _oledHeight) break;
             local bit = y - ((y >> 3) << 3);
             local b = _coordsToIndex(_pixelCursor_x + xCount, y);
             local v = _gbuffer[b];

	         if ((1 << i) & byte) {
	             // Bit in image byte is set, so set bit in buffer byte
	             v = v | (1 << bit);
	          } else {
	             // Bit in image byte is not set, so clear bit in buffer byte
	             v = v & ~(1 << bit);
	          }

	          _gbuffer[b] = v;

	      }

        xCount++;
        if (xCount == width) {
            xCount = 0;
            yCount = yCount + 8;
        }

        if (yCount >= height || yCount >= _oledHeight) return this;

    	}

	  return this;

  }

    function setCursor(x = 0, y = 0) {

        // Places the graphics cursor at the passed co-ordinates
        if (x < 0 || x > (_oledWidth - 1) || y < 0 || y > (_oledHeight - 1)) return;
	    _pixelCursor_x = x;
	    _pixelCursor_y = y;
	    return this;

    }

	function text(printString = null, onlyReturnWidth = false) {

        // Display the input string on the display
		// Parameters:
		// 1. String to print
		// 2. Boolean - should the function just calculate the string's width?

		if (printString == null || printString.len() == 0) return -1;

        local width = 0;
        local i = _coordsToIndex(_pixelCursor_x,_pixelCursor_y);

        foreach (index, chr in printString) {

    	    local asc = printString[index] - 32;
    	    local glyph = charset[asc];
    	    width = width + glyph.len() + 1;

    	    for (local j = 0 ; j < glyph.len() ; ++j) {

                local c = _flip(glyph[j]);
                _gbuffer[i++] = c;

            }

        }

        if (!onlyReturnWidth) draw();
        return width;

	}

  /* ----- PRIVATE FUNCTIONS ----- */

    function _render() {
        _gbuffer.seek(0, 'b');
        _i2c.write(_i2cAddress, SSD1306_WRITETOBUFFER + _gbuffer.tostring());
    }

    function _coordsToIndex(x, y) {
        // Convert pixel co-ordinates to a _gbuffer blob index
        // Note: Calling function should check for valid co-ordinates first
        return ((y >> 3) * _oledWidth) + x;
    }

    function _indexToCoords(i) {
        // Convert _gbuffer blob index to pixel co-ordinates,
        // returned as an array [x, y]
        local y = i >> 4;
        local x = i - (y << 4);
        return ([x, y]);
    }

    function _flip(value) {

        // Rotates the character array from the saved state
        // to that required by the screen orientation
        local a = 0;
        local b = 0;

        for (local i = 0 ; i < 8 ; ++i) {
            a = value & (1 << i);

            if (_inverse) {
              if (a == 0) b = b + (1 << (7 - i));
            } else {
              if (a > 0) b = b + (1 << (7 - i));
            }
        }

        return b;

    }

}
