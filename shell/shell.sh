#!/usr/bin/env bash

cat /etc/passwd | awk -F ":" '{if($NR < 15 && $NF~/bash/) {print $0}}';
awk -F ":" 'BEGIN{sum =0} {sum = sum+$3} END {print sum}'
cat /etc/passwd | awk -F ":" '{if($3 > 100) {print $0}}'

echo "hello";

echo "nihao";
