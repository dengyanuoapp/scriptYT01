#!/bin/sh

echo 

while [ 1 ]
do
	echo 	"$$(cat nohup.out |tail -n 1)"
	echo
	sleep 10
done
