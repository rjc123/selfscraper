
dirtyfile=$1
cleaningfile='cache/cleaningfile'
cp $dirtyfile $cleaningfile

for this_regex in $(cat data/clean-instructions.txt)
do

	sed -E "$this_regex" $cleaningfile > smalltmpfile && mv smalltmpfile $cleaningfile
	
done

uniq $cleaningfile 
rm $cleaningfile