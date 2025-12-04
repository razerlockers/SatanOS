#!/bin/bash
make clean
make
qemu-system-x86_64 -fda satanos.img
