rm -rf log.txt; touch log.txt

./run-all.bash f1 z-positive >> log.txt &
./run-all.bash f1 z-negative >> log.txt &
./run-all.bash f2 z-positive >> log.txt &
./run-all.bash f2 z-negative >> log.txt &
./run-all.bash f3 z-positive >> log.txt &
./run-all.bash f3 z-negative >> log.txt &
./run-all.bash f4 z-positive >> log.txt &
./run-all.bash f4 z-negative >> log.txt &
./run-all.bash f5 z-positive >> log.txt &
./run-all.bash f5 z-negative >> log.txt &
./run-all.bash f6 z-positive >> log.txt &
./run-all.bash f6 z-negative >> log.txt &
