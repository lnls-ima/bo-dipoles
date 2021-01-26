#!/usr/bin/env bash

for d in *; do
    cd $d/z-positive/ && \
    sed -i '/multipoles_perpendicular_grid/s/np/_np/g' multipoles.in && \
    cd ../../;

    cd $d/z-negative/ && \
    sed -i '/multipoles_perpendicular_grid/s/np/_np/g' multipoles.in && \
    cd ../../;

done
