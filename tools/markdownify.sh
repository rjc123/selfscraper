
urlfile=$1
cache="cache/docs/"
workingdocument='cache/workingdocument'

for raw_document in $(sed 's/.*www/govuk/g' $urlfile | cat)
do
	echo "WORKING ON $raw_document"
#	sh tools/determine-order.sh $raw_document
	cp $cache$raw_document/ordered_html $workingdocument
		
	#Clean the really ugly tags
#	iconv -c -t utf-8 $workingdocument > cache/tmpfile && mv cache/tmpfile $workingdocument
	sh tools/clean-ugly-tags.sh $workingdocument > cache/tmpofile && cp cache/tmpofile $workingdocument

#Convert to markdown
#iconv -c -t utf-8 $workingdocument | pandoc -R -f html -t markdown_strict | iconv -c -f utf-8  > cache/output && mv cache/output $workingdocument
iconv -c -t utf-8 $workingdocument | pandoc -R -f html -t markdown_strict > cache/output && mv cache/output $workingdocument
echo "converting $raw_document to markdown"

#Clean the remainder tags
#grep -o '<[^>]*>' $workingdocument | sort | uniq >> cache/errortags
sed "s/<[^>]*>//g" $workingdocument | 
	sed "s/ / /g" |   						#non printable tab character becomes space
	sed "s/^ *#### *$//g" | 				#get rid of unnecessary headers
	sed "s/ +/ /g" | 
	sed "s/^ *$//g" | 
	sed "s/^> *$//g" | 
	sed "s/ *INDENL/> /g" | 
	sed "s/^.*\$CTA/\$CTA/g" | 
	sed "/\.gif/{ H; g; s/\n/ /g; h; }; x; P; " |	
	sed "s/[!|\[][^)]*\.gif[^\[]*//g" | 	# get rid of images used as links
	sed "/javascript/{ H; g; s/\n/ /g; h; }; x; P; " |	
	grep -v javascript | 					# get rid of javascript embedded in page
	sed "s/ +/ /g" | 
	uniq > cache/tmpfile && 
	mv -f cache/tmpfile $workingdocument &&
	mv -f $workingdocument $cache$raw_document/ordered_markdown_wip

done
