
#This is the script to run the full scrape 

urls=$1

#Get HTML
sh tools/spider.sh $urls 

sh tools/determine-order.sh $urls

#Get Markdownified version
sh tools/markdownify.sh $urls 

#Get JSONified version of attachments
sh tools/jsonify.sh $urls 


#Construct an output file
sh tools/file-constructor.sh $urls

