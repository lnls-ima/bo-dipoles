#!/usr/bin/env bash

for d in *; do

    cp $d/M1/0991p63A/z-positive/analysis.txt /home/facs/repos/MatlabMiddleLayer/Release/machine/SIRIUS/BO.V05.04/models/dipoles/$d-3gev-positive.txt && \
    cp $d/M1/0991p63A/z-negative/analysis.txt /home/facs/repos/MatlabMiddleLayer/Release/machine/SIRIUS/BO.V05.04/models/dipoles/$d-3gev-negative.txt;
done
