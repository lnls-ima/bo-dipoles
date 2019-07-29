#!/usr/bin/env bash

for d in *; do

    cd $d/z-positive/ && \
    # rm trajectory-bd-pos.in && \
    cp ../../trajectory-bd-pos.in . && \
    # mv trajectory-bd-pos.txt trajectory-bd-pos.in && \
    cd ../../;

    cd $d/z-negative && \
    # rm trajectory-bd-neg.in && \
    cp ../../trajectory-bd-neg.in . && \
    # mv trajectory-bd-neg.txt trajectory-bd-neg.in && \
    cd ../../;

done
