#!/usr/bin/env bash
# Created At Tue Apr 02 2019 8:38:32 PM 
# blog build script
# 
# Copyright 2019 si9ma <hellob374@gmail.com>

rm -rf build && mkdir build && rsync -ar --exclude="./build" ./ ./build && cd build && ./preprocess.sh && hugo $@