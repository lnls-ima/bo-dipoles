#!/usr/bin/env bash

MODEL_VERSION=06
FIELDMAP_FILE="2014-09-18_Dipolo_Booster_BD_Modelo_6_-80_35mm_-1000_1000mm.txt"
FIELDMAP_ANALYSIS="model6-one-piece-extraction"

echo "setting official model to model-"${MODEL_VERSION}
echo "fieldmap file: "${FIELDMAP_FILE}
echo "fieldmap analysis: "${FIELDMAP_ANALYSIS}

cp -ra "../model-${MODEL_VERSION}/documentation" ./
cp -ra "../model-${MODEL_VERSION}/simulation-fieldmap/fieldmap-files/${FIELDMAP_FILE}" ./fieldmap-file.txt
cp -ra "../model-${MODEL_VERSION}/simulation-fieldmap/fieldmaptrack-analysis/${FIELDMAP_ANALYSIS}/analysis.txt" ./
cp -ra "../model-${MODEL_VERSION}/simulation-fieldmap/fieldmaptrack-analysis/${FIELDMAP_ANALYSIS}/field_on_trajectory.txt" ./
cp -ra "../model-${MODEL_VERSION}/simulation-fieldmap/fieldmaptrack-analysis/${FIELDMAP_ANALYSIS}/multipoles.txt" ./
cp -ra "../model-${MODEL_VERSION}/simulation-fieldmap/fieldmaptrack-analysis/${FIELDMAP_ANALYSIS}/trajectory.txt" ./
