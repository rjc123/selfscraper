urlfile=$1
cache="cache/docs"
workingdocument='cache/htmlworkingdocument.html'
outputdoc='pdf_output.pdf'
targetfinaldoc="";

for html_document in $(cat $urlfile | sed 's/.*www/govuk/g' )
do
	sourcedirectory=$(echo $html_document | sed 's/govuk/www/; s/\/[^\/]*$//'  )
	targetfinaldoc=$(echo $sourcedirectory | sed 's/[^\.]*$/pdf/' )
	
	echo "PDFIFYING $html_document"
	cp $cache/$html_document/ordered_html.html $workingdocument

	#Clear unnecessary background images
	sed 's/<body[^>]*>/<body>/g' $workingdocument > $cache/supertempofile && mv $cache/supertempofile $workingdocument
	sed 's/<BODY[^>]*>/<body>/g' $workingdocument > $cache/supertempofile && mv $cache/supertempofile $workingdocument
  echo clearing the unnecessary background

	#Clear only known ugly link furniture tags
	sed 's/<[a|A].*<[i|I][m|M][g|G].*gif.*\/[a|A]>//g' $workingdocument  > cache/tmporarfile && mv cache/tmporarfile $workingdocument
	
	#Sort weird table widths
	sed 's/<table[^>]*>/<table>/g' $workingdocument > $cache/supertempofile && mv $cache/supertempofile $workingdocument
	sed 's/<TABLE[^>]*>/<table>/g' $workingdocument > $cache/supertempofile && cp $cache/supertempofile $workingdocument
	echo clearing the uncessary table params
	
	mv $workingdocument $cache/$sourcedirectory/htmlworkingdocument.html
#	wkhtmltopdf --minimum-font-size 2 -n -s A4 -B 12 -R 12 -L 12 -T 12 --no-background $cache/$sourcedirectory/htmlworkingdocument.html $cache/$outputdoc
	cupsfilter -o size=A2 -o fit-to-page $cache/$sourcedirectory/htmlworkingdocument.html > $cache/$outputdoc
	rm $sourcedirectory/htmlworkingdocument.html
	mv $cache/$outputdoc $cache/$targetfinaldoc
	echo $cache/$targetfinaldoc has been PDFified
	open $cache/$targetfinaldoc 
		
done
	