url=$1

echo "Retrying a PDFIFICATION of $url"
touch doit
echo $url > doit

#Make PDFified version
sh tools/pdfify.sh doit

#Get JSONified version of attachment listing
sh tools/jsonify.sh doit 

#Move PDFs to output directory
sh tools/pdf-outputter.sh doit

#Construct an output file
sh tools/file-constructor.sh doit

#open cache/docs/$(echo $url | sed 's/.*www/govuk/g')/ordered_html.html -a TextWrangler

rm doit