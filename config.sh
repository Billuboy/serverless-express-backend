#!/bin/bash

# For bash shell
echo "reading envs from .env.production..."
cat .env.production | while read line
do
  key=$(echo $line | cut -f1 -d=)
  value=$(echo $line | cut -f2 -d=)

  if [[ $line != \#* ]];
  then 
    echo "exporting $key..."
    export $line
  fi
done