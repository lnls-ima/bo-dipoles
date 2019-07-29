#!/usr/bin/env bash

for d in *; do

    cp $d/z-positive/analysis.txt /home/facs/repos/MatlabMiddleLayer/Release/machine/SIRIUS/BO.V05.04/models/dipoles/excitation_curve/bd-006-$d-positive.txt && \
    cp $d/z-negative/analysis.txt /home/facs/repos/MatlabMiddleLayer/Release/machine/SIRIUS/BO.V05.04/models/dipoles/excitation_curve/bd-006-$d-negative.txt;

done
