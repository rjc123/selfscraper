
url=$1

echo "Retrying a PDFIFICATION of $url"
touch doit
echo $url > doit
sh tools/full-scrape.sh doit