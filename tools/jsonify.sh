
urlfile=$1
cache="cache/docs/"
workingdocument='cache/workingdocument'

for raw_url in $(sed 's/.*www/govuk/g' $urlfile | cat)
do
	echo "WORKING ON ATTACHMENTS FOR $raw_url"
#	sh tools/determine-order.sh $raw_document
	
	echo "[" >> $workingdocument
	
	for attach_url in $(cat $cache/$raw_url/attachment_list)
		do
			echo "{ \"\"link\"\"=\"\"$attach_url\"\" , \"\"title\"\"=\"\""$(echo $attach_url | sed 's/[^\/]*$//')"\"\" } ," >> $workingdocument
		
		done
			
	echo "]" >> $workingdocument
done
sed '/}/N;s/} ,\n]/}]/' $workingdocument | sed '/\[/N;s/\[\n{/\[{/' > tmpola && mv tmpola $workingdocument
mv $workingdocument $cache/$raw_url/jsonified_attachments