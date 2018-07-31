#!/usr/bin/env bash

for ima in $(ls | grep bd); do
    for fol in positive negative; do
        cd $ima/M1/0991p63A/z-$fol/ && \
        echo running magnet $ima in the $fol direction && \
        fac-fma-analysis.py run && \
        cd ../../../../;
    done
done
