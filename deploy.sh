#!/bin/bash

git pull

if [ "$1" == "cold" ]; then
  docker build -t crystallizer .
fi

sh run.sh
