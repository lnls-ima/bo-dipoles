#!/usr/bin/env bash

MODEL_VERSION=03
FIELDMAP_FILE="2011-05-2015 Quadrupolo_Anel_Q14_Modelo 3_-14_14mm_-500_500mm.txt"
FIELDMAP_ANALYSIS="analysis1"


echo "setting official model to model-"${MODEL_VERSION}
echo "fieldmap file: "${FIELDMAP_FILE}
echo "fieldmap analysis: "${FIELDMAP_ANALYSIS}

cp -ra "../model-${MODEL_VERSION}/documentation" ./
cp -ra "../model-${MODEL_VERSION}/simulation-fieldmap/fieldmap-files/${FIELDMAP_FILE}" ./fieldmap-file.txt
cp -ra "../model-${MODEL_VERSION}/simulation-fieldmap/fieldmaptrack-analysis/${FIELDMAP_ANALYSIS}/analysis.txt" ./
cp -ra "../model-${MODEL_VERSION}/simulation-fieldmap/fieldmaptrack-analysis/${FIELDMAP_ANALYSIS}/field_on_trajectory.txt" ./
cp -ra "../model-${MODEL_VERSION}/simulation-fieldmap/fieldmaptrack-analysis/${FIELDMAP_ANALYSIS}/multipoles.txt" ./
cp -ra "../model-${MODEL_VERSION}/simulation-fieldmap/fieldmaptrack-analysis/${FIELDMAP_ANALYSIS}/trajectory.txt" ./
