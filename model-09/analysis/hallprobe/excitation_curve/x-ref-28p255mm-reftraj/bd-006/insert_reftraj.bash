#!/usr/bin/env bash

for d in *; do

    cd $d/z-positive/ && \
    sed -i '/traj_load_filename/s/None/"trajectory-bd-pos.in"/g' trajectory.in && \
    cd ../../;

    cd $d/z-negative/ && \
    sed -i '/traj_load_filename/s/None/"trajectory-bd-neg.in"/g' trajectory.in && \
    cd ../../;

done
    '   '''
