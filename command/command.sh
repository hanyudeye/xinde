#!/usr/bin/env bash
echo "abc"
#let "var <<= 2"
let var=5
let "var <<=2" #
echo $var
