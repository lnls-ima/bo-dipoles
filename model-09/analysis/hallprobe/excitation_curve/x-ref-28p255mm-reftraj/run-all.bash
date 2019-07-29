#!/usr/bin/env bash

func=$1
side=$2

folder=/home/imas/repos/bo-dipoles/model-09/analysis/hallprobe/excitation_curve/x-ref-28p255mm-reftraj

function f1 {
  side=$1
  cd $folder/bd-006/0040p31A/$side; fac-fma-analysis.py run;
  cd $folder/bd-006/0050p39A/$side; fac-fma-analysis.py run;
}

function f2 {
  side=$1
  cd $folder/bd-006/0060p46A/$side; fac-fma-analysis.py run;
  cd $folder/bd-006/0165p27A/$side; fac-fma-analysis.py run;
}

function f3 {
  side=$1
  cd $folder/bd-006/0330p54A/$side; fac-fma-analysis.py run;
  cd $folder/bd-006/0500p00A/$side; fac-fma-analysis.py run;
}

function f4 {
  side=$1
  cd $folder/bd-006/0640p00A/$side; fac-fma-analysis.py run;
  cd $folder/bd-006/0680p00A/$side; fac-fma-analysis.py run;
}

function f5 {
  side=$1
  cd $folder/bd-006/0720p00A/$side; fac-fma-analysis.py run;
  cd $folder/bd-006/0800p00A/$side; fac-fma-analysis.py run;
}

function f6 {
  side=$1
  cd $folder/bd-006/0942p05A/$side; fac-fma-analysis.py run;
  cd $folder/bd-006/0991p63A/$side; fac-fma-analysis.py run;
  cd $folder/bd-006/1041p21A/$side; fac-fma-analysis.py run;
}




# function f1 {
#   subfolder=$1
#   side=$2
#   cd $folder/BC-02/$subfolder/$side; fac-fma-analysis.py rawfield; fac-fma-analysis.py trajectory; cd ../../../../
#   cd $folder/BC-03/$subfolder/$side; fac-fma-analysis.py rawfield; fac-fma-analysis.py trajectory; cd ../../../../
#   cd $folder/BC-04/$subfolder/$side; fac-fma-analysis.py rawfield; fac-fma-analysis.py trajectory; cd ../../../../
# }

# function f2 {
#   subfolder=$1
#   side=$2
#   cd $folder/BC-05/$subfolder/$side; fac-fma-analysis.py rawfield; fac-fma-analysis.py trajectory; cd ../../../../
#   cd $folder/BC-06/$subfolder/$side; fac-fma-analysis.py rawfield; fac-fma-analysis.py trajectory; cd ../../../../
#   cd $folder/BC-07/$subfolder/$side; fac-fma-analysis.py rawfield; fac-fma-analysis.py trajectory; cd ../../../../
# }

# function f3 {
#   subfolder=$1
#   side=$2
#   cd $folder/BC-08/$subfolder/$side; fac-fma-analysis.py rawfield; fac-fma-analysis.py trajectory; cd ../../../../
#   cd $folder/BC-09/$subfolder/$side; fac-fma-analysis.py rawfield; fac-fma-analysis.py trajectory; cd ../../../../
#   cd $folder/BC-10/$subfolder/$side; fac-fma-analysis.py rawfield; fac-fma-analysis.py trajectory; cd ../../../../
# }

# function f4 {
#   subfolder=$1
#   side=$2
#   cd $folder/BC-11/$subfolder/$side; fac-fma-analysis.py rawfield; fac-fma-analysis.py trajectory; cd ../../../../
#   cd $folder/BC-12/$subfolder/$side; fac-fma-analysis.py rawfield; fac-fma-analysis.py trajectory; cd ../../../../
#   cd $folder/BC-13/$subfolder/$side; fac-fma-analysis.py rawfield; fac-fma-analysis.py trajectory; cd ../../../../
# }

# function f5 {
#   subfolder=$1
#   side=$2
#   cd $folder/BC-14/$subfolder/$side; fac-fma-analysis.py rawfield; fac-fma-analysis.py trajectory; cd ../../../../
#   cd $folder/BC-15/$subfolder/$side; fac-fma-analysis.py rawfield; fac-fma-analysis.py trajectory; cd ../../../../
#   cd $folder/BC-16/$subfolder/$side; fac-fma-analysis.py rawfield; fac-fma-analysis.py trajectory; cd ../../../../
# }

# function f6 {
#   subfolder=$1
#   side=$2
#   cd $folder/BC-17/$subfolder/$side; fac-fma-analysis.py rawfield; fac-fma-analysis.py trajectory; cd ../../../../
#   cd $folder/BC-18/$subfolder/$side; fac-fma-analysis.py rawfield; fac-fma-analysis.py trajectory; cd ../../../../
#   cd $folder/BC-20/$subfolder/$side; fac-fma-analysis.py rawfield; fac-fma-analysis.py trajectory; cd ../../../../
#   cd $folder/BC-21/$subfolder/$side; fac-fma-analysis.py rawfield; fac-fma-analysis.py trajectory; cd ../../../../
# }

$func $side
