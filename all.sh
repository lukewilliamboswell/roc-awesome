#!/bin/bash

for file in ./*.roc
do
    roc test $file  
    roc dev $file
done