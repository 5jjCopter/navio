#!/bin/bash

 sudo mavproxy.py --master=/dev/ttyAMA0 --baudrate 57600 --out 192.168.1.150:14550 --aircraft MyCopter
