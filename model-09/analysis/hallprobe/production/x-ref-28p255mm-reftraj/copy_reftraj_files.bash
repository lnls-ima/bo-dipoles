#!/usr/bin/env bash

for ima in $(ls | grep bd); do

    cd $ima/M1/0991p63A/z-positive/ && \
    # rm trajectory-bd-pos.in && \
    cp /home/facs/repos/MatlabMiddleLayer/Release/trajectory-bd-pos.txt . && \
    mv trajectory-bd-pos.txt trajectory-bd-pos.in && \
    cd ../../../../;

    cd $ima/M1/0991p63A/z-negative && \
    # rm trajectory-bd-neg.in && \
    cp /home/facs/repos/MatlabMiddleLayer/Release/trajectory-bd-neg.txt . && \
    mv trajectory-bd-neg.txt trajectory-bd-neg.in && \
    cd ../../../../;

done
