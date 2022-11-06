#!/bin/bash

# AOC 2021
for file in ./aoc-2021/*.roc
do
    roc test $file
    roc dev $file
done

# Project Euler
for file in ./euler/*.roc
do
    roc test $file
    roc dev $file
done