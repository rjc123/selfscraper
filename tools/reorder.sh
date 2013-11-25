#tempreset of govuk working directory
#rm -r cache/docs/govuk*

urls=$1
cache="cache/docs"
working="cache/docs/working"

touch $working/out3

for index_url in $(cat $urls) 
do
	final_dir=$(echo $index_url | sed 's/.*www/govuk/g')
	mkdir -p $cache/$final_dir
	
	for current_url in $(cat cache/$final_dir/ordered_list_of_urls
	
	do
		
		html=$(echo $current_url | sed 's/.*www/www/g' )
		cat $cache/$html | iconv -c -t utf-8 >> $working/out3

		#	Add a page break
  	echo "<div style='page-break-before: always'><table><td></td></table></div>" >> $working/out3
		echo "" >> $working/out3
	
	done
			
	echo WORKING ON $index_url
	mv -f $working/out3 $cache/$final_dir/ordered_html.html
	
done
