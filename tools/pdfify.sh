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

	#Add style sheet code
	sed 's/<head>/<head><link href="gdsstyle.css" rel="stylesheet" type="text\/css" media="all">/g' $workingdocument > $cache/supertempofile && mv -f $cache/supertempofile $workingdocument

	#Clear known ugly link furniture and tags
	sed '/<img[^>]*$/{N; s/\n//g;}; /<img[^>]*$/{N; s/\n//g;}; /<img[^>]*$/{N; s/\n//g;}; /<img[^>]*$/{N; s/\n//g;}; s/<img[^>]*blu\.gif[^>]*>//g; s/<img[^>]*brn\.gif[^>]*>//g;s/<img[^>]*dh\.gif[^>]*>//g; s/<img[^>]*btn\.gif[^>]*>//g; s/<img[^>]*line\.gif[^>]*>//g;' $workingdocument  > cache/tmporarfile && mv -f cache/tmporarfile $workingdocument
	sed '/<img[^>]*$/{N; s/\n//g;}; /<img[^>]*$/{N; s/\n//g;}; /<img[^>]*$/{N; s/\n//g;}; /<img[^>]*$/{N; s/\n//g;}; s/<img[^>]*home\.gif[^>]*>//g; s/<img[^>]*speech\.gif[^>]*>//g; s/<img[^>]*index\.gif[^>]*>//g; s/<img[^>]*press\.gif[^>]*>//g; s/<img[^>]*col-1\.gif[^>]*>//g;' $workingdocument  > cache/tmporarfile && mv -f cache/tmporarfile $workingdocument
	sed '/<img[^>]*$/{N; s/\n//g;}; /<img[^>]*$/{N; s/\n//g;}; /<img[^>]*$/{N; s/\n//g;}; /<img[^>]*$/{N; s/\n//g;}; s/<img[^>]*tback\.gif[^>]*>//g; s/<img[^>]*tforwar\.gif[^>]*>//g;s/<img[^>]*report\.gif[^>]*>//g; s/<img[^>]*home\.gif[^>]*>//g;s/<img[^>]*forward\.gif[^>]*>//g; s/<img[^>]*back\.gif[^>]*>//g;s/<img[^>]*upfooter\.gif[^>]*>//g;s/<img[^>]*spending\.gif[^>]*>//g;s/<img[^>]*statement\.gif[^>]*>//g; s/<img[^>]*header.\.gif[^>]*>//g; s/<img[^>]*shadowp.gif[^>]*>//g;s/<img[^>]*arms.gif[^>]*>//g;s/<img[^>]*tsoban.gif[^>]*>//g;' $workingdocument  > cache/tmporarfile && mv -f cache/tmporarfile $workingdocument
	sed '/We welcome/{N; N; N; s/We welcome.*this site\.//g; }' $workingdocument  > cache/tmporarfile && mv -f cache/tmporarfile $workingdocument
	sed 's/<[h|H][R|r][^>]*>//g' $workingdocument  > cache/tmporarfile && mv -f cache/tmporarfile $workingdocument
	sed 's/<[^>]*tsologo[^>]*>//g' $workingdocument  > cache/tmporarfile && mv -f cache/tmporarfile $workingdocument
	sed '/address/{N;s/<address.*\/address>//g;}' $workingdocument  > cache/tmporarfile && mv -f cache/tmporarfile $workingdocument
	sed '/offdocs\.css/{N;s/<link[^>]*offdocs\.css[^>]*>//g;}' $workingdocument  > cache/tmporarfile && mv -f cache/tmporarfile $workingdocument
	sed 's/position:absolute/position:inherit/g' $workingdocument  > cache/tmporarfile && mv -f cache/tmporarfile $workingdocument
	sed 's/>|</></' $workingdocument  > cache/tmporarfile && mv -f cache/tmporarfile $workingdocument
	sed '/font/{N;N;s/CC6666[^<]*/CC6666\">/;}' $workingdocument  > cache/tmporarfile && mv -f cache/tmporarfile $workingdocument
	sed 's/Order Now//; s/>Full Text</></; s/>Next</></; s/>Previous</></; s/>Contents</></; s/>Treasury Website</></;s/Full Text[^<]*//;s/Cover Page//' $workingdocument  > cache/tmporarfile && mv -f cache/tmporarfile $workingdocument
	sed 's/<td[^>]*>/<td>/g; s/<center>//; s/<\/center>/<br>/' $workingdocument  > cache/tmporarfile && mv -f cache/tmporarfile $workingdocument
sed 's/<font.*ublished\/font>//' $workingdocument  > cache/tmporarfile && mv -f cache/tmporarfile $workingdocument

	#Sort weird table widths
	sed 's/<table[^>]*>/<table>/g' $workingdocument > $cache/supertempofile && mv -f $cache/supertempofile $workingdocument
	sed 's/<TABLE[^>]*>/<table>/g' $workingdocument > $cache/supertempofile && mv -f $cache/supertempofile $workingdocument
	echo clearing the uncessary table params

	mv -f $workingdocument $cache/$sourcedirectory/htmlworkingdocument.html
	cp -f data/gdsstyle.css $cache/$sourcedirectory
	cupsfilter -o size=A4 -o fit-to-page -o scale-to-fit $cache/$sourcedirectory/htmlworkingdocument.html > $cache/$outputdoc
	mv -f $cache/$sourcedirectory/htmlworkingdocument.html $cache/$html_document/html_output_to_pdf.html
	echo $cache/$html_document/html_output_to_pdf.html has been PDFified
	rm $cache/$sourcedirectory/gdsstyle.css
	mv -f $cache/$outputdoc $cache/$targetfinaldoc
	echo $cache/$targetfinaldoc is the result

done

