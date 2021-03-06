
urls=$1
cache="cache/docs"
working="cache/docs/working"
output="output"
finaloutput="finaloutput.csv"

#construct file headers
#echo "root_old_url,old_url,attachment_1_url,attachment_1_title\c" > $finaloutput
#for i in {1..99}
#	do
#		echo ",html_body_$i\c" >> $finaloutput
#	done
#echo "" >> $finaloutput

for raw_url in $(cat $urls)
do
	govuk=$(echo $raw_url | sed 's/.*www/govuk/g')
	outurl=$(echo $raw_url | sed 's/.*www/www/g' | sed 's/[^\.]*$/pdf/' )

	#Write the root URL
	echo "\"$raw_url\",\"\c" >> $finaloutput
	
	#Hash the ordered urls
	echo "["$(awk '{ print "\"\""$1"\"\"" "," }' $cache/$govuk/ordered_list_of_urls ) "]\"\c"  >> $finaloutput
	echo ",\"\c" >> $finaloutput

	#Write the PDFified attachment file
	echo "https://github.com/rjc123/selfscraper/raw/master/$output/$outurl\",\"Manufactured PDF for $raw_url\"\c" >> $finaloutput

	#Write the JSONified attachment file
#	echo $(cat $cache/$govuk/jsonified_attachments)"\c" >> $finaloutput	
#	echo "\",\"\c" >> $finaloutput	
		
	#Split the Markdownified file and write using a delimiter
#	sed 's/\"/\"\"/g' $cache/$govuk/ordered_markdown_wip | awk '{ if ((NR % 750) == 0) printf("\",\"\n"); print; }'  >> $finaloutput

	echo "" >> $finaloutput
done

sed 's/, ]/]/g' $finaloutput > $cache/tmply &&
	mv $cache/tmply $finaloutput
	mv $finaloutput $urls.csv
	mv $urls.csv done

	