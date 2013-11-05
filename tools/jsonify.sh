
urlfile=$1
cache="cache/docs"
jsonworkingdocument='cache/workingdocument'
touch $jsonworkingdocument
for raw_url in $(sed 's/.*www/govuk/g' $urlfile | cat)
do
	echo "WORKING ON ATTACHMENTS FOR $raw_url"
#	sh tools/determine-order.sh $raw_document
	
	echo "[" >> $jsonworkingdocument
	
	for attach_url in $(cat $cache/$raw_url/attachment_list)
		do
			echo "{ \"\"link\"\":\"\"$attach_url\"\" , \"\"title\"\":\"\""$(echo $attach_url | sed 's/^.*\///g')"\"\" }," >> $jsonworkingdocument
		
		done
			
	sed '$s/},/}]/' $jsonworkingdocument | sed '/\[/N;s/\[\n{/\[{/' > $cache/tmpcola && mv $cache/tmpcola $cache/$raw_url/jsonified_attachments
	rm $jsonworkingdocument
	echo "$cache/$raw_url/jsonified_attachments has a new file of jsonofied attachments"

done