
urls=$1
cache="cache/docs"

#cd $cache &&
wget -nc -x -E -i $urls --no-cookies -r -l 0 -p -np -r -m  -e robots=off -w 0.1 
#cd ..

for downloaded_file in $(ls -R | grep '\.htm$') 
do 
	target=$(echo $downloaded_file | sed 's/\.htm/\.pdf/')
	cupsfilter $downloaded_file -o media=A7 -o fit-to-page -o cpi=21 -o lpi=12 -o prettyprint > $target
done