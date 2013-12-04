
#tempreset of govuk working directory
#rm -r cache/docs/govuk*


urls=$1
cache="cache/docs"
working="cache/docs/working"

rm $working/out*
rm $working/todo
mkdir -p $working
touch $working/out1
touch $working/out2
touch $working/out3
touch $working/out4
touch $working/todo



for index_url in $(cat $urls) 
do
	echo $index_url > $working/out1	
	echo $index_url > $working/todo
	final_dir=$(echo $index_url | sed 's/.*www/govuk/g')
	include=$(echo $index_url | grep -o 'www[^\/]*')
	mkdir -p $cache/$final_dir
	
	while [ -s $working/todo ]
	do
		current_url=$(head -n1 $working/todo)	
		echo $current_url >> $working/out2
		
#		Figure out new links in the current working file		
		html=$(echo $current_url | sed 's/.*www/www/g' )
		tidy $cache/$html > tmpola && mv -f tmpola $cache/$html
			sed '/href/{N; s/\n//g;}' $cache/$html | 
			grep -i -o 'href[^>]*' |
			grep -i -o 'http[^\"]*' | 			
			grep -i -o 'http[^\#]*' | 			
			grep -v -x -f data/exclude.txt | 			
			grep -x -f data/include.txt |
			grep -v -f $working/out2 | 
			grep -v -f $working/todo |
			grep $include >> $working/todo

#		This code concatenates the HTML associated with the working file
#		echo "<h2> START OF PAGE <a href='$current_url'>$current_url</a></h2>" >> $working/out3
#		echo "" >> $working/out3

		cat $cache/$html | iconv -c -t utf-8 | tidy >> $working/out3

#		Add a page break
    echo "<div style='page-break-before: always'><table><td></td></table></div>" >> $working/out3
 		echo "" >> $working/out3

#		cat $cache/$html |
#			sed -e 'N; s/\n/ /g' |
#			sed -n -e '/<[body|BODY]/,$p' |
#			sed -e '/<\/[body|BODY]/,$d' |
#			sed 's/<body[^>]*>//g' |
#			sed 's/<\/body[^>]*>//g' |
#			sed 's/<BODY[^>]*>//g' |
#			sed 's/<\/BODY[^>]*>//g' >> $working/out3
#		echo "END OF PAGE <a href='$current_url'>$current_url</a><br>" >> $working/out3
#		echo "" >> $working/out3

#		This code adds PDF and GIF attachments to out4
		grep -o '.*.pdf' $cache/$html >> $working/out4
		grep -o '.*.gif' $cache/$html >> $working/out4
		grep -v -f data/exclude.txt $working/out4 | 
			sort | uniq > $cache/cola && 
			mv -f $cache/cola $working/out4
		echo FOUND THESE ATTACHMENTS
		cat $working/out4

#		This code concatenates the FYMD markdown associated with the working file
#		mkdn2=$(echo $current_url | sed 's/.*www/kmdn/g' )
#		iconv -c -t utf-8 $cache/$html | pandoc -R -f html -t markdown | iconv -c -f utf-8  > $cache/$mkdn2
#		echo "START OF PAGE $current_url" >> $working/out5
#		echo "" >> $working/out5
#		cat $cache/$mkdn2 >> $working/out5
#		echo "END OF PAGE $current_url" >> $working/out5
#		echo "" >> $working/out5
		
		tail -n +2 $working/todo | awk '!x[$0]++' > cache/tmpfile && mv cache/tmpfile $working/todo
			
	done
	echo WORKING ON $index_url
#	cat $working/out2 | awk '!x[$0]++' 
	mv -f $working/out1 $cache/$final_dir/root_url
	mv -f $working/out2 $cache/$final_dir/ordered_list_of_urls
	mv -f $working/out3 $cache/$final_dir/ordered_html.html
	mv -f $working/out4 $cache/$final_dir/attachment_list
	
done
