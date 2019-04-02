#!/usr/bin/env bash
# Created At Tue Apr 02 2019 8:22:26 PM 
# hugo preprocessing script
# 
# Copyright 2019 si9ma <hellob374@gmail.com>

# replace relative path
for file in `find . -name "*.md"`
do
    sed -i 's/..\/..\/static\/img/\/img/g' $file
done