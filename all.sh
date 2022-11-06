#!/bin/bash

# AOC 2021
cd ./aoc-2021
for file in *.roc
do
    roc test $file --prebuilt-platform true
    roc dev $file --prebuilt-platform true
done

# Project Euler
cd ../euler
for file in *.roc
do
    roc test $file --prebuilt-platform true
    roc dev $file --prebuilt-platform true
done