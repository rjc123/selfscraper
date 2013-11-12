urlfile=$1
cache="cache/docs"
workingdocument='cache/htmlworkingdocument.html'
outputdoc='pdf_output.pdf'

for html_document in $(cat $urlfile | sed 's/.*www/govuk/g' )
do
	sourcedirectory=$(echo $html_document | sed 's/govuk/www/; s/\/[^\/]*$//'  )
	
	echo "PDFIFYING $html_document"
	cp $cache/$html_document/ordered_html.html $workingdocument

	#Clear unnecessary background images
	sed 's/<body[^>]*>/<body>/g' $workingdocument > $cache/supertempofile && mv $cache/supertempofile $workingdocument
  echo clearing the unnecessary background

	mv $workingdocument $cache/$sourcedirectory/htmlworkingdocument.html
#	wkhtmltopdf --minimum-font-size 2 -n -s A4 -B 12 -R 12 -L 12 -T 12 --no-background $cache/$sourcedirectory/htmlworkingdocument.html $cache/$outputdoc
	cupsfilter -o size=A4 $cache/$sourcedirectory/htmlworkingdocument.html > $cache/$outputdoc
	rm $sourcedirectory/htmlworkingdocument.html
	mv $cache/$outputdoc $cache/$html_document/$outputdoc
	echo $cache/$html_document/$outputdoc has been PDFified
	open $cache/$html_document/$outputdoc 
		
done
	