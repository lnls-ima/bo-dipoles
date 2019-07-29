#!/usr/bin/env bash

for ima in $(ls | grep bd); do

    cd $ima/M1/0991p63A/z-positive/ && \
    sed -i '/traj_load_filename/s/None/"trajectory-bd-pos.in"/g' trajectory.in && \
    cd ../../../../;

    cd $ima/M1/0991p63A/z-negative/ && \
    sed -i '/traj_load_filename/s/None/"trajectory-bd-neg.in"/g' trajectory.in && \
    cd ../../../../;

done
    '   '''
