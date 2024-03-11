#!/bin/bash

# For fish shell
if test $argv[1]; and test $argv[1] = "--env=local"
  set file .env.development
else if test $argv[1]; and test $argv[1] = "--env=test"
  set file .env.testing
else 
  set file .env.production
end
echo "reading envs from $file..."
cat $file | while read line
  if string length -q $line; and not string match -q '#*' $line
    set key $(echo $line | cut -f1 -d=)
    set value $(echo $line | cut -f2 -d=)
    echo "exporting $key... "
    export $line
  end
end