#!/bin/bash
#
# Script to automate uploading to Youtube
# Main arguments, directory then playlist, finally sleep (minutes) between uploads [Progress wait]

# lets use this template
# arguments - name (Without extension) then playlist
function upload {

	titleName=${1//[_]/ }
	thumbnail="$1.png"
	file="$1.mp4"

	youtube-upload \
	--title="$titleName" \
	--description="Want to become part of our community or just find us? Follow our Facebook page at
https://www.facebook.com/profile.php?...

Keep up to date on our featured tournaments and even our stream, which can be found here
twitch.tv/syracusesmash

Thank you" \
	--category="Gaming" \
	--playlist="$2" \
	--tags="melee, smash4, singles, doubles, syracuse, cusetown, meltdown, biweekly, tournament" \
	--thumbnail="$thumbnail" \
	$file || :
}


dir=$1

upload_length=`ls -l $dir | grep '.mp4' | wc -l`
user_length=`id -u -n | wc -c`
user_length=$((user_length-1+45))

i=1
while [ $i -le $upload_length ];
do
	# first grab the file in the list
	# cut -c49- for Windows (cmder), -c46- for Linux (terminal)
	name=`ls -ltr $dir | grep '.mp4' | head -${i} | tail -1 | cut -c${user_length}- | cut -f 1 -d '.' | cut -c 1-`
	file=`echo "$dir$name.mp4" | tr -d ' '`
	png=`echo "$dir$name.png" | tr -d ' '`
	ezFile="$name.mp4"
	ezPng="$name.png"

	echo $ezFile

	cp $file .
	cp $png .	|| :

	upload $name $2
	
	rm -f $ezFile
	rm -f $ezPng || :
	
	if [ $3 -ne 0 ] ; then
		echo "Sleeping for $3 minutes."
		sleep ${3}m
	fi

	(( i++ ))
done;

echo "Complete"
