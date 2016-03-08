#!/bin/bash

#sudo docker build -t mahmoudelgamal/spark-base spark-base
sudo docker build -t kiwenlau/hadoop-master hadoop-master #&> /dev/null
sudo docker build -t kiwenlau/hadoop-slave hadoop-slave #&> /dev/null


