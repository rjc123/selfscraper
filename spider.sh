#! /bin/bash
#usage: $1 file name $2 domain  

sort $1 | uniq > tmpfile &&
		  mv tmpfile $1 

 
while [ -s $1 ]
do
     # if TODO list is not empty then do the following
		
 		  echo "Left to do: $(wc -l $1)"
          # get first LCCN from TODO list and store a copy
          lccn=$(head -n1 $1)

       if [ -n "$lccn" ]
       then
 
          filelccn=$(echo $lccn | sed 's/http:\/\///g' )
          echo "Processing $i, $lccn, $filelccn"
 
          # retrieve HTML page for LCCN and save a local copy
          cd cache/docs &&
          wget -q -r -k $lccn &&
          cd ../..
         
          if [ -f "cache/docs/$filelccn" ]
		  then

          # go through page and find links
		  grep -o "<a href=[^>]*>" cache/docs/$filelccn | sed "s/<a href=\"//g" | sed 's/\".*//g' | sed 's/#.*//g' | sort | uniq | grep -F "www.archive.official-documents.co.uk/document" > thispageurls
		  echo Adding $(cat thispageurls)	  
		  
		  # add the urls that aren't done to the to-do list
		  diff spider-done.txt thispageurls | grep ">" | sed 's/> //g' >> spider-to-do.txt

          # get personal name for LCCN
#          currname=$(xmlstarlet sel -T -t -m "/Identity/nameInfo" -o "\"" -v "rawName/suba" -o "\"" -n ${lccn}.xml | tr -d ' ')
#          echo "Current name $currname"
 
          # pull out LCCNs for associated ids and get personal names
#          associd=$(xmlstarlet sel -T -t -m "/Identity/associatedNames/name" -v "normName" -n ${lccn}.xml | grep 'lccn')
 
#          echo "Associated LCCNs"
#          echo $associd
 
#          assocname=$(xmlstarlet sel -T -t -m "/Identity/associatedNames/name" -o "\"" -v "rawName/suba" -o "\"" -n ${lccn}.xml | tr -d ' ')
 
#          echo "Associated names"
#          echo $assocname
 
          # save links between LCCNs in GRAPH file
#          for a in ${assocname[@]}
#          do
#               echo "  "${currname}" -> "${a}";" >> spider-graph.dot
#          done
 
          # if LCCNs for assoc ids not in DONE list, add to TODO list
#          for a in ${associd[@]}
#          do
#               if ! fgrep -q ${a} $1
#               then
#                    echo ${a} >> $1
#               fi
#          done
		  else
		  echo "file missing! $filelccn"
		 
		  fi 
  		  fi
 		  
 		  # remove LCCN from TODO list
          tail -n +2 $1 | sort | uniq > tmpfile &&
		  mv tmpfile $1
		  
          # append LCCN to DONE list
          echo $lccn >> spider-done.txt
 		  sort spider-done.txt | uniq > tmpfile &&
 		  mv tmpfile spider-done.txt
 
#          sleep 2
    
done