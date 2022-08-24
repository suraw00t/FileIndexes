#!/bin/sh

##root_dir=$HOME/public_html
#dirFile=$HOME/codes/dirs.txt
#base=$HOME/codes/assets/templates/base

root_dir=$HOME/Projects/manual_indexes
dirFile=$HOME/Projects/manual_indexes/dirs.txt
base=$HOME/Projects/manual_indexes/assets/templates/base

baseHeader=`cat $base/head.html`
baseBody=`cat $base/body.html`
baseBottom=`cat $base/bottom.html`
bodyParentDir=`cat $base/parent-dir.html`
basePHP=`cat $base/base-php.php`

split_template() {
	echo "Hello from split_template()"
	return 0
}

render_template() {
	echo "Hello world from render_remplate() $1"
	return 0
}

run_tree() {
	for i in $(find $1 -type d) 
	do	
#		echo $i | awk -F '/public_html' '{print $2 SF "/"}'
#		cd $i && rm -f index.html
		cd $i && tree -a -h -D -C --du -F -H '.' -L 1 -T "Index of $(echo $i | awk -F '/public_html' '{print $2 SF ""}')" --dirsfirst --noreport --charset utf-8 -I "*.php|*.html" | sed "${bodyParentDir}" | sed '/<a class=\"NORM\" href=\".\">.<\/a>/d' | sed '/<meta name/,/$\">/d' | sed '/<style/,/<\/style>/d' | sed "/<meta/s/$/\n ${baseHeader}/" | sed "/<p class/,/<\/p>/d" | sed "/<\/p>/,/<\/p>/d" | sed "/<hr>/s/$/\n\t${baseBottom}/" | sed "/<br><br>/s/$/\n\t<\/p>\n\t<p>\n\t<br><br>\n\t<\/p>\n\t${basePHP}\n/" > index.php 
	done
}

read_file2() {
	#read -p "Enter file name : " filename
#	while read line
#	do 
#		echo $line
#	done < $1

	value=`cat $1`
	echo "$value"
	echo $1
}

read_dirs() {
	while IFS= read -r line
	do
#		echo "$line"
		run_tree $root_dir/$line
	done < "$1"
}

#echo "Reading $dirFile"

#read_dirs $dirFile
read_file2 $base/temp.html

echo "++++++++++  Updated  ++++++++++"
