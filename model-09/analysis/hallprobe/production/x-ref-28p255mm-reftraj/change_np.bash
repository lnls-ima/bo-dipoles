#!/usr/bin/env bash

for ima in $(ls | grep bd); do

    cd $ima/M1/0991p63A/z-positive/ && \
    sed -i '/multipoles_perpendicular_grid/s/np/_np/g' multipoles.in && \
    cd ../../../../;

    cd $ima/M1/0991p63A/z-negative/ && \
    sed -i '/multipoles_perpendicular_grid/s/np/_np/g' multipoles.in && \
    cd ../../../../;

done
    '   '''
