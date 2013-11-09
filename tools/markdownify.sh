
urlfile=$1
cache="cache/docs/"
workingdocument='cache/workingdocument'

for raw_document in $(cat $urlfile | sed 's/.*www/govuk/g' )
do
	echo "MARKDOWNIFYING $raw_document"
#	sh tools/determine-order.sh $raw_document
	cp $cache$raw_document/ordered_html.html $workingdocument
		
	#Clean the really ugly tags
#	iconv -c -t utf-8 $workingdocument > cache/tmpfile && mv cache/tmpfile $workingdocument
	echo "Cleaning Ugly Tags"
	sh tools/clean-ugly-tags.sh $workingdocument > cache/tmporfile && cp cache/tmporfile $workingdocument

#Convert to markdown
#iconv -c -t utf-8 $workingdocument | pandoc -R -f html -t markdown_strict | iconv -c -f utf-8  > cache/output && mv cache/output $workingdocument
echo "Converting $raw_document to markdown"
iconv -c -t utf-8 $workingdocument | pandoc -R -f html -t markdown_strict > cache/output && mv cache/output $workingdocument

#Clean the remainder tags
#grep -o '<[^>]*>' $workingdocument | sort | uniq >> cache/errortags

sed "s/<[^\/|^t][^>]*>//g" $workingdocument | 	#get rid of any non table tags
	sed "s/<\/[^t][^>]*>//g" |
	sed "s/<[^>]*tbody[^>]*>//g" | 	#get rid of tbody tags missed in previous tag removal
	sed "s/ / /g" |   						#non printable tab character becomes space
	sed "s/^ *#### *$//g" | 			#get rid of unnecessary headers
	sed "s/ +/ /g" | 							#get rid of unnecessary duplicated spaces
	sed "s/^\/$//g" |
	sed "s/^ *$//g" | 
	sed "s/^> *$//g" | 
	sed "s/<td[^>]*>/<td>/g" | 
	sed "s/<tr[^>]*>/<tr>/g" | 
	sed "s/^.\$CTA/\$CTA/g" | 
	sed "/\[\!/{ N; s/\n/ /g; s/\[\![^)]*.gif)[^)]*)//g; }" |  #kill images used as links
	sed "/\[\!/{ N; s/\n/ /g; s/\[\![^)]*.gif)[^)]*)//g; }" |  #run twice because of weirdo bash on mac problems
#	sed "/javascript/{ H; g; s/\n/ /g; h; }; x; P; " |	
#	grep -v javascript | 					# get rid of javascript embedded in page
	sed "s/ +/ /g" > cache/tmpfile && 
	mv -f cache/tmpfile $workingdocument &&
	mv -f $workingdocument $cache$raw_document/ordered_markdown_wip

done
