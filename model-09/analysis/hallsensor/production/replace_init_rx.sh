#!/usr/bin/env bash

for ima in $(ls | grep bd); do
    for fol in positive negative; do
        cd $ima/M1/0991p63A/z-$fol/ && \
        sed -i '/traj_init_rx/s/\(.*\)[0-9\.]\{6\}\(.*\)/\19.0450\2/' trajectory.in && \
        cd ../../../../;
    done
done
