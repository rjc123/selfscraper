
#Usage 
#sh scrape-interpreter $1=url_file

urls=$1

for index_url in $(cat $urls)
do
	output_array[0]=$index_url
	todo=$index_url

	output_array[1]=$index_url
	
	
	
	
	
	
	
	
	filepath=$(echo $index_url | sed 's/.*www[^\/]*\///g' )
	working_dir="cache/docs/working/$filepath"
	mkdir -p $working_dir
	echo $index_url > $working_dir/1
	echo $index_url > $working_dir/todo
	#Construct order of urls for the hash

	while [ -s $working_dir/todo ]
	do

		working_url=$(head -n1 $working_dir/todo)	
		echo $working_url >> $working_dir/2
		
		tail -n +2 $working_dir/todo > tmpfile &&
		mv tmpfile $working_dir/todo
		
		working_file=$(echo $working_url | sed 's/http\:\/\//cache\/docs\//g')		
		found=$(grep -i 'href' $working_file | grep -o 'http[^\"]*' | grep -v -F -f exclude.txt )
		echo $found >> $working_dir/todo
	
	done
	
#	while [ -s $working_dir/todo ]
#	do
#		working_markdown=$(echo $working_url | sed 's/http\:\/\/www/cache\/docs\/fymd/g')
#		cp $working_markdown $working_dir/$counter	
#	done

done