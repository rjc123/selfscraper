

urls=$1
cache="cache/docs/"
working="cache/docs/working"
rm $working/out*
rm $working/todo

for index_url in $(cat $urls) 
do
	echo $index_url > $working/out1	
	echo $index_url > $working/todo	

	while [ -s $working/todo ]
	do
		current_url=$(head -n1 $working/todo)	
		echo $current_url >> $working/out2
		
#		Figure out new links in the current working file		
		html=$(echo $current_url | sed 's/.*www/www/g' )
		grep -o '<a href[^>]*>' $cache/$html | 
			grep -o 'http[^\"]*' | 
			grep -v -x -f data/exclude.txt | 
			grep -x -f data/include.txt |
			grep -v -f $working/out2 | 
			grep -v -f $working/todo >> $working/todo

#		This code concatenates the HTML associated with the working file
		echo "START OF PAGE $current_url" >> $working/out3
		cat $cache/$html >> $working/out3
		echo "END OF PAGE $current_url" >> $working/out3

#		This code concatenates the markdown associated with the working file
#		mkdn=$(echo $current_url | sed 's/.*www/fymd/g' )
#		echo "START OF PAGE $index_url" >> $working/out3
#		cat $cache/$mkdn >> $working/out3

		tail -n +2 $working/todo | awk '!x[$0]++' > tmpfile && mv tmpfile $working/todo
		
	done
	
	cat $working/out2 | awk '!x[$0]++' > tmpfile && mv tmpfile $working/out2

done