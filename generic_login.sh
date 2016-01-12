#!/bin/sh

coop() {
# login to the website.

curl -b cookie.txt -c cookie.txt --data \
"action=hidden_field&Username=Username&password=password" \
6 https://website.com/login.htm 2> /dev/null


#go to the desired page.

curl -b cookie.txt -c cookie.txt \
https://website.com/information.htm \
# the 2> /dev/null removes the downloading information
-o postings.txt 2> /dev/null


# if there are many divs, look for some text that identifies yours.
# grep -nia will return the line number.

start=`< all_info.html grep -nia \
'div class="box boxContent" style="float: left;width: 195px;margin: 5px;' \
|sed -n 's/:/ /p'| awk '{print $1}'` # pipe to sed to remove the trailing ':'
# pipe to awk print only the number portion of it.


# if there are many similar tags and you want the first, then tell it how far to look.

end=`expr $start + 40`


# use the $start,$end range to save to file and ignore remaining text.

sed -n "$start,$end p" all_info.html >  subsection.html


#remove the complete html file.
rm all_info.html


(
	# remove the tags in front of the data you want to display.
	# sorry for using sed | sed.. It worked so I didn't touch it..

	count=`sed -n 's/[^0-9]*class="badge badge-info">//p' subsection.html | sed -r\
	's/[0-9]+/& /' |awk '{print $1}'`


	# print the data you want to display.

	echo $count


# format the output however you want it!
) | awk '{print "\tFor My program: " $1 "\t| Applied to: " $2 "\t| Viewed: " $3}'\
> /home/user/.file.txt # redirect to hidden file if you don't want your ~/ cluttured.
}

ping=$( { ping https://website.com/login.htm -q -w -1 -c 1 > /dev/null; } 2>&1 )

if [[ $ping != *"ping: unknown host website.com"* ]]; then
	coop;
fi

