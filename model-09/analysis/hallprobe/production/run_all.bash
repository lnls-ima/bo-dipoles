#!/usr/bin/env bash

#cd x0-9p1013mm/
cd x0-9p0450mm-old/

for ima in $(ls | grep bd); do
    for fol in positive negative; do
        cd $ima/M1/0991p63A/z-$fol/ && \
        echo running magnet $ima in the $fol direction && \
        fac-fma-analysis.py run && \
        cd ../../../../;
    done
done

# for ima in $(ls | grep bd); do
#     for fol in positive negative; do
#         cd $ima/M1/0991p63A/z-$fol/ && \
#         echo running magnet $ima in the $fol direction && \
#         fac-fma-analysis.py clean && \
#         cd ../../../../;
#     done
# done
