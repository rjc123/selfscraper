urlfile=$1
cache="cache/docs"
workingdocument='cache/htmlworkingdocument.html'
outputdoc='cache/pdfoutput.pdf'

for html_document in $(cat $urlfile | sed 's/.*www/govuk/g' )
do
	echo "PDFIFYING $html_document"
	cp $cache/$html_document/ordered_html.html $workingdocument

	#Clear unnecessary background images
	sed 's/<body[^>]*>/<body>/g' $workingdocument > $cache/supertempofile && mv $cache/supertempofile $workingdocument

	wkhtmltopdf $workingdocument $outputdoc
	mv $outputdoc $cache/$html_document/pdf_output.pdf
	echo $html_document/$outputdoc has been PDFified
		
done
	