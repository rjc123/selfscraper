#! /bin/bash
#Not only a spider, it recursively downloads the HTML of a list of urls
#usage: $1 file name $2 domain  

site_of_interest="archive.official-documents.co.uk"


# echo "" > cache/spider-done.txt #comment out to continue from last
sort $1 | uniq > cache/spider-to-do.txt 
 
while [ -s cache/spider-to-do.txt ]
do
	# if TODO list is not empty then do the following
	echo Left to do: $(wc -l cache/spider-to-do.txt)
          
	# get first LCCN from TODO list and store a copy
    lccn=$(head -n1 cache/spider-to-do.txt)

    if [ -n "$lccn" ]
    	then
			filelccn=$(echo $lccn | sed 's/.*fuckyeahmarkdown.*www\./fymd\./g' | sed 's/http:\/\///g' )
			
			echo "Processing $lccn, $filelccn"
 
          	# retrieve HTML page for LCCN and save a local copy
          	cd cache/docs 
          	mkdir -p $(echo $filelccn | sed 's/\/[^\/]*$//')
          	wget -q -k $lccn -O $filelccn 
        #  	iconv -c -t UTF8 $filelccn > tmpfile && mv tmpfile $filelccn
         	cd ../..
         
          	if [ -f "cache/docs/$filelccn" ]
		  	then

          		# go through page and find links
		  		grep -o -i "<a href=[^>]*>" cache/docs/$filelccn | sed "s/^.*http/http/g" |  sed 's/\".*$//g' | sed 's/#.*//g' | sort | uniq | grep -F $site_of_interest > cache/thispageurls
		  		echo Adding $(cat cache/thispageurls)	  
		  
		  		# add the urls that aren't done to the to-do list
		  		diff cache/spider-done.txt cache/thispageurls | grep ">" | sed 's/> //g' >> cache/spider-to-do.txt
		  		rm cache/thispageurls

		  	else
		  		echo "file missing! $filelccn"
		 
		  	fi 
  		 fi
 		  
 		 # remove LCCN from TODO list
         tail -n +2 cache/spider-to-do.txt | sort | uniq > cache/tmpfile &&
		 mv cache/tmpfile cache/spider-to-do.txt
		  
         # append LCCN to DONE list
         echo $lccn >> cache/spider-done.txt
 		 sort cache/spider-done.txt | uniq > cache/tmpfile &&
 		 mv cache/tmpfile cache/spider-done.txt
 
#          sleep 2
    
done