
#This is the script to run the full scrape 

urls=$1
limitdomain=$2

#Get HTML
sh tools/spider.sh $urls $limitdomain

#Get Markdownified version
sh tools/markdownify.sh $urls $limitdomain

#Clean the Markdownified versions
#Not necessary until we have a constructed file

#Construct an output file


