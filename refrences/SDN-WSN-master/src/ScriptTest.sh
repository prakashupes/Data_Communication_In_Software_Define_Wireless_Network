#!/bin/sh

#!/usr/bin/env python2.7

> CummulativeStats.txt

python test.py

python Discover.py

python test.py

python Discover.py


for i in $(seq 0 27)
do
  echo "Starting $i th run";
  python test.py
  python Discover.py
done
