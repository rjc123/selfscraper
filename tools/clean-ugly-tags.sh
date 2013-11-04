dirtyfile=$1
workingfile='cache/workingfile'
cp $dirtyfile $workingfile
for this_regex in $(cat data/clean-instructions.txt)
do

	sed -E "$this_regex" $workingfile > tmpfile && mv tmpfile $workingfile
	
done
uniq $workingfile | cat 
rm $workingfile