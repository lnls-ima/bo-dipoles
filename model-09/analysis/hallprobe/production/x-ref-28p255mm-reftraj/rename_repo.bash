#!/usr/bin/env bash

for ima in $(ls | grep bd); do

    cd $ima/M1/0991p63A/z-positive/ && \
    sed -i '/fmap_filename/s/fac_files/imas/g' rawfield.in && \
    cd ../../../../;

    cd $ima/M1/0991p63A/z-positive/ && \
    sed -i '/fmap_filename/s/lnls-ima/repos/g' rawfield.in && \
    cd ../../../../;

    cd $ima/M1/0991p63A/z-negative/ && \
    sed -i '/fmap_filename/s/fac_files/imas/g' rawfield.in && \
    cd ../../../../;

    cd $ima/M1/0991p63A/z-negative/ && \
    sed -i '/fmap_filename/s/lnls-ima/repos/g' rawfield.in && \
    cd ../../../../;

done
