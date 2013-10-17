#! /bin/bash
 
rm spider-done.txt
rm -r spider-graph*
rm -r cache
cp resetstart spider-to-do.txt
mkdir cache
mkdir cache/docs
echo "" > spider-done.txt