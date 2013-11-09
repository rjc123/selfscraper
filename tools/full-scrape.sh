
#This is the script to run the full scrape 

urls=$1

#Get HTML of the page stored locally
sh tools/spider.sh $urls 
sh tools/determine-order.sh $urls

#Make Markdownified version
sh tools/markdownify.sh $urls 

#Make PDFified version
sh tools/pdfify.sh $urls

#Get JSONified version of attachment listing
sh tools/jsonify.sh $urls 

#Construct an output file
sh tools/file-constructor.sh $urls

