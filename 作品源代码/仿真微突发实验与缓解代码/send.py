#!/usr/bin/env python
import argparse
import sys
import socket
import random
import struct
import os
from time import sleep


def main():
    i=0
    while i < 400:
        sleep(2)
        os.system("iperf3 -c 10.0.0.3 -t 1 -b 10M -p 5000")
        i = i + 1


if __name__ == '__main__':
    main()
