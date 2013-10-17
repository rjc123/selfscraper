#! /bin/bash
 
echo "digraph G{" > spider-graph-temp.dot
echo "  node [color=grey, style=filled];" >> spider-graph-temp.dot
echo "  node [fontname=\"Verdana\", size=\"20,20\"];" >> spider-graph-temp.dot
cat spider-graph.dot >> spider-graph-temp.dot
echo "}" >> spider-graph-temp.dot
 
neato -Tpng -Goverlap=false spider-graph-temp.dot > spider-graph.png
display spider-graph.png &