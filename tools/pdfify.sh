urlfile=$1
cache="cache/docs"
workingdocument='cache/htmlworkingdocument.html'
outputdoc='pdf_output.pdf'
targetfinaldoc="";

for html_document in $(cat $urlfile | sed 's/.*www/govuk/g' ) 
do

	sourcedirectory=$(echo $html_document | sed 's/govuk/www/; s/\/[^\/]*$//'  )
	sourcecontent=$(echo $html_document | sed 's/govuk/www/' )
	targetfinaldoc=$(echo $html_document | sed 's/[^\.]*$/pdf/' )
	
	echo "PDFIFYING $html_document"
	cp $cache/$html_document/ordered_html.html $workingdocument
	
	#Add style sheet
	sed 's/<head>/<head><link href="gdsstyle.css" rel="stylesheet" type="text\/css" media="print">/g' $workingdocument > $cache/supertempofile && mv -f $cache/supertempofile $workingdocument

	#Clear unnecessary background images
	#	sed 's/<body[^>]*>/<body>/g' $workingdocument > $cache/supertempofile && mv -f $cache/supertempofile $workingdocument
	#	sed 's/<BODY[^>]*>/<body>/g' $workingdocument > $cache/supertempofile && mv -f $cache/supertempofile $workingdocument
	#  echo clearing the unnecessary background

	#Clear only known ugly link furniture tags
	sed '/<img[^>]*$/{N; s/\n//g;}; s/<img[^>]*blu\.gif[^>]*>//g; s/<img[^>]*btn\.gif[^>]*>//g; s/<img[^>]*line\.gif[^>]*>//g;' $workingdocument  > cache/tmporarfile && mv -f cache/tmporarfile $workingdocument
	sed '/<img[^>]*$/{N; s/\n//g;}; s/<img[^>]*home\.gif[^>]*>//g; s/<img[^>]*speech\.gif[^>]*>//g; s/<img[^>]*index\.gif[^>]*>//g; s/<img[^>]*press\.gif[^>]*>//g;' $workingdocument  > cache/tmporarfile && mv -f cache/tmporarfile $workingdocument
	sed '/We welcome/{ N; s/We welcome.*this site\.//g; }' $workingdocument  > cache/tmporarfile && mv -f cache/tmporarfile $workingdocument
	sed 's/<[h|H][R|r][^>]*>//g' $workingdocument  > cache/tmporarfile && mv -f cache/tmporarfile $workingdocument
	sed 's/<[^>]*tsologo[^>]*>//g' $workingdocument  > cache/tmporarfile && mv -f cache/tmporarfile $workingdocument
	sed '/address/{N;s/<address.*\/address>//g;}' $workingdocument  > cache/tmporarfile && mv -f cache/tmporarfile $workingdocument
	
	#Sort weird table widths
	sed 's/<table[^>]*>/<table>/g' $workingdocument > $cache/supertempofile && mv -f $cache/supertempofile $workingdocument
	sed 's/<TABLE[^>]*>/<table>/g' $workingdocument > $cache/supertempofile && mv -f $cache/supertempofile $workingdocument
	echo clearing the uncessary table params
	
	mv -f $workingdocument $cache/$sourcedirectory/htmlworkingdocument.html
	cp data/gdsstyle.css $cache/$sourcedirectory
	cupsfilter -o size=A2 -o fit-to-page $cache/$sourcedirectory/htmlworkingdocument.html > $cache/$outputdoc
	rm $cache/$sourcedirectory/htmlworkingdocument.html
	rm $cache/$sourcedirectory/gdsstyle.css
	mv -f $cache/$outputdoc $cache/$targetfinaldoc	
	echo $cache/$targetfinaldoc has been PDFified
	open $cache/$targetfinaldoc 
		
done

	