#! /bin/bash
#Not only a spider, it recursively downloads the HTML of a list of urls
#usage: $1 filename

cache="cache/docs"

#Clear spider history
rm cache/spider-done.txt
rm cache/spider-to-do.txt
touch cache/spider-done.txt

# echo "" > cache/spider-done.txt #comment out to continue from last
sort $1 | uniq > cache/spider-to-do.txt

#Loop over the spider-to-do list
while [ -s cache/spider-to-do.txt ]
do

	# if TODO list is not empty then do the following
	echo Left to do: $(wc -l cache/spider-to-do.txt)

	# get first LCCN from TODO list and store a copy
  lccn=$(head -n1 cache/spider-to-do.txt)
	filelccn=$(echo $lccn | sed 's/http:\/\///g' )
	domain=$(echo $lccn | grep -o 'www[^\/]*')

    if [ -n "$lccn" ]
    	then
				echo "Spidering $lccn"

       	# retrieve HTML page for LCCN and save a local copy with furniture
       	mkdir -p $cache/$(echo $filelccn | sed 's/\/[^\/]*$//')
			  if [ -f "$cache/$filelccn" ]
				then
		  		echo "Skipping $cache/$filelccn - already downloaded"
      	else
		  		echo "Downloading $cache/$filelccn - not already downloaded"
		  		wget -x -E --no-cookies -D $domain -p -np -P$cache -e robots=off -k --random-wait $lccn
		  	fi

        if [ -f "$cache/$filelccn" ]
		  	then
		  	  echo "file found! $filelccn"
          		# go through page and find links
		  		iconv -t UTF8//IGNORE $cache/$filelccn |
		  		sed "/<[^>]*$/{N; s/\n//g; }" |
		  		grep -o -i "href=[^>]*" |
		  			sed "s/^.*http/http/g" |
		  			sed 's/\".*$//g' |
		  			sed "s/\'.*$//g" |
		  			sed 's/#.*//g' |
		  			sort | uniq |
		  			grep -v -f data/exclude.txt |
#		  			grep -v pdf | 									#exclude pdfs from download
		  			grep $domain > cache/thispageurls
		  		echo "URLs found: $(cat cache/thispageurls)"

		  		# add the urls that aren't done to the to-do list
		  		diff cache/spider-done.txt cache/thispageurls | grep ">" | sed 's/> //g' >> cache/spider-to-do.txt
		  		rm cache/thispageurls

		  	else
		  		echo "file missing! $cache/$filelccn"
		  	fi
  	fi

 		# remove LCCN from TODO list
		tail -n +2 cache/spider-to-do.txt | sort | uniq > cache/tmpfile &&
			mv -f cache/tmpfile cache/spider-to-do.txt

    # append LCCN to DONE list
    echo $lccn >> cache/spider-done.txt
 		sort cache/spider-done.txt | uniq > cache/tmpfile &&
 			mv -f cache/tmpfile cache/spider-done.txt

done
