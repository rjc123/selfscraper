
urls=$1
cache="cache/docs"
working="cache/docs/working"
finaloutput="finaloutput.csv"

echo "old_url,old_url_array,html_body_1,html_body_2,html_body_3,html_body_4,html_body_5,html_body_6,html_body_7,html_body_8,html_body_9,html_body_10,html_body_11,html_body_12,html_body_13,html_body_14,html_body_15,html_body_16,html_body_17,html_body_18,html_body_19,html_body_20,html_body_21,html_body_22,html_body_23,html_body_24,html_body_25,html_body_26,html_body_27,html_body_28,html_body_29,html_body_30,html_body_31,html_body_32,html_body_33,html_body_34,html_body_35,html_body_36,html_body_37,html_body_38,html_body_39,html_body_40" > $finaloutput

for raw_url in $(cat $urls)
do
	govuk=$(echo $raw_url | sed 's/.*www/govuk/g')
	
	#Hash the ordered urls
	echo "\"$raw_url\"," >> $finaloutput
	echo "\"["$(awk '{ print "\""$1"\"" "," }' $cache/$govuk/ordered_list_of_urls ) "]\"" | sed 's/, ]/]/' >> $finaloutput
	echo ",\"" >> $finaloutput
	
	#Split the Markdownified file and write using a delimiter
	sed 's/\"/\"\"/g' $cache/$govuk/ordered_markdown_wip | awk '{ if ((NR % 600) == 0) printf("\",\"\n"); print; }'  >> $finaloutput
	echo "\"" >> $finaloutput
	
done