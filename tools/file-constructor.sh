
urls=$1
cache="cache/docs"
working="cache/docs/working"
finaloutput="finaloutput.csv"

echo "old_url§old_url_array§json_attachments§html_body§html_body_1§html_body_2§html_body_3§html_body_4§html_body_5§html_body_6§html_body_7§html_body_8§html_body_9§html_body_10§html_body_11§html_body_12§html_body_13§html_body_14§html_body_15§html_body_16§html_body_17§html_body_18§html_body_19§html_body_20§html_body_21§html_body_22§html_body_23§html_body_24§html_body_25§html_body_26§html_body_27§html_body_28§html_body_29§html_body_30§html_body_31§html_body_32§html_body_33§html_body_34§html_body_35§html_body_36§html_body_37§html_body_38§html_body_39§html_body_40§html_body_41§html_body_42§html_body_43§html_body_44§html_body_45§html_body_46§html_body_47§html_body_48§html_body_49§html_body_50" > $finaloutput

for raw_url in $(cat $urls)
do
	govuk=$(echo $raw_url | sed 's/.*www/govuk/g')
	
	#Write the root URL
	echo "\"$raw_url\"§\"\c" >> $finaloutput
	
	#Hash the ordered urls
	echo "["$(awk '{ print "\"\""$1"\"\"" "," }' $cache/$govuk/ordered_list_of_urls ) "]\"\c"  >> $finaloutput
	echo "§\"\c" >> $finaloutput
	
	#Write the JSONified attachment file
	echo $(cat $cache/$govuk/jsonified_attachments)"\c" >> $finaloutput	
	echo "\"§\"\c" >> $finaloutput	
		
	#Split the Markdownified file and write using a delimiter
	sed 's/\"/\"\"/g' $cache/$govuk/ordered_markdown_wip | awk '{ if ((NR % 600) == 0) printf("\"§\"\n"); print; }'  >> $finaloutput
	echo "\"" >> $finaloutput

done

sed 's/, ]/]/g' $finaloutput > $cache/tmply &&
	mv $cache/tmply $finaloutput
	