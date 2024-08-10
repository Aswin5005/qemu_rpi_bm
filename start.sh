#!/bin/bash

echo "Starting QEMU"

qemu-system-aarch64 -s -S -machine raspi3b -nographic -kernel kernel8.img -serial null -serial mon:stdio

#To Connect with GDB, run this on GDB terminal
#target remote localhost:1234

